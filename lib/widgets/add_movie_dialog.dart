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
    final theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.58),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width < 560 ? 10 : 18,
            vertical: MediaQuery.sizeOf(context).height < 720 ? 10 : 24,
          ),
          clipBehavior: Clip.antiAlias,
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 920,
              maxHeight: MediaQuery.sizeOf(context).height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AddMovieDialogHeader(),
                Flexible(
                  child: AddMovieDialog(roomId: roomId, parentId: parentId),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  State<AddMovieDialog> createState() => _AddMovieDialogState();
}

class _AddMovieDialogHeader extends StatelessWidget {
  const _AddMovieDialogHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.94),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.add_to_queue_rounded,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '添加影片',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.close_rounded),
            tooltip: '关闭',
          ),
        ],
      ),
    );
  }
}

class _MovieSourceSpec {
  const _MovieSourceSpec({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _DirectHeaderDraft {
  _DirectHeaderDraft({String name = '', String value = ''})
      : key = UniqueKey(),
        nameController = TextEditingController(text: name),
        valueController = TextEditingController(text: value);

  final Key key;
  final TextEditingController nameController;
  final TextEditingController valueController;

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}

class _AddMovieDialogState extends State<AddMovieDialog> {
  int _selectedIndex = 0;

  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _biliUrlController = TextEditingController();
  final _alistSearchController = TextEditingController();
  final _alistPasswordController = TextEditingController();
  final _embySearchController = TextEditingController();

  bool _isProxy = false;
  bool _isLoading = false;
  String _directHeaderError = '';

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
  final List<_DirectHeaderDraft> _directHeaders = [];

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
    for (final header in _directHeaders) {
      header.dispose();
    }
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
    final compact = size.width < 720;
    final contentHeight = compact
        ? (size.height * 0.76).clamp(500.0, 660.0)
        : (size.height * 0.54).clamp(380.0, 500.0);

    return PopScope(
      canPop: !_hasUnsavedDraft,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!context.mounted) return;
        final confirmed = await _confirmDiscardDraft();
        if (!mounted || !confirmed) return;
        Navigator.of(this.context).pop();
      },
      child: SizedBox(
        height: contentHeight,
        child: compact
            ? Column(
                children: [
                  _buildCompactSourceRail(theme),
                  Expanded(child: _buildSourcePanel(theme, compact: true)),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 236,
                    child: _buildSourceRail(theme),
                  ),
                  VerticalDivider(
                    width: 1,
                    color:
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
                  ),
                  Expanded(child: _buildSourcePanel(theme)),
                ],
              ),
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
        return 'AList 网盘';
      case 4:
        return 'Emby 媒体库';
      default:
        return '';
    }
  }

  List<_MovieSourceSpec> get _sourceSpecs => [
        const _MovieSourceSpec(
          index: 0,
          title: '直链',
          subtitle: 'HTTP / HTTPS / HLS',
          icon: Icons.link_rounded,
          color: Color(0xFF5D5FEF),
        ),
        _MovieSourceSpec(
          index: 1,
          title: 'RTMP 推流',
          subtitle: '生成推流地址',
          icon: Icons.upload_rounded,
          color: Colors.deepOrange.shade600,
        ),
        const _MovieSourceSpec(
          index: 2,
          title: 'Bilibili',
          subtitle: 'BV / 链接解析',
          icon: Icons.tv_rounded,
          color: Color(0xFFFB7299),
        ),
        _MovieSourceSpec(
          index: 3,
          title: 'AList 网盘',
          subtitle: '挂载目录资源',
          icon: Icons.cloud_circle_rounded,
          color: Colors.amber.shade700,
        ),
        _MovieSourceSpec(
          index: 4,
          title: 'Emby 媒体库',
          subtitle: '个人媒体服务器',
          icon: Icons.video_library_rounded,
          color: Colors.green.shade600,
        ),
      ];

  void _selectSource(int index) {
    setState(() {
      _selectedIndex = index;
      _isProxy = index == 2 || index == 3;
    });
    if (index == 3 && _alistBinds.isNotEmpty && _alistFiles.isEmpty) {
      _loadAlist('/');
    }
    if (index == 4 && _embyBinds.isNotEmpty && _embyFiles.isEmpty) {
      _loadEmby('/');
    }
  }

  Widget _buildSourceRail(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '来源',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          for (final spec in _sourceSpecs) ...[
            _buildSourceTile(theme, spec),
            const SizedBox(height: 6),
          ],
          const Spacer(),
          if (_checkingVendors)
            const LinearProgressIndicator(minHeight: 2)
          else
            Text(
              '已连接 ${_boundVendors.length} 个媒体源',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactSourceRail(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final spec in _sourceSpecs)
            SizedBox(
              width: 160,
              child: _buildSourceTile(theme, spec, compact: true),
            ),
        ],
      ),
    );
  }

  Widget _buildSourceTile(
    ThemeData theme,
    _MovieSourceSpec spec, {
    bool compact = false,
  }) {
    final selected = _selectedIndex == spec.index;
    return Material(
      color: selected
          ? spec.color.withValues(alpha: 0.13)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _selectSource(spec.index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 11,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? spec.color.withValues(alpha: 0.55)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: compact ? 30 : 32,
                height: compact ? 30 : 32,
                decoration: BoxDecoration(
                  color: spec.color.withValues(alpha: selected ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(spec.icon, color: spec.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spec.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      spec.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourcePanel(ThemeData theme, {bool compact = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 58,
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getTitle(_selectedIndex),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (_providerBindingIndex(_selectedIndex) != null)
                TextButton.icon(
                  onPressed: () async {
                    await PlatformBindingDialog.show(
                      context,
                      initialIndex: _providerBindingIndex(_selectedIndex)!,
                    );
                    await _checkVendors();
                    if (!mounted) return;
                    if (_selectedIndex == 3 && _alistBinds.isNotEmpty) {
                      _loadAlist(_alistPath);
                    }
                    if (_selectedIndex == 4 && _embyBinds.isNotEmpty) {
                      _loadEmby(_embyPath);
                    }
                  },
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: const Text('媒体源'),
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(compact ? 14 : 18),
            child: _buildContent(theme),
          ),
        ),
      ],
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
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _urlController,
            minLines: 1,
            maxLines: 2,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.newline,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: '视频链接',
              hintText: '每行一个 HTTP / HTTPS / HLS 地址',
              prefixIcon: const Icon(Icons.link_rounded),
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: '视频名称（单条可选）',
              hintText: '默认为文件名',
              prefixIcon: const Icon(Icons.title_rounded),
              isDense: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10),
          _buildDirectHeadersEditor(theme),
          if (_directHeadersContainCredentials())
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildDirectHeaderRiskNotice(theme),
            ),
          const SizedBox(height: 18),
          _buildActionButton(
            '添加到播放列表',
            _addDirectLink,
            icon: Icons.playlist_add_rounded,
          ),
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

  Widget _buildDirectHeadersEditor(ThemeData theme) {
    final borderColor =
        theme.colorScheme.outlineVariant.withValues(alpha: 0.45);
    final validationMessage = _directHeaderError;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.http_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '请求头',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _addDirectHeaderRow,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('请求头'),
              ),
            ],
          ),
          if (_directHeaders.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 2, 0, 4),
              child: Text(
                '默认不发送额外请求头。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            const SizedBox(height: 8),
            for (var i = 0; i < _directHeaders.length; i++) ...[
              _buildDirectHeaderRow(theme, i),
              if (i != _directHeaders.length - 1) const SizedBox(height: 8),
            ],
            if (validationMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildInlineValidationMessage(theme, validationMessage),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInlineValidationMessage(ThemeData theme, String message) {
    final color = theme.colorScheme.error;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectHeaderRow(ThemeData theme, int index) {
    final header = _directHeaders[index];
    return KeyedSubtree(
      key: header.key,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final border = OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          );
          final nameField = TextField(
            controller: header.nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: '名称',
              hintText: 'Referer',
              isDense: true,
              border: border,
            ),
            onChanged: (_) => _updateDirectHeaderValidation(),
          );
          final valueField = TextField(
            controller: header.valueController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: '值',
              hintText: 'https://example.com',
              isDense: true,
              border: border,
            ),
            onChanged: (_) => _updateDirectHeaderValidation(),
          );
          final removeButton = IconButton(
            onPressed: () => _removeDirectHeaderRow(index),
            icon: const Icon(Icons.close_rounded),
            tooltip: '移除请求头',
          );

          if (compact) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 150, child: nameField),
                const SizedBox(width: 8),
                Expanded(child: valueField),
                removeButton,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 180, child: nameField),
              const SizedBox(width: 8),
              Expanded(child: valueField),
              removeButton,
            ],
          );
        },
      ),
    );
  }

  Widget _buildRtmpPublishContent(ThemeData theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          _buildInlineNotice(
            theme,
            icon: Icons.key_rounded,
            title: '创建后会生成推流地址和 Stream Key',
            subtitle: '复制到 OBS 或其他推流工具即可开始直播。',
            color: Colors.deepOrange.shade600,
          ),
          const SizedBox(height: 24),
          _buildActionButton(
            '创建推流入口',
            _addRtmpPublish,
            color: Colors.deepOrange.shade600,
            icon: Icons.live_tv_rounded,
          ),
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
          child: Row(
            children: [
              Expanded(
                child: _buildTextField(theme, _biliUrlController, '视频链接 / BV号',
                    '粘贴链接自动解析', Icons.search),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _isLoading ? null : _parseBilibili,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFB7299),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(48, 48),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: _biliInfo == null
              ? Center(
                  child: _buildEmptyState(
                    theme,
                    icon: Icons.tv_rounded,
                    title: '粘贴 Bilibili 链接',
                    subtitle: '支持 BV 号、视频链接和直播间链接。',
                    color: const Color(0xFFFB7299),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
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
                      _buildActionButton(
                        '添加到播放列表',
                        _addBilibili,
                        color: const Color(0xFFFB7299),
                        icon: Icons.playlist_add_rounded,
                      ),
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
      return _buildBindGuide('AList', theme);
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
              ? _buildEmptyState(
                  theme,
                  icon: Icons.cloud_queue_rounded,
                  title: '暂无文件',
                  subtitle: '当前目录没有可添加的媒体资源。',
                  color: Colors.amber.shade700,
                )
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
            child: _buildActionButton(
              '添加选中的 ${_selectedAlistItems.length} 项',
              _addSelectedAlistItems,
              icon: Icons.playlist_add_check_rounded,
            ),
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
              ? _buildEmptyState(
                  theme,
                  icon: Icons.video_library_rounded,
                  title: '暂无媒体',
                  subtitle: '当前媒体库目录没有可添加的项目。',
                  color: Colors.green.shade600,
                )
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

  Widget _buildActionButton(String text, VoidCallback onPressed,
      {Color? color, IconData? icon}) {
    final buttonColor = color ?? themeColor(context);
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: _isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(168, 46),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon ?? Icons.check_rounded, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Color themeColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  Widget _buildInlineNotice(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ],
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

  String _directUrlDisplayName(String url) {
    final parsed = Uri.tryParse(url);
    final segments = parsed?.pathSegments
            .where((segment) => segment.trim().isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final fileName = segments.isEmpty ? '' : Uri.decodeComponent(segments.last);
    if (fileName.isNotEmpty) return fileName;
    final host = parsed?.host ?? '';
    if (host.isNotEmpty) return host;
    return '直链视频';
  }

  void _addDirectHeaderRow() {
    final hasBlank = _directHeaders.any((header) =>
        header.nameController.text.trim().isEmpty &&
        header.valueController.text.trim().isEmpty);
    if (hasBlank) {
      setState(() => _directHeaderError = '请先填写当前空白请求头');
      return;
    }
    setState(() {
      _directHeaders.add(_DirectHeaderDraft());
      _directHeaderError = _currentDirectHeaderValidationMessage();
    });
  }

  void _removeDirectHeaderRow(int index) {
    if (index < 0 || index >= _directHeaders.length) return;
    final header = _directHeaders.removeAt(index);
    header.dispose();
    _updateDirectHeaderValidation();
  }

  void _updateDirectHeaderValidation() {
    final message = _currentDirectHeaderValidationMessage();
    if (!mounted || _directHeaderError == message) return;
    setState(() => _directHeaderError = message);
  }

  String _currentDirectHeaderValidationMessage() {
    try {
      _collectDirectHeaders(validateCompleteRows: false);
      return '';
    } on DirectUrlSourceConfigException catch (e) {
      return e.message;
    }
  }

  bool _directHeadersContainCredentials() {
    return DirectUrlSourceConfig.hasCredentialHeaders(
      _directHeaders
          .where((header) => header.nameController.text.trim().isNotEmpty)
          .fold<Map<String, String>>(
        {},
        (headers, header) {
          headers[header.nameController.text.trim()] =
              header.valueController.text.trim();
          return headers;
        },
      ),
    );
  }

  Map<String, String> _collectDirectHeaders({
    bool validateCompleteRows = true,
  }) {
    final headers = <String, String>{};
    final normalizedNames = <String>{};
    for (final draft in _directHeaders) {
      final name = draft.nameController.text.trim();
      final value = draft.valueController.text.trim();
      if (name.isEmpty && value.isEmpty) continue;
      if (validateCompleteRows && (name.isEmpty || value.isEmpty)) {
        throw const DirectUrlSourceConfigException('请填写完整的请求头名称和值');
      }
      if (name.isNotEmpty) {
        DirectUrlSourceConfig.validateHeaderName(name);
        final normalized = name.toLowerCase();
        if (!normalizedNames.add(normalized)) {
          throw DirectUrlSourceConfigException('请求头 $name 重复');
        }
      }
      if (validateCompleteRows) {
        headers[name] = value;
      } else if (name.isNotEmpty && value.isNotEmpty) {
        headers[name] = value;
      }
    }
    DirectUrlSourceConfig.validateHeaders(headers);
    return headers;
  }

  bool get _hasUnsavedDraft {
    if (_urlController.text.trim().isNotEmpty ||
        _nameController.text.trim().isNotEmpty ||
        _biliUrlController.text.trim().isNotEmpty ||
        _alistSearchController.text.trim().isNotEmpty ||
        _embySearchController.text.trim().isNotEmpty) {
      return true;
    }
    return _directHeaders.any((header) =>
        header.nameController.text.trim().isNotEmpty ||
        header.valueController.text.trim().isNotEmpty);
  }

  Future<bool> _confirmDiscardDraft() async {
    final result = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '放弃当前编辑？',
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.error,
      ),
      iconColor: Theme.of(context).colorScheme.error,
      content: Text(
        '已填写的影片链接、名称或请求头会被清空。',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('继续编辑'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: const Text('放弃'),
        ),
      ],
    );
    return result == true;
  }

  Future<void> _addDirectLink() async {
    late final List<String> urls;
    late final Map<String, String> headers;
    try {
      urls = _parseDirectUrls(_urlController.text);
      headers = _collectDirectHeaders();
    } on DirectUrlSourceConfigException catch (e) {
      setState(() => _directHeaderError = e.message);
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
          name: name.isEmpty ? _directUrlDisplayName(urls.single) : name,
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
                  'name': _directUrlDisplayName(url),
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
    if (_alistBinds.isEmpty || _alistServerId.isEmpty) return;
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
      debugPrint('AList load error: $e');
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
      MessageUtils.showWarning(context, '请选择已绑定的 AList 账号');
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
      MessageUtils.showWarning(context, '请选择已绑定的 AList 账号');
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
    if (_embyBinds.isEmpty || _embyServerId.isEmpty) return;
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
