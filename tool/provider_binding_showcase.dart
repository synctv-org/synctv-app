import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili;

void main() {
  final gateway = Uri.base.queryParameters['transport'] == 'api'
      ? _QueryPreviewGateway()
      : _PreviewGateway();
  runApp(
    MaterialApp(
      theme: Uri.base.queryParameters['dark'] == '1'
          ? AppTheme.dark
          : AppTheme.light,
      locale: const Locale(
        String.fromEnvironment('PREVIEW_LOCALE', defaultValue: 'en'),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyRegistryScope(
        values: {
          ProviderGateway: gateway,
          DesktopWebVerificationClient: _PreviewVerifier(),
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              double.parse(
                const String.fromEnvironment(
                  'PREVIEW_TEXT_SCALE',
                  defaultValue: '3',
                ),
              ),
            ),
          ),
          child: Directionality(
            textDirection: Uri.base.queryParameters['direction'] == 'rtl'
                ? TextDirection.rtl
                : Directionality.of(context),
            child: child!,
          ),
        ),
      ),
      home: Scaffold(
        body: Uri.base.queryParameters['actions'] == 'long'
            ? const _DialogActionsPreview()
            : PlatformBindingDialog(
                initialProviderType:
                    Uri.base.queryParameters['provider'] ?? 'fnos',
              ),
      ),
    ),
  );
}

class _DialogActionsPreview extends StatelessWidget {
  const _DialogActionsPreview();

  @override
  Widget build(BuildContext context) => Center(
    child: AppActionButton(
      label: 'Edit settings',
      wrapLabel: true,
      icon: Icons.edit_outlined,
      onPressed: () => AppDialogs.showStyledDialog<void>(
        context: context,
        title: 'Save',
        icon: const Icon(Icons.save_outlined),
        content: const Text('Room settings'),
        actions: [
          AppDialogs.createCancelButton(context),
          AppDialogs.createConfirmButton(
            context,
            () => Navigator.of(context).pop(),
            text: 'Save changes and continue',
          ),
        ],
      ),
    ),
  );
}

class _QueryPreviewGateway extends _PreviewGateway {
  late final _service = SyncTvProviderDomainService(
    SyncTvApiClient(
      baseUrl: 'https://preview.example.test',
      session: SyncTvSession()
        ..updateAccountTokens(accessToken: 'preview-only'),
      httpClient: MockClient((request) async {
        if (request.url.path != '/api/providers/emby/binds') {
          return http.Response('Instance directory unavailable', 503);
        }
        return http.Response(
          jsonEncode({
            'binds': [
              for (final instance in ['', 'remote'])
                {
                  'id': instance.isEmpty ? 'local-id' : 'remote-id',
                  'serverId': instance.isEmpty
                      ? 'local-server'
                      : 'remote-server',
                  'host': 'https://media.example.test/shared-library',
                  'userId': instance.isEmpty
                      ? 'Local account'
                      : 'Remote account',
                  'providerInstanceName': instance,
                },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    ),
  );

  @override
  Future<List<EmbyBindInfo>> getAllEmbyBindInfos() =>
      _service.getAllEmbyBindInfos();
}

// Simulated challenges only; this preview cannot authenticate a real account.
class _PreviewGateway implements ProviderGateway {
  int attempts = 0;
  int qrAttempts = 0;
  int accountAttempts = 0;
  int unbindAttempts = 0;
  int embyLoadAttempts = 0;
  int bilibiliLoadAttempts = 0;
  final Set<String> _removedEmbyServers = {};
  bool _bilibiliBound = Uri.base.queryParameters['bound'] == '1';

  @override
  Future<List<EmbyBindInfo>> getAllEmbyBindInfos() async {
    if (Uri.base.queryParameters['bindings'] == 'slow') {
      await Future<void>.delayed(const Duration(seconds: 30));
    }
    if (Uri.base.queryParameters['bindings'] == 'retry') {
      final attempt = embyLoadAttempts++;
      await Future<void>.delayed(const Duration(seconds: 3));
      if (attempt == 0) {
        throw StateError('Preview provider temporarily unavailable');
      }
    }
    return [
      if (Uri.base.queryParameters['accounts'] == 'long')
        for (var index = 0; index < 3; index++)
          if (!_removedEmbyServers.contains(
            'emby-server-01234567890123456789-$index',
          ))
            EmbyBindInfo(
              id: 'preview-$index',
              serverId: 'emby-server-01234567890123456789-$index',
              host: 'https://media.example.test/shared-family-library',
              userId: 'family-member-01234567890123456789-$index',
              createdAt: 0,
              providerInstanceName: 'Shared media source for the family',
            ),
    ];
  }

  @override
  Future<void> logoutEmby(String serverId) async {
    _removedEmbyServers.add(serverId);
  }

  @override
  Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async {
    final attempt = bilibiliLoadAttempts++;
    if (Uri.base.queryParameters['bindings'] == 'refresh-slow' && attempt > 0) {
      await Future<void>.delayed(const Duration(seconds: 30));
    }
    if (Uri.base.queryParameters['bindings'] == 'refresh' && attempt == 1) {
      throw StateError('Preview refresh temporarily unavailable');
    }
    return [
      if (_bilibiliBound)
        const BilibiliBindInfo(
          id: 'preview',
          serverId: 'bilibili-server-01234567890123456789',
          createdAt: 0,
          providerInstanceName: 'Shared media source for the family',
        ),
    ];
  }

  @override
  Future<BilibiliAccountInfo> getBilibiliAccount({
    String instanceName = '',
  }) async {
    final attempt = accountAttempts++;
    final scenario = Uri.base.queryParameters['details'];
    await Future<void>.delayed(Duration(seconds: scenario == 'slow' ? 30 : 3));
    if (scenario == 'retry' && attempt == 0) {
      throw StateError('Preview details temporarily unavailable');
    }
    return const BilibiliAccountInfo(
      isLogin: true,
      userId: 1,
      username: 'Shared family account with a long display name',
      face: '',
      isVip: false,
    );
  }

  @override
  Future<void> logoutBilibili() async {
    final attempt = unbindAttempts++;
    if (Uri.base.queryParameters['unbind'] == 'retry') {
      await Future<void>.delayed(const Duration(seconds: 10));
      if (attempt == 0) {
        throw StateError('Preview unbind temporarily unavailable');
      }
    }
    _bilibiliBound = false;
  }

  @override
  Future<BilibiliSmsLoginInfo> startBilibiliSmsLogin({
    String instanceName = '',
  }) async => const BilibiliSmsLoginInfo(
    sessionToken: 'preview',
    gt: 'preview',
    challenge: 'preview',
    expiresAt: 0,
  );

  @override
  Future<BilibiliSmsLoginInfo> sendBilibiliSms({
    required BilibiliSmsLoginInfo session,
    required String phone,
    required String validate,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return session;
  }

  @override
  Future<void> loginBilibiliSms({
    required String sessionToken,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 30));
    throw StateError('Preview login failed');
  }

  @override
  Future<BilibiliQrLoginInfo> startBilibiliQrLogin({
    String instanceName = '',
  }) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (Uri.base.queryParameters['qr'] == 'retry' && qrAttempts++ == 0) {
      throw StateError('Preview temporary failure');
    }
    return const BilibiliQrLoginInfo(
      url: 'https://example.test/preview-qr',
      key: 'preview-only',
    );
  }

  @override
  Future<bilibili.QRLoginStatus> checkBilibiliQrLogin(
    String key, {
    String instanceName = '',
  }) async {
    await Future<void>.delayed(const Duration(seconds: 30));
    return Uri.base.queryParameters['qr'] == 'hold'
        ? bilibili.QRLoginStatus.QR_LOGIN_STATUS_NOT_SCANNED
        : bilibili.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS;
  }

  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async => Uri.base.queryParameters['instances'] == 'collision'
      ? [
          'Local instance',
          'Local instance (Default)',
          'Local instance (Default) 2',
          'Preview media server',
        ]
      : ['Preview media server'];

  @override
  Future<FnosLoginInfo> loginFnos({
    required String endpoint,
    required String username,
    required String password,
    String webdavEndpoint = '',
    String mediaEndpoint = '',
    String twoFactorCode = '',
    bool trustDevice = true,
    String instanceName = '',
  }) async => FnosTwoFactorRequiredInfo(setupRequired: attempts++ == 0);

  @override
  Future<NextcloudLoginFlowInfo> startNextcloudLoginFlow(
    String endpoint,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 30));
    throw StateError('Preview authorization unavailable');
  }

  @override
  Future<NextcloudBindInfo> loginNextcloud({
    required String endpoint,
    required String username,
    required String appPassword,
    String instanceName = '',
  }) async {
    await Future<void>.delayed(const Duration(seconds: 30));
    throw StateError('Preview authentication failed');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}

class _PreviewVerifier implements DesktopWebVerificationClient {
  @override
  bool get supported => true;

  @override
  Future<String> verify({
    required String html,
    required String bridgeName,
    required String title,
    required double windowWidth,
    required double windowHeight,
    required Duration timeout,
    String? browserPath,
    Map<String, String> browserFragmentParameters = const {},
  }) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return '{"validate":"preview-only"}';
  }
}
