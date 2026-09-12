import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_instance_selector.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: Locale(Uri.base.queryParameters['locale'] ?? 'en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(3)),
      child: child!,
    ),
    home: switch (Uri.base.queryParameters['mode']) {
      'discovery' => const _DiscoveryPreview(),
      'playlist' => const _PlaylistPreview(),
      'pages' => const _PagePreview(),
      'youtube' => const _YoutubePreview(),
      _ => const _SelectPreview(),
    },
  ),
);

class _YoutubePreview extends StatefulWidget {
  const _YoutubePreview();

  @override
  State<_YoutubePreview> createState() => _YoutubePreviewState();
}

class _YoutubePreviewState extends State<_YoutubePreview> {
  final _items = [
    for (final name in ['First film', 'Second film'])
      youtube.ListItem(
        videoId: name,
        title: name,
        source: provider_common.DiscoveredSource(),
      ),
  ];
  bool _selectionEnabled = true;
  int _added = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSwitchTile(
              title: const Text('Select media'),
              value: _selectionEnabled,
              onChanged: (value) => setState(() => _selectionEnabled = value),
            ),
            Expanded(
              child: YoutubePlaylistPreview(
                items: _items,
                loading: false,
                hasMore: false,
                selectionEnabled: _selectionEnabled,
                onAddSelected: (items) => setState(() => _added = items.length),
              ),
            ),
            Text('Added: $_added'),
          ],
        ),
      ),
    ),
  );
}

class _PagePreview extends StatefulWidget {
  const _PagePreview();

  @override
  State<_PagePreview> createState() => _PagePreviewState();
}

class _PagePreviewState extends State<_PagePreview> {
  int _page = 2;
  int _requests = 0;
  bool _loading = false;
  bool get _emptyPage =>
      Uri.base.queryParameters['empty'] == 'true' && _page == 2;

  void _go(int delta) => setState(() {
    _page += delta;
    _requests++;
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSwitchTile(
              title: const Text('Loading'),
              value: _loading,
              onChanged: (value) => setState(() => _loading = value),
            ),
            Expanded(
              child: DiscoveryBrowser(
                items: [
                  if (!_emptyPage)
                    DiscoveryBrowserEntry(
                      key: 'page-$_page',
                      title: 'Page $_page item',
                      source: provider_common.DiscoveredSource(),
                      isContainer: false,
                    ),
                ],
                loading: _loading,
                paginationMode: DiscoveryPaginationMode.page,
                page: _page,
                hasMore: _page < 3,
                onPreviousPage: () => _go(-1),
                onNextPage: () => _go(1),
              ),
            ),
            Text('Requests: $_requests'),
          ],
        ),
      ),
    ),
  );
}

class _PlaylistPreview extends StatefulWidget {
  const _PlaylistPreview();

  @override
  State<_PlaylistPreview> createState() => _PlaylistPreviewState();
}

class _PlaylistPreviewState extends State<_PlaylistPreview> {
  final _name = TextEditingController(text: 'Cinema');
  String? _submitted;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DiscoveryBrowser(
                items: [
                  DiscoveryBrowserEntry(
                    key: 'folder',
                    title: 'Folder',
                    source: provider_common.DiscoveredSource(),
                    isContainer: true,
                  ),
                ],
                loading: false,
                target: ProviderAddTarget.playlist,
                onAddCurrentList: () async =>
                    setState(() => _submitted = _name.text),
                playlistActionLeading: AppTextField(
                  controller: _name,
                  label: context.l10n.playlistName,
                  prefixIcon: Icons.title,
                ),
              ),
            ),
            if (_submitted case final name?) Text('Added: $name'),
          ],
        ),
      ),
    ),
  );
}

class _DiscoveryPreview extends StatefulWidget {
  const _DiscoveryPreview();

  @override
  State<_DiscoveryPreview> createState() => _DiscoveryPreviewState();
}

class _DiscoveryPreviewState extends State<_DiscoveryPreview> {
  final _selection = DiscoverySelectionController();
  final _items = [
    DiscoveryBrowserEntry(
      key: 'folder',
      title: 'Folder',
      source: provider_common.DiscoveredSource(),
      isContainer: true,
    ),
    DiscoveryBrowserEntry(
      key: 'movie',
      title: 'Movie',
      source: provider_common.DiscoveredSource(),
      isContainer: false,
    ),
  ];
  bool _selectMedia = true;
  int _opened = 0;
  int _requests = 0;
  int _submitted = 0;
  bool get _slowPagination => Uri.base.queryParameters['pagination'] == 'slow';
  bool get _slowSubmit => Uri.base.queryParameters['bulk'] == 'slow';

  Future<void> _addSelected(List<DiscoveryBrowserEntry> entries) async {
    setState(() => _submitted++);
    if (_slowSubmit) await Future<void>.delayed(const Duration(seconds: 30));
  }

  Future<void> _loadMore() async {
    setState(() => _requests++);
    await Future<void>.delayed(const Duration(seconds: 30));
    if (!mounted) return;
    setState(
      () => _items.add(
        DiscoveryBrowserEntry(
          key: 'next',
          title: 'Next page',
          source: provider_common.DiscoveredSource(),
          isContainer: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSwitchTile(
            title: const Text('Select media'),
            value: _selectMedia,
            onChanged: (value) => setState(() => _selectMedia = value),
          ),
          Expanded(
            child: DiscoveryBrowser(
              items: _items,
              loading: false,
              hasMore: _slowPagination && _items.length < 3,
              onLoadMore: _slowPagination ? _loadMore : null,
              target: _selectMedia || _slowSubmit
                  ? ProviderAddTarget.media
                  : ProviderAddTarget.playlist,
              selectionController: _selection,
              onSelectionChanged: () => setState(() {}),
              onOpen: (_) => setState(() => _opened++),
              onAddSelected: !_selectMedia && _slowSubmit ? null : _addSelected,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _slowPagination
                  ? 'Requests: $_requests'
                  : _slowSubmit
                  ? 'Selected: ${_selection.length}\nAdded: $_submitted'
                  : 'Selected: ${_selection.length}\nOpened: $_opened',
            ),
          ),
        ],
      ),
    ),
  );
}

class _SelectPreview extends StatefulWidget {
  const _SelectPreview();

  @override
  State<_SelectPreview> createState() => _SelectPreviewState();
}

class _SelectPreviewState extends State<_SelectPreview> {
  String? _category = 'music';
  int _changes = 0;
  bool _musicAvailable = true;
  bool _enabled = true;
  Timer? _optionUpdate;

  @override
  void dispose() {
    _optionUpdate?.cancel();
    super.dispose();
  }

  Widget _buildSelect(BuildContext context) {
    if (Uri.base.queryParameters['mode'] == 'instances') {
      return ProviderInstanceSelector(
        instances: [
          'Default',
          if (_musicAvailable)
            'International live broadcast and shared family streaming instance',
        ],
        value: _category ?? '',
        enabled: _enabled,
        onChanged: (value) => setState(() => _category = value),
      );
    }
    if (Uri.base.queryParameters['mode'] == 'accounts') {
      return ProviderAccountSelector<String>(
        accounts: const ['__default_media_source__', 'family', 'remote'],
        selectedId: _category,
        idOf: (id) => id,
        labelOf: (id) => id == '__default_media_source__'
            ? 'Default media source'
            : 'International cinema and shared family collection',
        includeDefault: true,
        onChanged: (id) => setState(() => _category = id),
      );
    }
    const implementation = String.fromEnvironment(
      'PREVIEW_SELECT_IMPLEMENTATION',
    );
    final longOptions = Uri.base.queryParameters['options'] == 'long';
    final options = {
      context.l10n.noCategory: null,
      if (_musicAvailable) 'Music': 'music',
      if (longOptions) 'International cinema screenings': 'long',
    };
    void changed(String? value) => setState(() => _category = value);
    String? validate(String? value) =>
        value == null ? context.l10n.required : null;
    if (implementation == 'native') {
      return DropdownButtonFormField<String?>(
        initialValue: _category,
        isExpanded: true,
        itemHeight: null,
        decoration: InputDecoration(labelText: context.l10n.roomCategory),
        items: [
          for (final entry in options.entries)
            DropdownMenuItem(value: entry.value, child: Text(entry.key)),
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validate,
        onChanged: changed,
      );
    }
    if (implementation == 'modern') {
      return DropdownMenuFormField<String?>(
        initialSelection: _category,
        selectOnly: true,
        expandedInsets: EdgeInsets.zero,
        label: Text(context.l10n.roomCategory),
        dropdownMenuEntries: [
          for (final entry in options.entries)
            DropdownMenuEntry(value: entry.value, label: entry.key),
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validate,
        onSelected: changed,
      );
    }
    final select = AppSelect<String?>(
      value: _category,
      label: context.l10n.roomCategory,
      labelAbove: true,
      wrapText: !longOptions,
      clearable: true,
      enabled: _enabled,
      prefixIcon: Uri.base.queryParameters['prefix'] == 'true'
          ? Icons.music_note
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validate,
      hintText: context.l10n.noCategory,
      options: options,
      onChanged: changed,
    );
    final liveMode = Uri.base.queryParameters['options'];
    if (liveMode != 'live' && liveMode != 'disable') return select;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) {
        if (!focused) return;
        if (!_musicAvailable || _optionUpdate != null) return;
        _optionUpdate = Timer(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              if (liveMode == 'disable') {
                _enabled = false;
              } else {
                _musicAvailable = false;
              }
            });
          }
        });
      },
      child: select,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            onChanged: () => setState(() => _changes++),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSelect(context),
                const SizedBox(height: 16),
                Text('Changes: $_changes'),
                if (Uri.base.queryParameters['mode'] == 'instances')
                  AppSwitchTile(
                    title: const Text('Remote instance'),
                    value: _musicAvailable,
                    onChanged: (value) =>
                        setState(() => _musicAvailable = value),
                  ),
                if (Uri.base.queryParameters['options'] == 'disable')
                  AppActionButton(
                    label: _enabled ? 'Disable' : 'Enable',
                    icon: Icons.power_settings_new,
                    onPressed: () => setState(() => _enabled = !_enabled),
                  ),
                if (Uri.base.queryParameters['options'] == 'dynamic')
                  AppActionButton(
                    label: _musicAvailable ? 'Remove Music' : 'Restore Music',
                    icon: Icons.sync,
                    wrapLabel: true,
                    onPressed: () =>
                        setState(() => _musicAvailable = !_musicAvailable),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
