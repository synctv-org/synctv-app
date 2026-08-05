import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/features/auth/presentation/oauth_provider_widgets.dart';

void main() {
  test('recognizes Apple from the provider name when the type is empty', () {
    const provider = OAuth2ProviderOption(
      name: 'apple',
      type: '',
      signupEnabled: true,
      signupNeedReview: false,
    );

    expect(isAppleOAuthProvider(provider), isTrue);
    expect(
      oauthProviderDisplayName(type: provider.type, name: provider.name),
      'Apple',
    );
  });

  test('uses canonical provider names', () {
    expect(
      oauthProviderDisplayName(type: 'github', name: 'company-github'),
      'GitHub',
    );
  });

  test('uses the native Apple button on iOS and macOS', () {
    expect(supportsNativeAppleSignInButton(TargetPlatform.iOS), isTrue);
    expect(supportsNativeAppleSignInButton(TargetPlatform.macOS), isTrue);
    expect(supportsNativeAppleSignInButton(TargetPlatform.android), isFalse);
    expect(supportsNativeAppleSignInButton(TargetPlatform.windows), isFalse);
    expect(supportsNativeAppleSignInButton(TargetPlatform.linux), isFalse);
  });

  testWidgets('renders provider brand icon data as a vector font glyph', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OAuthProviderIcon(
          type: 'discord',
          name: 'discord',
          key: const ValueKey('provider-icon'),
        ),
      ),
    );

    final icon = tester.widget<FaIcon>(find.byType(FaIcon));
    expect(icon.icon, FontAwesomeIcons.discord.data);
  });

  testWidgets('native Apple button exposes an accessible tap action', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final semantics = tester.ensureSemantics();
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: NativeAppleSignInButton(
          semanticLabel: 'Continue with Apple',
          onPressed: () => presses++,
        ),
      ),
    );

    final button = find.semantics.byLabel('Continue with Apple');
    final node = button.evaluate().single;
    expect(node.getSemanticsData().hasAction(ui.SemanticsAction.tap), isTrue);
    tester.semantics.tap(button);
    await tester.pump();
    expect(presses, 1);

    semantics.dispose();
    debugDefaultTargetPlatformOverride = null;
  });
}
