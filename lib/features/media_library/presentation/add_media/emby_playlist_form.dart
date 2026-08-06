import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum EmbyCollectionMode {
  continueWatching,
  nextUp,
  recentlyAdded,
  favoriteItems,
  favoritePeople,
  playlists,
  collections,
  genres,
}

class EmbyPlaylistForm extends StatefulWidget {
  const EmbyPlaylistForm({
    super.key,
    required this.roomId,
    required this.parentId,
    required this.binds,
    required this.onDraftChanged,
    this.onPreview,
    this.onCreate,
  });

  final String roomId;
  final String parentId;
  final List<EmbyBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Future<RoomMediaLibraryPage> Function(
    Map<String, dynamic> sourceConfig,
    String instanceName,
    String? target,
  )?
  onPreview;
  final Future<void> Function(
    String name,
    Map<String, dynamic> sourceConfig,
    String instanceName,
  )?
  onCreate;

  @override
  State<EmbyPlaylistForm> createState() => _EmbyPlaylistFormState();
}

class _EmbyPlaylistFormState extends State<EmbyPlaylistForm> {
  final _nameController = TextEditingController();
  EmbyCollectionMode _mode = EmbyCollectionMode.continueWatching;
  final Set<String> _itemTypes = {'Movie', 'Episode', 'Video'};
  String _serverId = '';
  String _instanceName = '';
  bool _loading = false;
  List<RoomDynamicMediaEntry> _items = const [];
  String _personId = '';
  String _personName = '';
  String _personTarget = '';
  String _genreId = '';
  String _genreName = '';
  String _genreTarget = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _changed() {
    _items = const [];
    _clearPerson();
    _clearGenre();
    widget.onDraftChanged(_nameController.text.trim().isNotEmpty);
    setState(() {});
  }

  void _clearPerson() {
    _personId = '';
    _personName = '';
    _personTarget = '';
  }

  void _clearGenre() {
    _genreId = '';
    _genreName = '';
    _genreTarget = '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.binds.isNotEmpty &&
        !widget.binds.any(
          (bind) =>
              '${bind.serverId}@${bind.providerInstanceName}' ==
              '$_serverId@$_instanceName',
        )) {
      final bind = widget.binds.first;
      _serverId = bind.serverId;
      _instanceName = bind.providerInstanceName;
    }
    final selectedKey = '$_serverId@$_instanceName';
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<EmbyCollectionMode>(
            key: const Key('emby-collection-mode'),
            initialValue: _mode,
            decoration: const InputDecoration(
              labelText: 'Source',
              prefixIcon: Icon(Icons.video_library_outlined),
            ),
            items: EmbyCollectionMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(_modeLabel(mode)),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (mode) {
                    if (mode == null) return;
                    _mode = mode;
                    _changed();
                  },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedKey,
            decoration: const InputDecoration(
              labelText: 'Emby account',
              prefixIcon: Icon(Icons.dns_outlined),
            ),
            items: widget.binds
                .map(
                  (bind) => DropdownMenuItem(
                    value: '${bind.serverId}@${bind.providerInstanceName}',
                    child: Text(
                      bind.providerInstanceName.isEmpty
                          ? bind.host
                          : '${bind.host} · ${bind.providerInstanceName}',
                    ),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    final bind = widget.binds.cast<EmbyBindInfo?>().firstWhere(
                      (bind) =>
                          bind != null &&
                          '${bind.serverId}@${bind.providerInstanceName}' ==
                              value,
                      orElse: () => null,
                    );
                    if (bind == null) return;
                    _serverId = bind.serverId;
                    _instanceName = bind.providerInstanceName;
                    _changed();
                  },
          ),
          if (_mode == EmbyCollectionMode.favoriteItems ||
              _mode == EmbyCollectionMode.recentlyAdded ||
              _mode == EmbyCollectionMode.genres ||
              _personId.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Movie', 'Episode', 'Video'].map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: _itemTypes.contains(type),
                  onSelected: _loading
                      ? null
                      : (selected) {
                          setState(() {
                            if (selected) {
                              _itemTypes.add(type);
                            } else if (_itemTypes.length > 1) {
                              _itemTypes.remove(type);
                            }
                            _items = const [];
                          });
                        },
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 12),
          AppTextField(
            controller: _nameController,
            enabled: !_loading,
            label: 'Playlist name',
            prefixIcon: Icons.title,
            onChanged: (_) =>
                widget.onDraftChanged(_nameController.text.trim().isNotEmpty),
          ),
          if (_personId.isNotEmpty) ...[
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person),
              title: Text(_personName),
              trailing: AppIconButton(
                tooltip: 'Back to people',
                icon: Icons.close,
                onPressed: _loading
                    ? null
                    : () {
                        setState(() {
                          _clearPerson();
                          _items = const [];
                        });
                        _preview();
                      },
              ),
            ),
          ],
          if (_genreId.isNotEmpty) ...[
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.category_outlined),
              title: Text(_genreName),
              trailing: AppIconButton(
                tooltip: 'Back to genres',
                icon: Icons.close,
                onPressed: _loading
                    ? null
                    : () {
                        setState(() {
                          _clearGenre();
                          _items = const [];
                        });
                        _preview();
                      },
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                key: const Key('emby-preview'),
                onPressed: _loading || _serverId.isEmpty ? null : _preview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('emby-create'),
                onPressed: _loading || _serverId.isEmpty || _items.isEmpty
                    ? null
                    : _create,
                icon: _loading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: false,
                        ),
                      )
                    : const Icon(Icons.playlist_add),
                label: const Text('Create'),
              ),
            ],
          ),
          if (_items.isNotEmpty) ...[
            const SizedBox(height: 14),
            ..._items.map(_itemTile),
          ],
        ],
      ),
    );
  }

  Widget _itemTile(RoomDynamicMediaEntry item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      onTap:
          item.isPlaylist &&
              (_mode == EmbyCollectionMode.favoritePeople ||
                  _mode == EmbyCollectionMode.genres)
          ? () => _openFolder(item)
          : null,
      leading: item.coverUrl.isEmpty
          ? Icon(item.isPlaylist ? Icons.person_outline : Icons.movie_outlined)
          : AppImageThumbnail(
              url: item.coverUrl,
              width: 56,
              height: 56,
              borderRadius: BorderRadius.circular(4),
            ),
      title: Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: item.isPlaylist ? const Icon(Icons.chevron_right) : null,
    );
  }

  void _openPerson(RoomDynamicMediaEntry item) {
    final target = item.metadata['target_json'];
    if (target is! Map || target['personId'] == null) return;
    setState(() {
      _personId = target['personId'].toString();
      _personName = item.name;
      _personTarget = item.id;
      _items = const [];
    });
    _preview();
  }

  void _openFolder(RoomDynamicMediaEntry item) {
    if (_mode == EmbyCollectionMode.favoritePeople) {
      _openPerson(item);
      return;
    }
    setState(() {
      final config = item.playlistSourceConfig;
      _genreId = config?.hasEmby() == true && config!.emby.hasGenreItems()
          ? config.emby.genreItems.genreId
          : _targetValue(item, 'itemId');
      _genreName = item.name;
      _genreTarget = item.id;
      _items = const [];
    });
    if (_genreId.isNotEmpty) _preview();
  }

  static String _targetValue(RoomDynamicMediaEntry item, String key) {
    final target = item.metadata['target_json'];
    if (target is Map && target[key] != null) return target[key].toString();
    return item.id;
  }

  Map<String, dynamic> get _sourceConfig {
    final source = switch ((
      _mode,
      _personId.isNotEmpty || _genreId.isNotEmpty,
    )) {
      (EmbyCollectionMode.continueWatching, _) => <String, dynamic>{
        'type': 'continueWatching',
      },
      (EmbyCollectionMode.nextUp, _) => <String, dynamic>{'type': 'nextUp'},
      (EmbyCollectionMode.recentlyAdded, _) => <String, dynamic>{
        'type': 'recentlyAdded',
        'itemTypes': _itemTypes.toList(),
      },
      (EmbyCollectionMode.favoriteItems, _) => <String, dynamic>{
        'type': 'favoriteItems',
        'itemTypes': _itemTypes.toList(),
      },
      (EmbyCollectionMode.favoritePeople, false) => <String, dynamic>{
        'type': 'favoritePeople',
      },
      (EmbyCollectionMode.favoritePeople, true) => <String, dynamic>{
        'type': 'personItems',
        'personId': _personId,
        'itemTypes': _itemTypes.toList(),
      },
      (EmbyCollectionMode.playlists, _) => <String, dynamic>{
        'type': 'playlists',
      },
      (EmbyCollectionMode.collections, _) => <String, dynamic>{
        'type': 'collections',
      },
      (EmbyCollectionMode.genres, false) => <String, dynamic>{
        'type': 'genres',
        'itemTypes': _itemTypes.toList(),
      },
      (EmbyCollectionMode.genres, true) => <String, dynamic>{
        'type': 'genreItems',
        'genreId': _genreId,
        'itemTypes': _itemTypes.toList(),
      },
    };
    return {'serverId': _serverId, 'source': source};
  }

  Map<String, dynamic> get _previewSourceConfig {
    if (_mode == EmbyCollectionMode.favoritePeople && _personId.isNotEmpty) {
      return {
        'serverId': _serverId,
        'source': {'type': 'favoritePeople'},
      };
    }
    if (_mode == EmbyCollectionMode.genres && _genreId.isNotEmpty) {
      return {
        'serverId': _serverId,
        'source': {'type': 'genres', 'itemTypes': _itemTypes.toList()},
      };
    }
    return _sourceConfig;
  }

  Future<void> _preview() async {
    setState(() => _loading = true);
    try {
      final target = _personTarget.isNotEmpty
          ? _personTarget
          : _genreTarget.isNotEmpty
          ? _genreTarget
          : null;
      final page = switch (widget.onPreview) {
        final callback? => await callback(
          _previewSourceConfig,
          _instanceName,
          target,
        ),
        null => await providerGateway.listMediaLibrary(
          widget.roomId,
          pageSize: 20,
          target: target,
          sourceProvider: 'emby',
          previewSourceConfig: _previewSourceConfig,
          providerInstanceName: _instanceName,
        ),
      };
      if (mounted) setState(() => _items = page.dynamicItems);
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    try {
      final defaultName = _personId.isNotEmpty
          ? _personName
          : _genreId.isNotEmpty
          ? _genreName
          : _modeLabel(_mode);
      final name = _nameController.text.trim().isEmpty
          ? defaultName
          : _nameController.text.trim();
      switch (widget.onCreate) {
        case final callback?:
          await callback(name, _sourceConfig, _instanceName);
        case null:
          await providerGateway.createPlaylist(
            widget.roomId,
            name: name,
            parentId: widget.parentId,
            sourceProvider: 'emby',
            sourceConfig: _sourceConfig,
            providerInstanceName: _instanceName,
          );
      }
      if (!mounted) return;
      _nameController.clear();
      _items = const [];
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'Emby playlist created');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static String _modeLabel(EmbyCollectionMode mode) => switch (mode) {
    EmbyCollectionMode.continueWatching => 'Continue Watching',
    EmbyCollectionMode.nextUp => 'Next Up',
    EmbyCollectionMode.recentlyAdded => 'Recently Added',
    EmbyCollectionMode.favoriteItems => 'Favorite Videos',
    EmbyCollectionMode.favoritePeople => 'Favorite People',
    EmbyCollectionMode.playlists => 'Server Playlists',
    EmbyCollectionMode.collections => 'Collections',
    EmbyCollectionMode.genres => 'Genres',
  };
}
