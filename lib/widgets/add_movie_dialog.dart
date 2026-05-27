import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/widgets/ios_style_switch.dart';
import 'platform_binding_dialog.dart';

class AddMovieDialog extends StatefulWidget {
  final String roomId;
  final String? parentId;

  const AddMovieDialog({super.key, required this.roomId, this.parentId});

  static Future<void> show(BuildContext context, String roomId,
      {String? parentId}) {
    return ChatUtils.showStyledDialog(
      context: context,
      title: '添加影片',
      icon: Icon(Icons.add_to_queue, color: Theme.of(context).primaryColor),
      content: AddMovieDialog(roomId: roomId, parentId: parentId),
      actions: [],
    );
  }

  @override
  State<AddMovieDialog> createState() => _AddMovieDialogState();
}

class _AddMovieDialogState extends State<AddMovieDialog> {
  int _selectedIndex = -1;

  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _directHeadersController = TextEditingController();
  final _biliUrlController = TextEditingController();
  final _alistSearchController = TextEditingController();
  final _alistPasswordController = TextEditingController();
  final _embySearchController = TextEditingController();

  bool _isProxy = false;
  bool _isLoading = false;

  BilibiliParseInfo? _biliInfo;
  int _biliSelectedIndex = 0;

  String _alistPath = '/';
  List<AlistItemInfo> _alistFiles = [];
  bool _alistLoading = false;
  int _alistPage = 1;
  bool _alistHasMore = true;
  String _alistServerId = '';
  String _alistInstanceName = '';
  String _alistKeyword = '';
  String _alistPassword = '';
  List<AlistBindInfo> _alistBinds = [];
  static const int _pageSize = 20;
  final Map<String, AlistItemInfo> _selectedAlistItems = {};

  String _embyPath = '/';
  List<EmbyItemInfo> _embyFiles = [];
  bool _embyLoading = false;
  int _embyPage = 1;
  bool _embyHasMore = true;
  String _embyServerId = '';
  String _embyInstanceName = '';
  String _embyKeyword = '';
  List<EmbyBindInfo> _embyBinds = [];

  String _bilibiliInstanceName = '';
  List<BilibiliBindInfo> _bilibiliBinds = [];

  List<String> _boundVendors = [];
  bool _checkingVendors = true;
  PublicSettingsInfo? _publicSettings;

  @override
  void initState() {
    super.initState();
    _checkVendors();
  }

  Future<void> _checkVendors() async {
    try {
      final results = await Future.wait([
        WatchTogetherService.getAllAlistBindInfos(),
        WatchTogetherService.getAllEmbyBindInfos(),
        WatchTogetherService.getAllBilibiliBindInfos(),
        WatchTogetherService.getPublicSettings(),
      ]);
      final alistBinds = results[0] as List<AlistBindInfo>;
      final embyBinds = results[1] as List<EmbyBindInfo>;
      final bilibiliBinds = results[2] as List<BilibiliBindInfo>;
      final publicSettings = results[3] as PublicSettingsInfo;
      if (!mounted) return;
      setState(() {
        _alistBinds = alistBinds;
        _embyBinds = embyBinds;
        _bilibiliBinds = bilibiliBinds;
        _publicSettings = publicSettings;
        _boundVendors = [
          if (alistBinds.isNotEmpty) 'alist',
          if (embyBinds.isNotEmpty) 'emby',
          if (bilibiliBinds.isNotEmpty) 'bilibili',
        ];
        _applyDefaultProviderBindings();
        _checkingVendors = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkingVendors = false);
      MessageUtils.showError(context, '获取媒体源绑定失败: $e');
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _directHeadersController.dispose();
    _biliUrlController.dispose();
    _alistSearchController.dispose();
    _alistPasswordController.dispose();
    _embySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final contentWidth = size.width > 600 ? 560.0 : size.width * 0.9 - 40;

    return SizedBox(
      width: contentWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedIndex != -1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _selectedIndex = -1),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_rounded,
                          size: 22,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : theme.primaryColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _getTitle(_selectedIndex),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (_providerBindingIndex(_selectedIndex) != null) ...[
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        await PlatformBindingDialog.show(context,
                            initialIndex:
                                _providerBindingIndex(_selectedIndex)!);
                        await _checkVendors();
                        if (mounted) {
                          if (_selectedIndex == 3) _loadAlist(_alistPath);
                          if (_selectedIndex == 4) _loadEmby(_embyPath);
                        }
                      },
                      icon:
                          Icon(Icons.settings_rounded, color: theme.hintColor),
                      tooltip: '管理配置',
                    ),
                  ],
                ],
              ),
            ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedIndex == -1
                  ? _buildMenu(theme, contentWidth)
                  : SizedBox(
                      height: 450,
                      child: _buildContent(theme),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return '直链';
      case 1:
        return 'RTMP 推流';
      case 2:
        return 'Bilibili';
      case 3:
        return 'Alist 网盘';
      case 4:
        return 'Emby 媒体库';
      default:
        return '';
    }
  }

  Widget _buildMenu(ThemeData theme, double dialogWidth) {
    // Reduce padding to maximize card width
    // Dialog itself has 20px padding, so we don't need huge padding here
    const double gridPadding = 4.0;
    const double spacing = 16.0;

    // Calculate aspect ratio dynamically
    // Available width = Total Width - Horizontal Padding - Cross Axis Spacing
    final double itemWidth = (dialogWidth - (gridPadding * 2) - spacing) / 2;

    // Fixed height to ensure all content (Icon + Title + Subtitle + Spacing) fits comfortably
    // Icon(70 container) + Spacing(20) + Title(45) + Spacing(8) + Subtitle(40) + Padding(40) = ~223
    const double itemHeight = 240.0;

    final double ratio = itemWidth / itemHeight;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(gridPadding),
      crossAxisCount: 2,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      childAspectRatio: ratio,
      children: [
        _buildGridMenuItem(
          0,
          '直链',
          'HTTP / HTTPS / HLS',
          Icons.link_rounded,
          const Color(0xFF5D5FEF),
          theme,
        ),
        _buildGridMenuItem(
          1,
          'RTMP 推流',
          '生成推流地址',
          Icons.upload_rounded,
          Colors.deepOrange.shade600,
          theme,
        ),
        _buildGridMenuItem(
          2,
          'Bilibili',
          '支持 BV / 链接解析',
          Icons.tv_rounded,
          const Color(0xFFFB7299),
          theme,
        ),
        _buildGridMenuItem(
          3,
          'Alist 网盘',
          '挂载的云盘资源',
          Icons.cloud_circle_rounded,
          Colors.amber.shade700,
          theme,
        ),
        _buildGridMenuItem(
          4,
          'Emby 媒体库',
          '个人媒体服务器',
          Icons.video_library_rounded,
          Colors.green.shade600,
          theme,
        ),
      ],
    );
  }

  Widget _buildGridMenuItem(int index, String title, String subtitle,
      IconData icon, Color color, ThemeData theme) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          if (index == 2 || index == 3) {
            _isProxy = true;
          } else {
            _isProxy = false;
          }
        });
        if (index == 3 && _alistFiles.isEmpty) {
          _loadAlist('/');
        }
        if (index == 4 && _embyFiles.isEmpty) {
          _loadEmby('/');
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: theme.hintColor),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (_selectedIndex) {
      case 0:
        return _buildDirectLinkContent(theme);
      case 1:
        return _buildRtmpPublishContent(theme);
      case 2:
        return _buildBilibiliContent(theme);
      case 3:
        return _buildAlistContent(theme);
      case 4:
        return _buildEmbyContent(theme);
      default:
        return const SizedBox();
    }
  }

  Widget _buildDirectLinkContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildMultilineTextField(
            theme,
            _urlController,
            '视频链接（每行一个）',
            'https://example.com/video.mp4',
            Icons.link_rounded,
            minLines: 3,
            maxLines: 6,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            theme,
            _nameController,
            '视频名称（单条可选）',
            '默认为文件名',
            Icons.title,
          ),
          const SizedBox(height: 16),
          _buildMultilineTextField(
            theme,
            _directHeadersController,
            '请求头',
            'Referer: https://example.com\nCookie: session=...',
            Icons.http_rounded,
            minLines: 3,
            maxLines: 5,
          ),
          AnimatedBuilder(
            animation: _directHeadersController,
            builder: (context, _) {
              final hasCredentials =
                  DirectUrlSourceConfig.hasCredentialHeaderLines(
                _directHeadersController.text,
              );
              if (!hasCredentials) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _buildDirectHeaderRiskNotice(theme),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildActionButton('添加', _addDirectLink),
        ],
      ),
    );
  }

  Widget _buildDirectHeaderRiskNotice(ThemeData theme) {
    final warningColor = Colors.orange.shade700;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: warningColor.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 20, color: warningColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Authorization、Cookie 等凭据请求头会写入媒体播放信息，房间成员播放时可能获取这些值。只对可信房间和可信链接使用。',
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRtmpPublishContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTextField(
            theme,
            _nameController,
            '直播名称',
            '例如 摄像机、OBS 推流',
            Icons.live_tv_rounded,
          ),
          const SizedBox(height: 24),
          if (_publicSettings != null) ...[
            _buildRtmpPublicSettingsPanel(theme, _publicSettings!),
            const SizedBox(height: 16),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.key_rounded, color: theme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '创建后会生成推流地址和 Stream Key',
                    style: TextStyle(color: theme.hintColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildActionButton('创建推流入口', _addRtmpPublish,
              color: Colors.deepOrange.shade600),
        ],
      ),
    );
  }

  Widget _buildBilibiliContent(ThemeData theme) {
    final videos = _biliInfo?.videos ?? const <BilibiliVideoItemInfo>[];
    final selectedIndex = videos.isEmpty
        ? -1
        : _biliSelectedIndex.clamp(0, videos.length - 1).toInt();
    final selectedVideo = selectedIndex >= 0 ? videos[selectedIndex] : null;
    final coverImage = selectedVideo?.cover ?? '';
    final title = _biliInfo?.title.isNotEmpty == true
        ? _biliInfo!.title
        : (selectedVideo?.name ?? '未知标题');
    final desc = _biliInfo == null ? '' : _biliInfo!.actors.join(' / ');

    return Column(
      children: [
        _buildProviderBindSelector<BilibiliBindInfo>(
          theme: theme,
          items: _bilibiliBinds,
          selectedKey: _bilibiliInstanceName,
          keyOf: (bind) => bind.providerInstanceName,
          labelOf: (bind) => _providerBindLabel(
            title: 'Bilibili 账号',
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _bilibiliInstanceName = bind.providerInstanceName;
              _biliInfo = null;
              _biliSelectedIndex = 0;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: _buildTextField(theme, _biliUrlController, '视频链接 / BV号',
                    '粘贴链接自动解析', Icons.search),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFFB7299), Color(0xFFFF9EB5)]),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _isLoading ? null : _parseBilibili,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _biliInfo == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.tv_off_rounded,
                          size: 64,
                          color: theme.disabledColor.withValues(alpha: 0.2)),
                      const SizedBox(height: 16),
                      Text('暂无解析内容', style: TextStyle(color: theme.hintColor)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      if (coverImage.isNotEmpty)
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              coverImage,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                  child: const Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      if (desc.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          desc,
                          style:
                              TextStyle(fontSize: 13, color: theme.hintColor),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (videos.length > 1) ...[
                        const SizedBox(height: 16),
                        _buildBilibiliVideoSelector(theme, videos),
                      ],
                      const SizedBox(height: 16),
                      const SizedBox(height: 8),
                      _buildActionButton('添加到播放列表', _addBilibili,
                          color: const Color(0xFFFB7299)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAlistContent(ThemeData theme) {
    if (_checkingVendors) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_boundVendors.contains('alist')) {
      return _buildBindGuide('Alist', theme);
    }

    return Column(
      children: [
        _buildProviderBindSelector<AlistBindInfo>(
          theme: theme,
          items: _alistBinds,
          selectedKey: _providerBindKey(_alistServerId, _alistInstanceName),
          keyOf: (bind) =>
              _providerBindKey(bind.serverId, bind.providerInstanceName),
          labelOf: (bind) => _providerBindLabel(
            title: bind.host.isNotEmpty ? bind.host : bind.username,
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _alistServerId = bind.serverId;
              _alistInstanceName = bind.providerInstanceName;
              _alistPath = '/';
              _alistFiles = [];
              _alistPage = 1;
              _alistHasMore = true;
              _alistKeyword = '';
              _alistPassword = '';
              _alistSearchController.clear();
              _alistPasswordController.clear();
              _selectedAlistItems.clear();
            });
            _loadAlist('/');
          },
        ),
        _buildAlistSearchBar(theme),
        _buildAlistPasswordField(theme),
        _buildPathBar(theme, _alistPath, _goUpAlist),
        Expanded(
          child: !_alistLoading && _alistFiles.isEmpty
              ? Center(
                  child: Text('暂无文件', style: TextStyle(color: theme.hintColor)))
              : _alistLoading && _alistFiles.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!_alistLoading &&
                            _alistHasMore &&
                            scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 200) {
                          _loadAlist(_alistPath, loadMore: true);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemCount: _alistFiles.length + (_alistHasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _alistFiles.length) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: _alistLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : TextButton(
                                      onPressed: () => _loadAlist(_alistPath,
                                          loadMore: true),
                                      child: const Text('加载更多'),
                                    ),
                            );
                          }

                          final file = _alistFiles[index];
                          final path = file.path;
                          final isSelected =
                              _selectedAlistItems.containsKey(path);

                          return _buildFileItem(
                            theme,
                            file.name,
                            file.isDir,
                            () => file.isDir
                                ? _openAlistDirectory(file.path)
                                : _addAlistFile(file),
                            subtitle:
                                file.isDir ? null : _formatSize(file.size),
                            isSelected: isSelected,
                            onSelectionChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedAlistItems[path] = file;
                                } else {
                                  _selectedAlistItems.remove(path);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
        ),
        if (_selectedAlistItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4))
              ],
            ),
            child: _buildActionButton('添加选中的 ${_selectedAlistItems.length} 项',
                _addSelectedAlistItems),
          ),
      ],
    );
  }

  Widget _buildEmbyContent(ThemeData theme) {
    if (_checkingVendors) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_boundVendors.contains('emby')) return _buildBindGuide('Emby', theme);

    return Column(
      children: [
        _buildProviderBindSelector<EmbyBindInfo>(
          theme: theme,
          items: _embyBinds,
          selectedKey: _providerBindKey(_embyServerId, _embyInstanceName),
          keyOf: (bind) =>
              _providerBindKey(bind.serverId, bind.providerInstanceName),
          labelOf: (bind) => _providerBindLabel(
            title: bind.host.isNotEmpty ? bind.host : bind.userId,
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _embyServerId = bind.serverId;
              _embyInstanceName = bind.providerInstanceName;
              _embyPath = '/';
              _embyFiles = [];
              _embyPage = 1;
              _embyHasMore = true;
              _embyKeyword = '';
              _embySearchController.clear();
            });
            _loadEmby('/');
          },
        ),
        _buildEmbySearchBar(theme),
        _buildPathBar(theme, _embyPath, _goUpEmby),
        Expanded(
          child: !_embyLoading && _embyFiles.isEmpty
              ? Center(
                  child: Text('暂无媒体', style: TextStyle(color: theme.hintColor)))
              : _embyLoading && _embyFiles.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!_embyLoading &&
                            _embyHasMore &&
                            scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 200) {
                          _loadEmby(_embyPath, loadMore: true);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _embyFiles.length + (_embyHasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _embyFiles.length) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: _embyLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : TextButton(
                                      onPressed: () =>
                                          _loadEmby(_embyPath, loadMore: true),
                                      child: const Text('加载更多'),
                                    ),
                            );
                          }
                          final file = _embyFiles[index];
                          return _buildFileItem(
                            theme,
                            file.name.isEmpty ? 'Unknown' : file.name,
                            file.isDir,
                            () => file.isDir
                                ? _enterEmbyDir(file.name, file.id)
                                : _addEmbyFile(file),
                            subtitle: file.isDir ? null : 'Emby Media',
                            thumbnailUrl: file.thumbnail,
                            iconColor: Colors.green,
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildTextField(ThemeData theme, TextEditingController controller,
      String label, String hint, IconData icon) {
    return ChatUtils.createFormField(
      context: context,
      label: label,
      controller: controller,
      hintText: hint,
      prefixIcon: icon,
    );
  }

  Widget _buildMultilineTextField(
    ThemeData theme,
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    int minLines = 2,
    int maxLines = 4,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: theme.cardColor,
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed,
      {Color? color}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: color != null
                ? [color, color.withValues(alpha: 0.8)]
                : const [Color(0xFF5D5FEF), Color(0xFF843CF6)],
          ),
          boxShadow: [
            BoxShadow(
              color: (color ?? const Color(0xFF5D5FEF)).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(text,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPathBar(ThemeData theme, String path, VoidCallback onUp) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: path == '/' ? null : onUp,
            borderRadius: BorderRadius.circular(8),
            child: Icon(Icons.arrow_upward_rounded,
                color: path == '/' ? theme.disabledColor : theme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              path,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('代理',
                  style: TextStyle(fontSize: 12, color: theme.hintColor)),
              const SizedBox(width: 4),
              Transform.scale(
                scale: 0.8,
                child: IOSStyleSwitch(
                  value: _isProxy,
                  onChanged: (val) => setState(() => _isProxy = val),
                  isDark: theme.brightness == Brightness.dark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProviderBindSelector<T>({
    required ThemeData theme,
    required List<T> items,
    required String selectedKey,
    required String Function(T item) keyOf,
    required String Function(T item) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    if (items.length <= 1) return const SizedBox.shrink();
    final value = items.any((item) => keyOf(item) == selectedKey)
        ? selectedKey
        : keyOf(items.first);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: '媒体源账号',
          prefixIcon: const Icon(Icons.account_tree_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
        items: [
          for (final item in items)
            DropdownMenuItem(
              value: keyOf(item),
              child: Text(
                labelOf(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (key) {
          if (key == null) return;
          onChanged(items.firstWhere((item) => keyOf(item) == key));
        },
      ),
    );
  }

  Widget _buildAlistSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: TextField(
        controller: _alistSearchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          labelText: '搜索当前目录',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _alistKeyword.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: '清除搜索',
                  onPressed: _clearAlistSearch,
                ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
        onSubmitted: (_) => _searchAlist(),
      ),
    );
  }

  Widget _buildAlistPasswordField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: TextField(
        controller: _alistPasswordController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: '目录密码',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: _alistPasswordController.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: '清除目录密码',
                  onPressed: _clearAlistPassword,
                ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _applyAlistPassword(),
      ),
    );
  }

  Widget _buildEmbySearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: TextField(
        controller: _embySearchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          labelText: '搜索媒体库',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _embyKeyword.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: '清除搜索',
                  onPressed: _clearEmbySearch,
                ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          isDense: true,
        ),
        onSubmitted: (_) => _searchEmby(),
      ),
    );
  }

  Widget _buildBilibiliVideoSelector(
    ThemeData theme,
    List<BilibiliVideoItemInfo> videos,
  ) {
    final selectedIndex =
        _biliSelectedIndex.clamp(0, videos.length - 1).toInt();
    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: videos.length,
        separatorBuilder: (_, __) => Divider(
            height: 1, color: theme.dividerColor.withValues(alpha: 0.08)),
        itemBuilder: (context, index) {
          final video = videos[index];
          final selected = index == selectedIndex;
          final title = video.name.isEmpty ? '视频 ${index + 1}' : video.name;
          final subtitle = video.isLive
              ? '直播间 ${video.cid > 0 ? video.cid : video.epid}'
              : video.epid > 0
                  ? 'EP ${video.epid} · CID ${video.cid}'
                  : '${video.bvid} · CID ${video.cid}';
          return ListTile(
            dense: true,
            selected: selected,
            leading: Icon(
              video.isLive
                  ? Icons.live_tv_rounded
                  : selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
              color: selected ? const Color(0xFFFB7299) : theme.hintColor,
            ),
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle:
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => setState(() => _biliSelectedIndex = index),
          );
        },
      ),
    );
  }

  Widget _buildFileItem(
      ThemeData theme, String name, bool isDir, VoidCallback onTap,
      {String? subtitle,
      String? thumbnailUrl,
      Color? iconColor,
      bool? isSelected,
      ValueChanged<bool?>? onSelectionChanged}) {
    final hasThumbnail = thumbnailUrl != null && thumbnailUrl.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onSelectionChanged != null)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isSelected ?? false,
                    onChanged: onSelectionChanged,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 40,
                height: 40,
                child: hasThumbnail
                    ? Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFileIcon(isDir, iconColor),
                      )
                    : _buildFileIcon(isDir, iconColor),
              ),
            ),
          ],
        ),
        title: Text(name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: TextStyle(fontSize: 12, color: theme.hintColor))
            : null,
      ),
    );
  }

  Widget _buildFileIcon(bool isDir, Color? iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDir ? Colors.amber : (iconColor ?? Colors.blue))
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isDir ? Icons.folder_rounded : Icons.movie_rounded,
        color: isDir ? Colors.amber : (iconColor ?? Colors.blue),
      ),
    );
  }

  Widget _buildBindGuide(String name, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.link_off_rounded,
              size: 64, color: theme.disabledColor.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('未绑定 $name',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('请先绑定账号以访问资源', style: TextStyle(color: theme.hintColor)),
          const SizedBox(height: 24),
          Material(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () async {
                await PlatformBindingDialog.show(context,
                    initialIndex: _providerBindingIndexByName(name));
                _checkVendors();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '立即绑定 $name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int? _providerBindingIndex(int selectedIndex) {
    return switch (selectedIndex) {
      2 => 2,
      3 => 0,
      4 => 1,
      _ => null,
    };
  }

  int _providerBindingIndexByName(String name) {
    return switch (name.toLowerCase()) {
      'bilibili' => 2,
      'emby' => 1,
      _ => 0,
    };
  }

  void _applyDefaultProviderBindings() {
    if (_alistBinds.isNotEmpty &&
        !_alistBinds.any((bind) =>
            bind.serverId == _alistServerId &&
            bind.providerInstanceName == _alistInstanceName)) {
      final bind = _alistBinds.first;
      _alistServerId = bind.serverId;
      _alistInstanceName = bind.providerInstanceName;
    }
    if (_embyBinds.isNotEmpty &&
        !_embyBinds.any((bind) =>
            bind.serverId == _embyServerId &&
            bind.providerInstanceName == _embyInstanceName)) {
      final bind = _embyBinds.first;
      _embyServerId = bind.serverId;
      _embyInstanceName = bind.providerInstanceName;
    }
    if (_bilibiliBinds.isNotEmpty &&
        !_bilibiliBinds.any(
          (bind) => bind.providerInstanceName == _bilibiliInstanceName,
        )) {
      _bilibiliInstanceName = _bilibiliBinds.first.providerInstanceName;
    }
  }

  String _providerBindKey(String serverId, String instanceName) {
    return '$serverId@$instanceName';
  }

  String _providerBindLabel({
    required String title,
    required String instanceName,
  }) {
    final instanceLabel = instanceName.isEmpty ? '本地实例' : instanceName;
    return '$title · $instanceLabel';
  }

  String _formatSize(dynamic size) {
    if (size == null) return '';
    if (size is! num) return size.toString();
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(size / 1024 / 1024 / 1024).toStringAsFixed(1)} GB';
  }

  Future<void> _addDirectLink() async {
    late final List<String> urls;
    late final Map<String, String> headers;
    try {
      urls = _parseDirectUrls(_urlController.text);
      headers = DirectUrlSourceConfig.parseHeaderLines(
        _directHeadersController.text,
      );
    } on DirectUrlSourceConfigException catch (e) {
      MessageUtils.showWarning(context, e.message);
      return;
    }

    if (DirectUrlSourceConfig.hasCredentialHeaders(headers)) {
      final confirmed = await _confirmDirectCredentialHeaders(headers);
      if (!confirmed) return;
    }

    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      if (urls.length == 1) {
        await WatchTogetherService.addDirectUrlMedia(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          url: urls.single,
          name: name,
          headers: headers,
        );
      } else {
        await WatchTogetherService.addMediaBatch(
          widget.roomId,
          urls
              .map(
                (url) => {
                  'playlist_id': widget.parentId ?? '',
                  'source_provider': DirectUrlSourceConfig.sourceProvider,
                  'source_config': DirectUrlSourceConfig.fromUserInput(
                    url: url,
                    headers: headers,
                  ).toJson(),
                  'name': '',
                },
              )
              .toList(growable: false),
        );
      }
      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showSuccess(
          context,
          urls.length == 1 ? '添加成功' : '已添加 ${urls.length} 项',
        );
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '添加失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool> _confirmDirectCredentialHeaders(
    Map<String, String> headers,
  ) async {
    final names =
        DirectUrlSourceConfig.credentialHeaderNames(headers).join('、');
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '确认共享凭据请求头',
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.orange.shade700,
      ),
      iconColor: Colors.orange.shade700,
      content: Text(
        '$names 会随播放信息提供给房间成员，用于请求媒体资源。继续添加前请确认房间成员可信，且这些凭据泄漏不会影响你的账号安全。',
        style: TextStyle(
          height: 1.5,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '确认添加',
        ),
      ],
    );
    return confirmed == true;
  }

  List<String> _parseDirectUrls(String input) {
    final urls = <String>[];
    for (final rawLine in input.split('\n')) {
      final url = rawLine.trim();
      if (url.isEmpty) continue;
      urls.add(DirectUrlSourceConfig.validateUrl(url));
    }
    if (urls.isEmpty) {
      throw const DirectUrlSourceConfigException('请输入 http/https 链接');
    }
    return urls;
  }

  Future<void> _addRtmpPublish() async {
    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      final mediaId = await WatchTogetherService.addRtmpMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        name: name.isEmpty ? 'RTMP 直播' : name,
      );
      final publish = await WatchTogetherService.createRtmpPublishKeyInfo(
        widget.roomId,
        mediaId,
      );
      final streamInfo = await WatchTogetherService.getRtmpStreamInfo(
        roomId: widget.roomId,
        mediaId: mediaId,
      );
      if (mounted) {
        Navigator.pop(context);
        await _showRtmpPublishDialog(
          publish: publish,
          streamInfo: streamInfo,
        );
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '创建推流入口失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showRtmpPublishDialog({
    required RtmpPublishKeyInfo publish,
    required RoomStreamEntryInfo streamInfo,
  }) {
    final publicSettings = _publicSettings;
    return ChatUtils.showStyledDialog<void>(
      context: context,
      title: 'RTMP 推流',
      icon: const Icon(Icons.live_tv_rounded, color: Color(0xFF5D5FEF)),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRtmpInfoRow('推流地址', publish.rtmpUrl, copyable: true),
            _buildRtmpInfoRow('Stream Key', publish.streamKey, copyable: true),
            _buildRtmpInfoRow('Publish Key', publish.publishKey,
                copyable: true),
            if (publicSettings?.customPublishHost.isNotEmpty == true)
              _buildRtmpInfoRow(
                '发布主机',
                publicSettings!.customPublishHost,
                copyable: true,
              ),
            if (publicSettings != null)
              _buildRtmpInfoRow(
                'TS 伪装',
                publicSettings.tsDisguisedAsPng ? '启用 PNG 伪装' : '未启用',
              ),
            _buildRtmpInfoRow('过期时间', _formatTimestamp(publish.expiresAt)),
            _buildRtmpInfoRow('当前状态', streamInfo.active ? '活跃' : '未活跃'),
          ],
        ),
      ),
      actions: [
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context),
          text: '完成',
        ),
      ],
    );
  }

  Widget _buildRtmpPublicSettingsPanel(
    ThemeData theme,
    PublicSettingsInfo settings,
  ) {
    final publishHost = settings.customPublishHost.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            publishHost.isEmpty ? '使用服务端默认发布主机' : publishHost,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            settings.tsDisguisedAsPng ? '直播切片会以 PNG 形式分发' : '直播切片按 TS 形式分发',
            style: TextStyle(fontSize: 12, color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRtmpInfoRow(
    String label,
    String value, {
    bool copyable = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: TextStyle(color: theme.hintColor)),
          ),
          Expanded(
            child: SelectableText(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (copyable) ...[
            const SizedBox(width: 8),
            IconButton(
              tooltip: '复制',
              icon: const Icon(Icons.copy_rounded, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                MessageUtils.showSuccess(context, '已复制');
              },
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _parseBilibili() async {
    final url = _biliUrlController.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _isLoading = true;
      _biliInfo = null;
    });
    try {
      final info = await WatchTogetherService.parseBilibiliInfo(
        url,
        instanceName: _bilibiliInstanceName,
      );
      if (mounted) {
        setState(() {
          _biliInfo = info;
          _biliSelectedIndex = 0;
        });
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '解析失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addBilibili() async {
    if (_biliInfo == null) return;
    setState(() => _isLoading = true);

    try {
      final videos = _biliInfo!.videos;
      if (videos.isEmpty) {
        throw Exception('无法获取 Bilibili 视频信息');
      }
      final selectedIndex =
          _biliSelectedIndex.clamp(0, videos.length - 1).toInt();
      final selectedVideo = videos[selectedIndex];

      final sourceConfig = _bilibiliSourceConfig(selectedVideo);
      final title = _biliInfo!.title.isNotEmpty
          ? _biliInfo!.title
          : (selectedVideo.name.isEmpty ? 'Bilibili' : selectedVideo.name);
      await WatchTogetherService.addBilibiliMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        providerInstanceName: _bilibiliInstanceName,
        sourceConfig: sourceConfig,
        name: title,
      );
      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showSuccess(context, '添加成功');
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '添加失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _bilibiliSourceConfig(BilibiliVideoItemInfo video) {
    if (video.isLive) {
      final roomId = video.cid > 0 ? video.cid : video.epid;
      if (roomId <= 0) throw Exception('无法获取 Bilibili 直播间 ID');
      return {
        'type': 'live',
        'room_id': roomId,
      };
    }
    if (video.epid > 0) {
      if (video.cid <= 0) throw Exception('无法获取 Bilibili CID');
      return {
        'type': 'pgc',
        'epid': video.epid,
        'cid': video.cid,
      };
    }
    if (video.bvid.isEmpty || video.cid <= 0) {
      throw Exception('无法获取 BVID 或 CID');
    }
    return {
      'type': 'video',
      'bvid': video.bvid,
      'cid': video.cid,
    };
  }

  Future<void> _loadAlist(String path, {bool loadMore = false}) async {
    if (loadMore && _alistLoading) return;

    int targetPage = loadMore ? _alistPage + 1 : 1;
    final keyword = _alistKeyword;
    final password = _alistPasswordController.text;
    if (password != _alistPassword) {
      _alistPassword = password;
    }

    setState(() {
      _alistLoading = true;
      if (!loadMore) {
        _alistPath = path;
        _alistFiles = [];
      }
    });

    try {
      final pageInfo = await WatchTogetherService.listAlistPage(
        path,
        keyword: keyword,
        page: targetPage,
        max: _pageSize,
        password: password,
        serverId: _alistServerId,
        instanceName: _alistInstanceName,
      );
      final newItems = pageInfo.items;
      final total = pageInfo.total;

      if (mounted) {
        setState(() {
          _alistServerId = pageInfo.serverId;
          _alistInstanceName = pageInfo.providerInstanceName;
          if (loadMore) {
            _alistFiles.addAll(newItems);
            _alistPage = targetPage;
          } else {
            _alistFiles = newItems;
            _alistPage = 1;
          }

          _alistHasMore = _alistFiles.length < total;
        });
      }
    } catch (e) {
      debugPrint('Alist load error: $e');
      if (mounted) MessageUtils.showError(context, '加载失败: $e');
    } finally {
      if (mounted) setState(() => _alistLoading = false);
    }
  }

  void _searchAlist() {
    final keyword = _alistSearchController.text.trim();
    if (keyword == _alistKeyword) return;
    setState(() {
      _alistKeyword = keyword;
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _clearAlistSearch() {
    if (_alistKeyword.isEmpty && _alistSearchController.text.isEmpty) return;
    _alistSearchController.clear();
    setState(() {
      _alistKeyword = '';
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _applyAlistPassword() {
    final password = _alistPasswordController.text;
    if (password == _alistPassword) return;
    setState(() {
      _alistPassword = password;
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _clearAlistPassword() {
    if (_alistPassword.isEmpty && _alistPasswordController.text.isEmpty) {
      return;
    }
    _alistPasswordController.clear();
    setState(() {
      _alistPassword = '';
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _openAlistDirectory(String path) {
    if (_alistKeyword.isNotEmpty) {
      _alistSearchController.clear();
      setState(() {
        _alistKeyword = '';
        _selectedAlistItems.clear();
      });
    }
    _loadAlist(path);
  }

  void _goUpAlist() {
    if (_alistPath == '/') return;
    if (_alistKeyword.isNotEmpty) {
      _clearAlistSearch();
      return;
    }
    final parts = _alistPath.split('/');
    parts.removeLast();
    _loadAlist(parts.length == 1 && parts[0] == '' ? '/' : parts.join('/'));
  }

  Future<void> _addAlistFile(AlistItemInfo file) async {
    if (_alistServerId.isEmpty) {
      MessageUtils.showWarning(context, '请选择已绑定的 Alist 账号');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final password = _alistPasswordController.text;
      await WatchTogetherService.addAlistMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        serverId: _alistServerId,
        path: file.path,
        password: password,
        name: file.name,
        providerInstanceName: _alistInstanceName,
      );
      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showSuccess(context, '添加成功');
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '添加失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addSelectedAlistItems() async {
    if (_selectedAlistItems.isEmpty) return;
    if (_alistServerId.isEmpty) {
      MessageUtils.showWarning(context, '请选择已绑定的 Alist 账号');
      return;
    }
    setState(() => _isLoading = true);

    try {
      final List<Map<String, dynamic>> items = [];
      final password = _alistPasswordController.text;
      for (final file in _selectedAlistItems.values) {
        final sourceConfig = <String, dynamic>{
          'server_id': _alistServerId,
          'path': file.path,
        };
        if (password.isNotEmpty) sourceConfig['password'] = password;
        items.add({
          'playlist_id': widget.parentId ?? '',
          'source_provider': 'alist',
          'provider_instance_name': _alistInstanceName,
          'source_config': sourceConfig,
          'name': file.name,
        });
      }

      await WatchTogetherService.addMediaBatch(widget.roomId, items);

      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showSuccess(
            context, '已添加 ${_selectedAlistItems.length} 项');
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '批量添加失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadEmby(String path, {bool loadMore = false}) async {
    if (loadMore && _embyLoading) return;
    final targetPage = loadMore ? _embyPage + 1 : 1;
    final keyword = _embyKeyword;

    setState(() {
      _embyLoading = true;
      if (!loadMore) {
        _embyPath = path;
        _embyFiles = [];
      }
    });
    try {
      final pageInfo = await WatchTogetherService.listEmbyPage(
        path,
        keyword: keyword,
        page: targetPage,
        max: _pageSize,
        serverId: _embyServerId,
        instanceName: _embyInstanceName,
      );
      final newItems = pageInfo.items;
      final total = pageInfo.total;
      if (mounted) {
        setState(() {
          _embyServerId = pageInfo.serverId;
          _embyInstanceName = pageInfo.providerInstanceName;
          if (loadMore) {
            _embyFiles.addAll(newItems);
            _embyPage = targetPage;
          } else {
            _embyFiles = newItems;
            _embyPage = 1;
          }
          _embyHasMore = _embyFiles.length < total;
        });
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载失败: $e');
    } finally {
      if (mounted) setState(() => _embyLoading = false);
    }
  }

  void _searchEmby() {
    final keyword = _embySearchController.text.trim();
    if (keyword == _embyKeyword) return;
    setState(() {
      _embyKeyword = keyword;
      _embyPage = 1;
      _embyHasMore = true;
    });
    _loadEmby(_embyPath);
  }

  void _clearEmbySearch() {
    if (_embyKeyword.isEmpty && _embySearchController.text.isEmpty) return;
    _embySearchController.clear();
    setState(() {
      _embyKeyword = '';
      _embyPage = 1;
      _embyHasMore = true;
    });
    _loadEmby(_embyPath);
  }

  void _enterEmbyDir(String name, String pathOrId) {
    if (_embyKeyword.isNotEmpty) {
      _embySearchController.clear();
      setState(() => _embyKeyword = '');
    }
    _loadEmby((pathOrId.contains('/') || pathOrId.length > 20)
        ? pathOrId
        : (_embyPath.endsWith('/') ? '$_embyPath$name' : '$_embyPath/$name'));
  }

  void _goUpEmby() {
    if (_embyPath == '/') return;
    if (_embyKeyword.isNotEmpty) {
      _clearEmbySearch();
      return;
    }
    final parts = _embyPath.split('/');
    parts.removeLast();
    _loadEmby(parts.length == 1 && parts[0] == '' ? '/' : parts.join('/'));
  }

  Future<void> _addEmbyFile(EmbyItemInfo file) async {
    if (_embyServerId.isEmpty) {
      MessageUtils.showWarning(context, '请选择已绑定的 Emby 账号');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final itemId = file.id;
      if (itemId.isEmpty) {
        throw Exception('无法获取 Emby 媒体 ID');
      }
      await WatchTogetherService.addEmbyMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        serverId: _embyServerId,
        itemId: itemId,
        name: file.name.isEmpty ? 'Emby Video' : file.name,
        providerInstanceName: _embyInstanceName,
      );
      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showSuccess(context, '添加成功');
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '添加失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
