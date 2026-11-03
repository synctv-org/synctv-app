/// About dialog and update-check UI for non-store app builds.
library;

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../presentation/notifications/app_notifications.dart';
import '../presentation/widgets/app_form_controls.dart';
import 'github_release.dart';

import 'package:synctv_app/l10n/l10n.dart';

import 'update_checker.dart';
import 'update_source.dart';

/// Opens the About dialog from the account menu.
///
/// The update section appears only when [UpdateChecker.enabled] (injected
/// release source on a non-web, non-store build). [sourceOverride] exists
/// for widget tests.
Future<void> showAboutAppDialog(
  BuildContext context, {
  UpdateCheckSource? sourceOverride,
}) {
  return showAppDialog<void>(
    context: context,
    builder: (dialogContext) => _AboutAppDialog(sourceOverride: sourceOverride),
  );
}

class _AboutAppDialog extends StatefulWidget {
  const _AboutAppDialog({this.sourceOverride});

  final UpdateCheckSource? sourceOverride;

  @override
  State<_AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<_AboutAppDialog> {
  Future<PackageInfo>? _packageInfo;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final source = widget.sourceOverride ?? UpdateChecker.configuredSource;
    return AppDialog(
      constraints: const BoxConstraints(maxWidth: 460),
      title: Text(l10n.aboutAppTitle, style: theme.textTheme.titleMedium),
      icon: Icon(Icons.info_outline_rounded, color: theme.colorScheme.primary),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<PackageInfo>(
            future: _packageInfo,
            builder: (context, snapshot) {
              final info = snapshot.data;
              if (info == null) {
                return const SizedBox.shrink();
              }
              return Text(
                l10n.aboutAppVersion(
                  info.version,
                  info.buildNumber.isEmpty ? '0' : info.buildNumber,
                ),
                style: theme.textTheme.bodyMedium,
              );
            },
          ),
          if (source != null) ...[
            const SizedBox(height: 16),
            AppActionButton(
              label: _checking ? l10n.updateChecking : l10n.updateCheckAction,
              style: AppActionButtonStyle.outlined,
              icon: Icons.system_update_alt_rounded,
              wrapLabel: true,
              onPressed: _checking ? null : () => _runManualUpdateCheck(source),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.updateCheckSource(source.slug),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: [
        AppActionButton(
          label: l10n.close,
          style: AppActionButtonStyle.outlined,
          wrapLabel: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Future<void> _runManualUpdateCheck(UpdateCheckSource source) async {
    final l10n = context.l10n;
    setState(() => _checking = true);
    try {
      final preferences = await SharedPreferences.getInstance();
      final packageInfo = await PackageInfo.fromPlatform();
      final checker = UpdateChecker(
        source: source,
        currentVersion: packageInfo.version,
        fetch: (source) => fetchLatestRelease(source, http.Client()),
        preferences: preferences,
      );
      final result = await checker.check();
      if (!mounted) return;
      switch (result) {
        case UpdateCheckUpToDate():
          AppNotifications.showSuccess(context, l10n.updateCheckUpToDate);
        case UpdateCheckAvailable():
          await showUpdateAvailableDialog(
            context,
            release: result.release,
            checker: checker,
          );
        case UpdateCheckFailed():
          AppNotifications.showError(context, l10n.updateCheckFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }
}

/// Update announcement: version, notes, download link, dismissal.
Future<void> showUpdateAvailableDialog(
  BuildContext context, {
  required GitHubLatestRelease release,
  required UpdateChecker checker,
}) {
  return showAppDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) =>
        _UpdateAvailableDialog(release: release, checker: checker),
  );
}

class _UpdateAvailableDialog extends StatelessWidget {
  const _UpdateAvailableDialog({required this.release, required this.checker});

  final GitHubLatestRelease release;
  final UpdateChecker checker;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final notes = release.body.trim();
    final title = release.name.isEmpty ? release.tagName : release.name;
    return AppDialog(
      constraints: const BoxConstraints(maxWidth: 520),
      title: Text(
        l10n.updateAvailableTitle(release.tagName),
        style: theme.textTheme.titleMedium,
      ),
      icon: Icon(
        Icons.system_update_alt_rounded,
        color: theme.colorScheme.primary,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Flexible(
              child: AppSingleChildScrollView(
                child: MarkdownBody(
                  data: notes,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        AppActionButton(
          label: l10n.updateLater,
          style: AppActionButtonStyle.outlined,
          wrapLabel: true,
          onPressed: () {
            checker.dismiss(release);
            Navigator.of(context).pop();
          },
        ),
        AppActionButton(
          label: l10n.updateDownload,
          icon: Icons.download_rounded,
          wrapLabel: true,
          onPressed: () => _openReleasePage(context, release.htmlUrl),
        ),
      ],
    );
  }

  Future<void> _openReleasePage(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    final opened =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      AppNotifications.showError(context, context.l10n.updateOpenFailed);
    }
  }
}

/// Silent startup check: throttled, non-dismissed releases only, and quiet
/// on every failure path (rate limit, offline, malformed payload).
Future<void> runStartupUpdateCheck(BuildContext context) async {
  final source = UpdateChecker.configuredSource;
  if (source == null) return;
  try {
    final preferences = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    final checker = UpdateChecker(
      source: source,
      currentVersion: packageInfo.version,
      fetch: (source) => fetchLatestRelease(source, http.Client()),
      preferences: preferences,
    );
    final available = await checker.maybeAutoCheck();
    if (available == null || !context.mounted) return;
    await showUpdateAvailableDialog(
      context,
      release: available.release,
      checker: checker,
    );
  } on Object {
    // Startup checks never surface errors.
  }
}
