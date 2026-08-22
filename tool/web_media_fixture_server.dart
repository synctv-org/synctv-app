import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/web_media_fixture_server.dart DIR [PORT]',
    );
    exitCode = 64;
    return;
  }
  final root = Directory(arguments.first).absolute;
  if (!root.existsSync()) {
    stderr.writeln('Fixture directory does not exist: ${root.path}');
    exitCode = 66;
    return;
  }
  final port = arguments.length > 1 ? int.parse(arguments[1]) : 18181;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('Serving ${root.path} at http://127.0.0.1:$port');
  await for (final request in server) {
    await _serve(request, root);
  }
}

Future<void> _serve(HttpRequest request, Directory root) async {
  stdout.writeln('${request.method} ${request.uri.path}');
  request.response.headers
    ..set(HttpHeaders.accessControlAllowOriginHeader, '*')
    ..set(HttpHeaders.accessControlAllowMethodsHeader, 'GET, HEAD, OPTIONS')
    ..set(HttpHeaders.accessControlAllowHeadersHeader, 'Range')
    ..set(HttpHeaders.accessControlExposeHeadersHeader, 'Content-Range')
    ..set(HttpHeaders.acceptRangesHeader, 'bytes')
    ..set(HttpHeaders.cacheControlHeader, 'no-store');
  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
    return;
  }
  if (request.method != 'GET' && request.method != 'HEAD') {
    request.response.statusCode = HttpStatus.methodNotAllowed;
    await request.response.close();
    return;
  }

  final relativePath = request.uri.pathSegments
      .map(Uri.decodeComponent)
      .join('/');
  final file = File('${root.path}/$relativePath').absolute;
  if (!_isInside(root, file) || !file.existsSync()) {
    request.response.statusCode = HttpStatus.notFound;
    await request.response.close();
    return;
  }

  final length = await file.length();
  final range = _parseRange(
    request.headers.value(HttpHeaders.rangeHeader),
    length,
  );
  final start = range?.$1 ?? 0;
  final end = range?.$2 ?? length - 1;
  request.response.headers.contentType = _contentType(file.path);
  request.response.contentLength = length == 0 ? 0 : end - start + 1;
  if (range != null) {
    request.response.statusCode = HttpStatus.partialContent;
    request.response.headers.set(
      HttpHeaders.contentRangeHeader,
      'bytes $start-$end/$length',
    );
  }
  if (request.method == 'GET' && length > 0) {
    await request.response.addStream(file.openRead(start, end + 1));
  }
  await request.response.close();
}

bool _isInside(Directory root, File file) {
  final rootPrefix = '${root.absolute.path}${Platform.pathSeparator}';
  return file.absolute.path.startsWith(rootPrefix);
}

(int, int)? _parseRange(String? value, int length) {
  if (value == null || length == 0) return null;
  final match = RegExp(r'^bytes=(\d+)-(\d*)$').firstMatch(value.trim());
  if (match == null) return null;
  final start = int.parse(match.group(1)!);
  final requestedEnd = match.group(2)!;
  final end = requestedEnd.isEmpty ? length - 1 : int.parse(requestedEnd);
  if (start >= length || start > end) return null;
  return (start, end.clamp(start, length - 1));
}

ContentType _contentType(String path) =>
    switch (path.toLowerCase().split('.').last) {
      'mp4' || 'm4s' => ContentType('video', 'mp4'),
      'm3u8' => ContentType('application', 'vnd.apple.mpegurl'),
      'mpd' => ContentType('application', 'dash+xml'),
      'flv' => ContentType('video', 'x-flv'),
      'ts' => ContentType('video', 'mp2t'),
      'js' => ContentType('application', 'javascript'),
      _ => ContentType.binary,
    };
