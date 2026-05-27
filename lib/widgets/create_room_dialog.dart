import 'package:flutter/material.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';

Future<void> showCreateRoomDialog({
  required BuildContext context,
  required Future<void> Function(WRoom room) onCreated,
  double width = 360,
  String successMessage = '房间创建成功',
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final iconColor = isDark ? Colors.blue.shade300 : theme.primaryColor;
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (dialogContext) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 16,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add_box_outlined,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '创建房间',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Flexible(
                child: _CreateRoomDialogBody(
                  pageContext: context,
                  width: width,
                  onCreated: onCreated,
                  successMessage: successMessage,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _CreateRoomDialogBody extends StatefulWidget {
  final BuildContext pageContext;
  final double width;
  final Future<void> Function(WRoom room) onCreated;
  final String successMessage;

  const _CreateRoomDialogBody({
    required this.pageContext,
    required this.width,
    required this.onCreated,
    required this.successMessage,
  });

  @override
  State<_CreateRoomDialogBody> createState() => _CreateRoomDialogBodyState();
}

class _CreateRoomDialogBodyState extends State<_CreateRoomDialogBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  PublicSettingsInfo? _settings;
  Object? _settingsError;
  bool _loadingSettings = true;
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await WatchTogetherService.getPublicSettings();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _loadingSettings = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _settingsError = error;
        _loadingSettings = false;
      });
    }
  }

  bool get _creationDisabled {
    final settings = _settings;
    return settings != null &&
        (settings.disableCreateRoom || !settings.allowRoomCreation);
  }

  String get _passwordPolicy =>
      _settings?.roomPasswordPolicy.toLowerCase() ?? '';

  bool get _passwordRequired => _passwordPolicy == 'required';

  bool get _passwordForbidden => _passwordPolicy == 'forbidden';

  bool get _canSubmit =>
      !_creating && !_loadingSettings && _settingsError == null;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    if (_creationDisabled) {
      MessageUtils.showWarning(context, '服务器当前已关闭房间创建');
      return;
    }

    final name = _nameController.text.trim();
    final password = _passwordController.text;
    if (name.isEmpty) {
      MessageUtils.showWarning(context, '请输入房间名称');
      return;
    }
    if (_passwordRequired && password.isEmpty) {
      MessageUtils.showWarning(context, '服务器要求创建房间时设置密码');
      return;
    }
    if (_passwordForbidden && password.isNotEmpty) {
      MessageUtils.showWarning(context, '服务器禁止为新房间设置密码');
      return;
    }

    setState(() => _creating = true);
    try {
      final room = await WatchTogetherService.createRoom(
        name,
        password: password.isEmpty ? null : password,
      );
      if (!mounted) return;
      Navigator.pop(context);
      await widget.onCreated(room);
      final pendingReview = _settings?.createRoomNeedReview == true ||
          room.status != common_enum.RoomStatus.ROOM_STATUS_ACTIVE.value;
      if (!widget.pageContext.mounted) return;
      MessageUtils.showSuccess(
        widget.pageContext,
        pendingReview ? '房间已提交审核' : widget.successMessage,
      );
    } catch (error) {
      if (mounted) {
        MessageUtils.showError(context, '创建房间失败: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _creating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordLabel = _passwordRequired
        ? '密码'
        : _passwordForbidden
            ? '密码'
            : '密码 (可选)';
    final passwordHint = _passwordRequired
        ? '服务器要求创建房间时设置密码'
        : _passwordForbidden
            ? '服务器禁止为新房间设置密码'
            : '留空表示公开房间';

    return SizedBox(
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_loadingSettings) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 16),
          ],
          if (_settingsError != null) ...[
            const _CreateRoomPolicyBanner(
              icon: Icons.cloud_off_outlined,
              text: '无法读取服务器创建策略，请稍后重试。',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
          ],
          if (_creationDisabled) ...[
            const _CreateRoomPolicyBanner(
              icon: Icons.block_outlined,
              text: '服务器当前已关闭房间创建。',
              color: Colors.red,
            ),
            const SizedBox(height: 16),
          ] else if (_settings?.createRoomNeedReview == true) ...[
            const _CreateRoomPolicyBanner(
              icon: Icons.fact_check_outlined,
              text: '新房间需要管理员审核，通过后才会对其他用户开放。',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
          ],
          if (_settings?.roomCreationPolicyHints.isNotEmpty == true) ...[
            _CreateRoomPolicySummary(settings: _settings!),
            const SizedBox(height: 16),
          ],
          ChatUtils.createFormField(
            context: context,
            label: '房间名称',
            controller: _nameController,
            hintText: '请输入房间名称',
            prefixIcon: Icons.meeting_room_outlined,
            enabled: !_creating && !_creationDisabled && _settingsError == null,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: passwordLabel,
            controller: _passwordController,
            hintText: passwordHint,
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            enabled: !_creating && !_passwordForbidden && !_creationDisabled,
            helperText: _passwordForbidden ? '当前服务器策略要求所有新房间保持公开。' : null,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChatUtils.createCancelButton(context),
              const SizedBox(width: 8),
              ChatUtils.createConfirmButton(
                context,
                _canSubmit ? _submit : () {},
                text: _creating ? '创建中' : '创建',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateRoomPolicySummary extends StatelessWidget {
  final PublicSettingsInfo settings;

  const _CreateRoomPolicySummary({required this.settings});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hints = settings.roomCreationPolicyHints;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: hints
            .map(
              (hint) => _CreateRoomPolicyChip(
                text: hint,
                isDark: isDark,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _CreateRoomPolicyChip extends StatelessWidget {
  final String text;
  final bool isDark;

  const _CreateRoomPolicyChip({
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.blueGrey.withValues(alpha: 0.2)
            : Colors.blueGrey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.blueGrey.shade100 : Colors.blueGrey.shade700,
        ),
      ),
    );
  }
}

class _CreateRoomPolicyBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final MaterialColor color;

  const _CreateRoomPolicyBanner({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: isDark ? color.shade100 : color.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
