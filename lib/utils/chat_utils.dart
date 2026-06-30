import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

/// 聊天相关的工具类，提供复用功能
class ChatUtils {
  /// 显示自定义的Snackbar（统一调用MessageUtils）
  static void showCustomSnackbar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    // 使用统一的MessageUtils来显示消息
    MessageUtils.showInfo(
      context,
      message,
      duration: duration ?? const Duration(seconds: 2),
    );
  }

  /// 滚动到底部
  static void scrollToBottom(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 创建唯一的图片文件
  static Future<String> createUniqueImageFile(
    String conversationId,
    File sourceImage,
  ) async {
    // 获取应用的文档目录
    final appDir = await getApplicationDocumentsDirectory();
    final conversationDir = Directory(
      '${appDir.path}/conversations/$conversationId/images',
    );
    await conversationDir.create(recursive: true);

    // 生成唯一的文件名
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = sourceImage.path.split('.').last;
    final fileName = 'image_$timestamp.$extension';
    final localPath = '${conversationDir.path}/$fileName';

    // 复制图片到永久存储
    await sourceImage.copy(localPath);

    return localPath;
  }

  /// 显示图片选择器选项
  static void showImagePickerOptions(
    BuildContext context,
    VoidCallback onGallerySelected,
    VoidCallback onCameraSelected,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showAppBottomSheet<void>(
      context: context,
      builder: (context) {
        return AppBottomSheetFrame(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          includeKeyboardInset: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 从相册选择选项
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppPanelSurface(
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.06,
                      ),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  child: AppTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    prefix: AppIconBadge(
                      icon: Icons.photo_library,
                      color: isDark
                          ? Colors.blue.shade300
                          : Colors.blue.shade600,
                      backgroundColor: isDark
                          ? Colors.blue.shade900.withValues(alpha: 0.3)
                          : Colors.blue.shade50,
                      size: 40,
                      iconSize: 24,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    title: Text(
                      '从相册选择',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    subtitle: Text(
                      '选择已有照片',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onGallerySelected();
                    },
                  ),
                ),
              ),

              // 拍照选项
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppPanelSurface(
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.06,
                      ),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  child: AppTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    prefix: AppIconBadge(
                      icon: Icons.camera_alt,
                      color: isDark
                          ? Colors.green.shade300
                          : Colors.green.shade600,
                      backgroundColor: isDark
                          ? Colors.green.shade900.withValues(alpha: 0.3)
                          : Colors.green.shade50,
                      size: 40,
                      iconSize: 24,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    title: Text(
                      '拍照',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    subtitle: Text(
                      '拍摄新照片',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCameraSelected();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 创建一个统一风格的对话框，使用与编辑消息相同的设计风格
  static Future<T?> showStyledDialog<T>({
    required BuildContext context,
    required String title,
    required Icon icon,
    required Widget content,
    required List<Widget> actions,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final accent = iconColor ?? theme.colorScheme.primary;

    return showAppDialog<T>(
      context: context,
      builder: (context) {
        return AppDialogFrame(
          maxWidth: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeaderBar(
                title: title,
                icon: icon.icon ?? Icons.info_outline_rounded,
                color: accent,
                onClose: () => Navigator.of(context).pop(),
              ),
              Flexible(
                child: AppSingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                  child: Align(alignment: Alignment.centerLeft, child: content),
                ),
              ),
              _DialogActionBar(actions: actions, topBorder: true),
            ],
          ),
        );
      },
    );
  }

  /// 创建标准取消按钮
  static Widget createCancelButton(BuildContext context) {
    return AppActionButton(
      onPressed: () => Navigator.pop(context),
      label: '取消',
      style: AppActionButtonStyle.outlined,
    );
  }

  /// 创建标准确认按钮
  static Widget createConfirmButton(
    BuildContext context,
    VoidCallback onTap, {
    String text = '确定',
  }) {
    return AppActionButton(onPressed: onTap, label: text);
  }

  /// 显示温度调整对话框 (使用新的统一风格)
  static void showTemperatureDialog(
    BuildContext context,
    double initialTemperature,
    Function(double) onTemperatureChanged,
  ) {
    double newTemperature = initialTemperature;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showStyledDialog(
      context: context,
      title: '调整温度',
      icon: const Icon(Icons.thermostat_outlined),
      iconColor: isDark ? Colors.amber.shade300 : Colors.amber.shade600,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '当前温度: ${newTemperature.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '较低的温度会使回答更加确定、精确和集中，较高的温度使回答更加多样化和创造性。',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '注意：此设置仅对当前对话生效',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                AppPanelSurface(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      AppSlider(
                        value: newTemperature,
                        min: 0.0,
                        max: 2.0,
                        divisions: 20,
                        label: newTemperature.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            newTemperature = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '精确 (0.0)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '平衡 (1.0)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            '创意 (2.0)',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        createCancelButton(context),
        const SizedBox(width: 8),
        createConfirmButton(context, () {
          Navigator.of(context).pop();
          onTemperatureChanged(newTemperature);
        }),
      ],
    );
  }

  /// 显示最大Token调整对话框 (使用新的统一风格)
  static void showMaxTokensDialog(
    BuildContext context,
    int initialMaxTokens,
    Function(int) onMaxTokensChanged,
  ) {
    int newMaxTokens = initialMaxTokens;
    final TextEditingController controller = TextEditingController(
      text: newMaxTokens.toString(),
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showStyledDialog(
      context: context,
      title: '调整最大Tokens',
      icon: const Icon(Icons.data_usage_rounded),
      iconColor: isDark ? Colors.green.shade300 : Colors.green.shade600,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前值: $newMaxTokens',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '较大的值允许生成更长的回答，但会消耗更多的API额度。',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '注意：此设置仅对当前对话生效',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: controller,
            label: '最大 Token 数',
            hintText: '输入最大Token数',
            prefixIcon: Icons.data_usage_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
            fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            onChanged: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null) newMaxTokens = parsed;
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMaxTokenQuickButton(1000, controller),
              _buildMaxTokenQuickButton(2000, controller),
              _buildMaxTokenQuickButton(4000, controller),
              _buildMaxTokenQuickButton(8000, controller),
            ],
          ),
        ],
      ),
      actions: [
        createCancelButton(context),
        const SizedBox(width: 8),
        createConfirmButton(context, () {
          try {
            newMaxTokens = int.parse(controller.text);

            // 确保值合理
            if (newMaxTokens < 100) newMaxTokens = 100;
            if (newMaxTokens > 128000) newMaxTokens = 128000;

            Navigator.of(context).pop();
            onMaxTokensChanged(newMaxTokens);
          } catch (e) {
            showCustomSnackbar(context, '请输入有效的数字');
          }
        }),
      ],
    );
  }

  /// 最大Token快速选择按钮
  static Widget _buildMaxTokenQuickButton(
    int value,
    TextEditingController controller,
  ) {
    return AppActionButton(
      onPressed: () {
        controller.text = value.toString();
      },
      label: '$value',
      size: AppActionButtonSize.sm,
      style: AppActionButtonStyle.tonal,
    );
  }

  /// 显示提示词编辑对话框 (使用新的统一风格)
  static void showPromptDialog(
    BuildContext context,
    String initialPrompt,
    Function(String) onPromptChanged,
  ) {
    final TextEditingController promptController = TextEditingController(
      text: initialPrompt,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 从SharedPreferences获取已保存的姓名和时区
    String userName = '小丑';
    String timezone = '上海';

    // 用户自定义变量列表
    List<Map<String, dynamic>> customVariables = [];

    SharedPreferences.getInstance().then((prefs) {
      userName = prefs.getString('prompt_variable_name') ?? '小丑';
      timezone = prefs.getString('prompt_variable_timezone') ?? '上海';

      // 获取已保存的自定义变量
      final customVarsJson = prefs.getString('prompt_custom_variables');
      if (customVarsJson != null && customVarsJson.isNotEmpty) {
        try {
          final List decoded = jsonDecode(customVarsJson);
          customVariables = decoded
              .map(
                (item) => {
                  'name': item['name'] ?? '',
                  'value': item['value'] ?? '',
                },
              )
              .toList();
        } catch (e) {
          debugPrint('读取自定义变量失败: $e');
        }
      }
    });

    // 文本控制器光标位置
    TextSelection? currentSelection;

    showStyledDialog(
      context: context,
      title: initialPrompt.isEmpty ? '添加系统提示词' : '编辑系统提示词',
      icon: const Icon(Icons.psychology_outlined),
      iconColor: isDark ? Colors.purple.shade300 : Colors.purple.shade600,
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '系统提示词可以定义AI助手的角色和行为方式，例如"你是一名专业的程序员"或"请用简洁的方式回答问题"。',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '注意：此设置仅对当前对话生效',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: promptController,
              label: '系统提示词',
              hintText: '输入系统提示词...',
              prefixIcon: Icons.psychology_outlined,
              minLines: 4,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
              onChanged: (text) {
                currentSelection = promptController.selection;
              },
            ),
            const SizedBox(height: 16),

            // 变量标签头部
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tune,
                      size: 14,
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '动态变量',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.grey.shade500
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                // 添加自定义变量按钮
                AppInkSurface(
                  onTap: () async {
                    final newVar = await _showAddCustomVariableDialog(context);
                    if (newVar != null) {
                      customVariables.add(newVar);

                      // 保存自定义变量到SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'prompt_custom_variables',
                        jsonEncode(customVariables),
                      );
                      setState(() {});
                    }
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 12,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '添加变量',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 变量按钮组
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // 日期变量
                _buildVariableChip(
                  context: context,
                  label: '日期',
                  variable: '{date}',
                  isEditable: false,
                  onTap: () {
                    _insertTextAtCursor(
                      promptController,
                      '{date}',
                      currentSelection,
                    );
                    currentSelection = promptController.selection;
                    setState(() {});
                  },
                ),

                // 姓名变量
                _buildVariableChip(
                  context: context,
                  label: '姓名: $userName',
                  variable: '{name}',
                  onTap: () {
                    _insertTextAtCursor(
                      promptController,
                      '{name}',
                      currentSelection,
                    );
                    currentSelection = promptController.selection;
                    setState(() {});
                  },
                  onLongPress: () async {
                    // 编辑姓名
                    final newName = await _showVariableEditDialog(
                      context,
                      '编辑姓名',
                      '请输入你的姓名',
                      userName,
                    );

                    if (newName != null && newName.trim().isNotEmpty) {
                      userName = newName.trim();
                      // 保存到SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('prompt_variable_name', userName);
                      setState(() {});
                    }
                  },
                ),

                // 时区变量
                _buildVariableChip(
                  context: context,
                  label: '时区: $timezone',
                  variable: '{timezone}',
                  onTap: () {
                    _insertTextAtCursor(
                      promptController,
                      '{timezone}',
                      currentSelection,
                    );
                    currentSelection = promptController.selection;
                    setState(() {});
                  },
                  onLongPress: () async {
                    // 编辑时区
                    final newTimezone = await _showVariableEditDialog(
                      context,
                      '编辑时区',
                      '请输入你的时区',
                      timezone,
                    );

                    if (newTimezone != null && newTimezone.trim().isNotEmpty) {
                      timezone = newTimezone.trim();
                      // 保存到SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'prompt_variable_timezone',
                        timezone,
                      );
                      setState(() {});
                    }
                  },
                ),

                // 自定义变量
                ...customVariables.map((variable) {
                  return _buildVariableChip(
                    context: context,
                    label: '${variable['name']}: ${variable['value']}',
                    variable: '{${variable['name']}}',
                    onTap: () {
                      _insertTextAtCursor(
                        promptController,
                        '{${variable['name']}}',
                        currentSelection,
                      );
                      currentSelection = promptController.selection;
                      setState(() {});
                    },
                    onLongPress: () async {
                      // 编辑变量
                      final newValue = await _showVariableEditDialog(
                        context,
                        '编辑 ${variable['name']}',
                        '请输入 ${variable['name']} 的值',
                        variable['value'].toString(),
                      );

                      if (newValue != null) {
                        // 更新变量值
                        final index = customVariables.indexOf(variable);
                        if (index != -1) {
                          customVariables[index]['value'] = newValue;

                          // 保存到SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                            'prompt_custom_variables',
                            jsonEncode(customVariables),
                          );

                          setState(() {});
                        }
                      }
                    },
                    onDelete: () async {
                      // 删除变量
                      customVariables.remove(variable);

                      // 保存到SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'prompt_custom_variables',
                        jsonEncode(customVariables),
                      );

                      setState(() {});
                    },
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
      actions: [
        createCancelButton(context),
        const SizedBox(width: 8),
        createConfirmButton(context, () {
          final newPrompt = promptController.text.trim();
          Navigator.of(context).pop();
          onPromptChanged(newPrompt);
        }, text: '保存'),
      ],
    );
  }

  /// 显示配置对话框，使用与showStyledDialog相同的风格但支持表单字段
  static Future<T?> showConfigDialog<T>({
    required BuildContext context,
    required String title,
    required Icon icon,
    required List<Widget> formFields,
    required VoidCallback onSave,
    String saveButtonText = '保存',
    Color? iconColor,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    final accent = iconColor ?? theme.colorScheme.primary;

    return showAppDialog<T>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) {
        return AppDialogFrame(
          maxWidth: 620,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeaderBar(
                title: title,
                icon: icon.icon ?? Icons.tune_rounded,
                color: accent,
                onClose: isLoading ? null : () => Navigator.of(context).pop(),
              ),
              Flexible(
                child: AppSingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: formFields,
                  ),
                ),
              ),
              _DialogActionBar(
                topBorder: true,
                actions: [
                  if (!isLoading) createCancelButton(context),
                  AppActionButton(
                    onPressed: onSave,
                    loading: isLoading,
                    icon: Icons.check_rounded,
                    label: isLoading ? '处理中' : saveButtonText,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 创建配置表单字段，使用统一的样式
  static Widget createFormField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    String? helperText,
    bool enabled = true,
    IconData? prefixIcon,
    Widget? suffix,
    int? maxLines = 1,
    TextInputType? keyboardType,
    bool enableSuggestions = true,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    void Function(String)? onSubmitted,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      helperText: helperText,
      obscureText: obscureText,
      enabled: enabled,
      prefixIcon: prefixIcon,
      suffix: suffix,
      maxLines: maxLines,
      keyboardType: keyboardType,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      onSubmitted: onSubmitted,
    );
  }

  // 构建变量芯片
  static Widget _buildVariableChip({
    required BuildContext context,
    required String label,
    required String variable,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDelete,
    bool isEditable = true,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 可编辑变量使用蓝色，不可编辑变量使用灰色
    final Color bgColor = isEditable
        ? (isDark ? Colors.blueGrey.shade800 : Colors.blue.shade50)
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade200);

    final Color textColor = isEditable
        ? (isDark ? Colors.blue.shade200 : Colors.blue.shade700)
        : (isDark ? Colors.grey.shade400 : Colors.grey.shade700);

    return AppInkSurface(
      onTap: onTap,
      onLongPress: isEditable ? onLongPress : null,
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: AppBadge(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (onDelete != null) ...[
              const SizedBox(width: 6),
              AppIconButton(
                tooltip: '删除变量',
                icon: Icons.close_rounded,
                onPressed: onDelete,
                size: AppIconButtonSize.sm,
                iconSize: 14,
                constraints: const BoxConstraints.tightFor(
                  width: 18,
                  height: 18,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
        color: textColor,
        backgroundColor: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }

  // 在光标位置插入文本
  static void _insertTextAtCursor(
    TextEditingController controller,
    String text,
    TextSelection? currentSelection,
  ) {
    final selection = currentSelection ?? controller.selection;
    final beforeText = controller.text.substring(0, selection.start);
    final afterText = controller.text.substring(selection.end);

    final newText = beforeText + text + afterText;
    controller.text = newText;

    // 设置新的光标位置在插入的文本后面
    controller.selection = TextSelection.collapsed(
      offset: beforeText.length + text.length,
    );
  }

  // 显示变量编辑对话框
  static Future<String?> _showVariableEditDialog(
    BuildContext context,
    String title,
    String hint,
    String initialValue,
  ) async {
    final controller = TextEditingController(text: initialValue);

    return showStyledDialog<String>(
      context: context,
      title: title,
      icon: const Icon(Icons.edit),
      iconColor: Colors.orange,
      content: createFormField(
        context: context,
        label: '',
        controller: controller,
        hintText: hint,
        prefixIcon: Icons.edit_outlined,
      ),
      actions: [
        createCancelButton(context),
        const SizedBox(width: 8),
        createConfirmButton(context, () {
          Navigator.of(context).pop(controller.text);
        }),
      ],
    );
  }

  // 显示添加自定义变量对话框
  static Future<Map<String, String>?> _showAddCustomVariableDialog(
    BuildContext context,
  ) async {
    final nameController = TextEditingController();
    final valueController = TextEditingController();

    return showStyledDialog<Map<String, String>>(
      context: context,
      title: '添加自定义变量',
      icon: const Icon(Icons.add_circle_outline),
      iconColor: Colors.green,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          createFormField(
            context: context,
            label: '变量名称',
            controller: nameController,
            hintText: '例如：company',
            prefixIcon: Icons.label_outline,
          ),
          const SizedBox(height: 16),
          createFormField(
            context: context,
            label: '变量值',
            controller: valueController,
            hintText: '例如：Google',
            prefixIcon: Icons.text_fields,
          ),
        ],
      ),
      actions: [
        createCancelButton(context),
        const SizedBox(width: 8),
        createConfirmButton(context, () {
          final name = nameController.text.trim();
          final value = valueController.text.trim();

          if (name.isNotEmpty && value.isNotEmpty) {
            Navigator.of(context).pop({'name': name, 'value': value});
          } else {
            // 显示错误提示
            showCustomSnackbar(context, '变量名和值不能为空');
          }
        }),
      ],
    );
  }
}

class _DialogHeaderBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onClose;

  const _DialogHeaderBar({
    required this.title,
    required this.icon,
    required this.color,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.38),
      borderRadius: BorderRadius.zero,
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
            color: color,
            iconColor: Colors.white,
            backgroundColor: color,
            size: 42,
            iconSize: 22,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          AppIconButton(
            tooltip: '关闭',
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _DialogActionBar extends StatelessWidget {
  final List<Widget> actions;
  final bool topBorder;

  const _DialogActionBar({required this.actions, this.topBorder = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      color: Colors.transparent,
      borderRadius: BorderRadius.zero,
      border: topBorder
          ? Border(
              top: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.55),
              ),
            )
          : null,
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(spacing: 10, runSpacing: 8, children: actions),
      ),
    );
  }
}
