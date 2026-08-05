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

class NativeAppleSignInButton extends StatefulWidget {
  const NativeAppleSignInButton({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final String semanticLabel;
  final bool enabled;

  @override
  State<NativeAppleSignInButton> createState() =>
      _NativeAppleSignInButtonState();
}

class _NativeAppleSignInButtonState extends State<NativeAppleSignInButton> {
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
