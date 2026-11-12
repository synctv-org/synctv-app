import 'package:flutter/material.dart';

/// Semantic status colors shared across the app.
///
/// These are the single source of truth for success, warning, danger and
/// info accents. Feature code must use these constants (or the
/// corresponding `colorScheme` roles for danger) instead of scattering raw
/// `Colors.green` / `Colors.red` / ad-hoc hex literals, so that the same
/// status always reads the same across pages, dialogs and overlays.
abstract final class AppColors {
  /// Successful states: live indicators, connected bindings, passed checks.
  /// Bright mint used on dark video overlays; deeper green for surfaces.
  static const Color successOverlay = Color(0xFF7CFFB2);
  static const Color success = Color(0xFF16A34A);
  static const Color successDeep = Color(0xFF15803D);

  /// Warning accents: pending reviews, expiring credentials, fallbacks.
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDeep = Color(0xFFB45309);

  /// The theme secondary teal, mirrored here for places that need it as a
  /// plain constant (const contexts cannot read ThemeData).
  static const Color secondary = Color(0xFF0F766E);

  /// The theme primary blue, mirrored for const contexts.
  static const Color primary = Color(0xFF2563EB);

  /// Deterministic per-room accent hues (hashed by room name) so cover art
  /// placeholders keep a stable, curated palette instead of random hex.
  static const Color roomAccentRose = Color(0xFFBE185D);
  static const Color roomAccentViolet = Color(0xFF6D28D9);
  static const Color roomAccentForest = Color(0xFF047857);

  /// Destructive and error accents outside `colorScheme.error` contexts
  /// (brand-adjacent danger badges, overlay chips).
  static const Color danger = Color(0xFFDC2626);

  /// Accent used by the video-player overlay kit (route and quality
  /// selection on the dark scrubber surface). Distinct from the app
  /// primary so player controls stay readable over video.
  static const Color playerAccent = Color(0xFF5D5FEF);
  static const Color playerAccentSoft = Color(0xFF9BA8FF);

  /// The dark translucent surface the player overlay kit paints on.
  static const Color playerScrim = Color(0xF21A1A24);
  static const Color playerSurface = Color(0xFF1E1E2C);

  /// Media provider brand accents (single source used by
  /// `media_provider_brand.dart` and any badge or icon that needs to match
  /// a provider's public brand color).
  static const Color providerIndigo = Color(0xFF5D5FEF);
  static const Color providerRtmp = Color(0xFFE65100);
  static const Color providerLiveProxy = Color(0xFF00897B);
  static const Color providerBilibili = Color(0xFFFB7299);
  static const Color providerEmby = Color(0xFF52B54B);
  static const Color providerCloudreve = Color(0xFF5C6BC0);
  static const Color providerTwitch = Color(0xFF9146FF);
  static const Color providerHuya = Color(0xFFFF7A00);
  static const Color providerDouyu = Color(0xFFFF5D23);
  static const Color providerAcfun = Color(0xFFFD4C5B);
  static const Color providerCctv = Color(0xFFC62828);
  static const Color providerFnos = Color(0xFF087F5B);
  static const Color providerQnap = Color(0xFF0076A8);
  static const Color providerSynology = Color(0xFF1578D3);
  static const Color providerNextcloud = Color(0xFF0082C9);
  static const Color providerSeafile = Color(0xFFED7109);
  static const Color providerTruenas = Color(0xFF0095D5);
  static const Color providerYoutube = Color(0xFFFF0033);
  static const Color providerDouyin = Color(0xFF00AFA7);
  static const Color providerTiktok = Color(0xFFFE2C55);
}
