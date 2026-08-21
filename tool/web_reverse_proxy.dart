import 'dart:async';
import 'dart:io';

const _defaultListenPort = 8081;
const _defaultAppUpstream = 'http://127.0.0.1:8083';
const _defaultApiUpstream = 'http://localhost:8080';

Future<void> main(List<String> args) async {
  final config = _ProxyConfig.fromArgs(args);
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    config.listenPort,
  );
  stdout.writeln(
    'SyncTV web reverse proxy listening on '
    'http://localhost:${server.port}',
  );
  stdout.writeln('Flutter web upstream: ${config.appUpstream}');
  stdout.writeln('SyncTV API upstream: ${config.apiUpstream}');

  await for (final request in server) {
    unawaited(_handleRequest(request, config));
  }
}

class _ProxyConfig {
  const _ProxyConfig({
    required this.listenPort,
    required this.appUpstream,
    required this.apiUpstream,
  });

  final int listenPort;
  final String appUpstream;
  final String apiUpstream;

  factory _ProxyConfig.fromArgs(List<String> args) {
    var listenPort = _defaultListenPort;
    var appUpstream = _defaultAppUpstream;
    var apiUpstream = _defaultApiUpstream;

    for (var index = 0; index < args.length; index++) {
      final arg = args[index];
      if (arg.startsWith('--listen-port=')) {
        listenPort = int.parse(arg.substring('--listen-port='.length));
      } else if (arg == '--listen-port' && index + 1 < args.length) {
        listenPort = int.parse(args[++index]);
      } else if (arg.startsWith('--app-upstream=')) {
        appUpstream = arg.substring('--app-upstream='.length);
      } else if (arg == '--app-upstream' && index + 1 < args.length) {
        appUpstream = args[++index];
      } else if (arg.startsWith('--api-upstream=')) {
        apiUpstream = arg.substring('--api-upstream='.length);
      } else if (arg == '--api-upstream' && index + 1 < args.length) {
        apiUpstream = args[++index];
      } else {
        throw FormatException('Unknown argument: $arg');
      }
    }

    return _ProxyConfig(
      listenPort: listenPort,
      appUpstream: appUpstream,
      apiUpstream: apiUpstream,
    );
  }
}

const _hopByHopHeaders = {
  'connection',
  'content-length',
  'host',
  'keep-alive',
  'proxy-authenticate',
  'proxy-authorization',
  'te',
  'trailer',
  'transfer-encoding',
  'upgrade',
};

const _webSocketHandshakeHeaders = {
  'connection',
  'sec-websocket-extensions',
  'sec-websocket-key',
  'sec-websocket-protocol',
  'sec-websocket-version',
  'upgrade',
};

final _upstreamHttpClient = HttpClient()
  ..findProxy = null
  ..autoUncompress = false;

Future<void> _handleRequest(HttpRequest request, _ProxyConfig config) async {
  try {
    final isWebSocket =
        request.headers.value(HttpHeaders.upgradeHeader)?.toLowerCase() ==
        'websocket';
    final isApiPath =
        request.uri.path == '/api' ||
        request.uri.path.startsWith('/api/') ||
        request.uri.path.startsWith('/ws/rooms/');

    final upstream = isApiPath ? config.apiUpstream : config.appUpstream;
    if (isWebSocket) {
      await _proxyWebSocket(request, _upstreamUri(upstream, request.uri));
    } else {
      await _proxyHttp(request, _upstreamUri(upstream, request.uri));
    }
  } catch (error, stackTrace) {
    stderr.writeln('Proxy error: $error\n$stackTrace');
    try {
      request.response.statusCode = HttpStatus.badGateway;
      request.response.write('Proxy error: $error');
      await request.response.close();
    } catch (_) {
      // The connection may already be closed or upgraded.
    }
  }
}

Future<void> _proxyHttp(HttpRequest request, Uri upstreamUri) async {
  final upstreamRequest = await _upstreamHttpClient.openUrl(
    request.method,
    upstreamUri,
  );
  _copyHeaders(request.headers, upstreamRequest.headers);
  final body = await request.fold<List<int>>(
    <int>[],
    (all, chunk) => all..addAll(chunk),
  );
  if (body.isNotEmpty) {
    upstreamRequest.add(body);
  }

  final upstreamResponse = await upstreamRequest.close();
  request.response.statusCode = upstreamResponse.statusCode;
  _copyHeaders(upstreamResponse.headers, request.response.headers);
  await upstreamResponse.pipe(request.response);
  await request.response.close();
}

Future<void> _proxyWebSocket(HttpRequest request, Uri upstreamUri) async {
  final clientSocket = await WebSocketTransformer.upgrade(request);
  try {
    final upstreamWebSocketUri = Uri(
      scheme: upstreamUri.scheme == 'https' ? 'wss' : 'ws',
      host: upstreamUri.host,
      port: upstreamUri.hasPort ? upstreamUri.port : null,
      path: upstreamUri.path,
      query: upstreamUri.hasQuery ? upstreamUri.query : null,
    );
    final headers = <String, dynamic>{};
    _copyWebSocketHeaders(request.headers, headers);
    final protocolsHeader = request.headers.value('sec-websocket-protocol');
    final protocols = protocolsHeader
        ?.split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    final serverSocket = await WebSocket.connect(
      upstreamWebSocketUri.toString(),
      headers: headers,
      protocols: protocols,
      customClient: _upstreamHttpClient,
    );
    clientSocket.listen(
      (data) {
        if (serverSocket.readyState == WebSocket.open) {
          serverSocket.add(data);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        stderr.writeln('WebSocket client error: $error\n$stackTrace');
        serverSocket.close();
      },
      onDone: () => serverSocket.close(),
    );
    serverSocket.listen(
      (data) {
        if (clientSocket.readyState == WebSocket.open) {
          clientSocket.add(data);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        stderr.writeln('WebSocket upstream error: $error\n$stackTrace');
        clientSocket.close();
      },
      onDone: () => clientSocket.close(),
    );
  } catch (_) {
    await clientSocket.close();
    rethrow;
  }
}

void _copyHeaders(HttpHeaders source, HttpHeaders target) {
  source.forEach((name, values) {
    if (_hopByHopHeaders.contains(name.toLowerCase())) return;
    target.set(name, values);
  });
}

void _copyWebSocketHeaders(HttpHeaders source, Map<String, dynamic> target) {
  source.forEach((name, values) {
    final lower = name.toLowerCase();
    if (_hopByHopHeaders.contains(lower) ||
        _webSocketHandshakeHeaders.contains(lower) ||
        lower == 'origin') {
      return;
    }
    target[name] = values.length == 1
        ? values.single
        : List<String>.from(values);
  });
}

Uri _upstreamUri(String upstream, Uri requestUri) {
  final base = Uri.parse(upstream);
  return base.replace(
    path: requestUri.path,
    query: requestUri.hasQuery ? requestUri.query : null,
  );
}
