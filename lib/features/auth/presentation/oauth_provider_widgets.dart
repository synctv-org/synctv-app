import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synctv_app/contracts/account_models.dart';

const String nativeAppleSignInButtonViewType =
    'org.synctv.app/apple_sign_in_button';

String oauthProviderKind({required String type, required String name}) {
  final normalizedType = type.trim().toLowerCase();
  return normalizedType.isEmpty ? name.trim().toLowerCase() : normalizedType;
}

bool isAppleOAuthProvider(OAuth2ProviderOption provider) {
  return oauthProviderKind(type: provider.type, name: provider.name) == 'apple';
}

bool isNativeAppleOAuthProvider(OAuth2ProviderOption provider) {
  return isAppleOAuthProvider(provider) && provider.supportsNative;
}

bool isBrowserAppleOAuthProvider(OAuth2ProviderOption provider) {
  return isAppleOAuthProvider(provider) && provider.supportsBrowser;
}

bool shouldUseNativeAppleOAuth(
  OAuth2ProviderOption provider,
  TargetPlatform platform,
) {
  return isNativeAppleOAuthProvider(provider) &&
      supportsNativeAppleSignInButton(platform);
}

bool shouldUseAppleSignInButton(
  OAuth2ProviderOption provider,
  TargetPlatform platform,
) {
  return !kIsWeb &&
      isAppleOAuthProvider(provider) &&
      supportsNativeAppleSignInButton(platform);
}

enum OAuth2ClientAuthorizationMode { browser, native }

/// Selects the strongest flow available on this client for a provider.
///
/// Native Apple authorization is preferred on Apple platforms when the
/// server advertises it. A browser flow remains a valid fallback whenever
/// the server advertises browser authorization.
OAuth2ClientAuthorizationMode? selectOAuth2AuthorizationMode(
  OAuth2ProviderOption provider, {
  required TargetPlatform platform,
  required bool browserAvailable,
  required bool nativeAvailable,
}) {
  if (shouldUseNativeAppleOAuth(provider, platform) && nativeAvailable) {
    return OAuth2ClientAuthorizationMode.native;
  }
  if (provider.supportsBrowser && browserAvailable) {
    return OAuth2ClientAuthorizationMode.browser;
  }
  return null;
}

bool isOAuthProviderAvailable(
  OAuth2ProviderOption provider, {
  required bool browserAvailable,
  required bool nativeAvailable,
}) {
  return selectOAuth2AuthorizationMode(
        provider,
        platform: defaultTargetPlatform,
        browserAvailable: browserAvailable,
        nativeAvailable: nativeAvailable,
      ) !=
      null;
}

String oauthProviderDisplayName({required String type, required String name}) {
  return switch (oauthProviderKind(type: type, name: name)) {
    'qq' => 'QQ',
    'github' => 'GitHub',
    'google' => 'Google',
    'microsoft' => 'Microsoft',
    'discord' => 'Discord',
    'casdoor' => 'Casdoor',
    'logto' => 'Logto',
    'oidc' => 'OpenID Connect',
    'feishu' => 'Feishu',
    'gitee' => 'Gitee',
    'apple' => 'Apple',
    _ => name.trim().isEmpty ? type.trim() : name.trim(),
  };
}

class OAuthProviderIcon extends StatelessWidget {
  const OAuthProviderIcon({
    super.key,
    required this.type,
    required this.name,
    this.size = 18,
  });

  final String type;
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brandIcon = switch (oauthProviderKind(type: type, name: name)) {
      'qq' => FontAwesomeIcons.qq,
      'github' => FontAwesomeIcons.github,
      'google' => FontAwesomeIcons.google,
      'microsoft' => FontAwesomeIcons.microsoft,
      'discord' => FontAwesomeIcons.discord,
      'gitee' => FontAwesomeIcons.gitee,
      'oidc' => FontAwesomeIcons.openid,
      'apple' => FontAwesomeIcons.apple,
      _ => null,
    };
    if (brandIcon != null) {
      return FaIcon(brandIcon, size: size);
    }
    final materialIcon = switch (oauthProviderKind(type: type, name: name)) {
      'feishu' => Icons.flight_takeoff_rounded,
      'casdoor' => Icons.shield_outlined,
      'logto' => Icons.login_rounded,
      _ => Icons.account_circle_outlined,
    };
    return Icon(materialIcon, size: size);
  }
}

bool supportsNativeAppleSignInButton(TargetPlatform platform) {
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
}

class AppleSignInButton extends StatefulWidget {
  const AppleSignInButton({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final String semanticLabel;
  final bool enabled;

  @override
  State<AppleSignInButton> createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends State<AppleSignInButton> {
  MethodChannel? _channel;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _onPlatformViewCreated(int viewId) {
    _channel?.setMethodCallHandler(null);
    final channel = MethodChannel(
      'org.synctv.app/apple_sign_in_button/$viewId',
    );
    channel.setMethodCallHandler((call) async {
      if (call.method == 'pressed' && widget.enabled) {
        widget.onPressed();
      }
    });
    _channel = channel;
  }

  @override
  Widget build(BuildContext context) {
    final platform = defaultTargetPlatform;
    assert(supportsNativeAppleSignInButton(platform));
    final style = Theme.of(context).brightness == Brightness.dark
        ? 'white'
        : 'black';
    final creationParams = <String, Object>{'style': style};
    final platformView = switch (platform) {
      TargetPlatform.iOS => UiKitView(
        key: ValueKey('apple-sign-in-$style'),
        viewType: nativeAppleSignInButtonViewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
      TargetPlatform.macOS => AppKitView(
        key: ValueKey('apple-sign-in-$style'),
        viewType: nativeAppleSignInButtonViewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      ),
      _ => throw UnsupportedError(
        'The native Sign in with Apple button requires an Apple platform',
      ),
    };

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.semanticLabel,
      onTap: widget.enabled ? widget.onPressed : null,
      excludeSemantics: true,
      child: SizedBox(
        height: 44,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Opacity(
            opacity: widget.enabled ? 1 : 0.48,
            child: platformView,
          ),
        ),
      ),
    );
  }
}
