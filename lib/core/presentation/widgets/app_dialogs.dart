import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_buttons.dart';
import 'package:synctv_app/core/presentation/widgets/app_lists_misc.dart';
import 'package:synctv_app/core/presentation/widgets/app_surfaces.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Widget content;
  final String? cancelLabel;
  final String? confirmLabel;
  final IconData? confirmIcon;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final bool destructive;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.cancelLabel,
    this.confirmLabel,
    this.confirmIcon,
    this.onCancel,
    this.onConfirm,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon,
      title: Text(title),
      scrollable: true,
      insetPadding: AppMetrics.dialogInsetPadding(context),
      constraints: BoxConstraints(
        maxHeight: AppMetrics.dialogMaxHeight(context, null),
      ),
      content: content,
      actions: _actions(context),
    );
  }

  List<Widget> _actions(BuildContext context) => [
    AppActionButton(
      onPressed: onConfirm,
      icon: confirmIcon,
      label: confirmLabel ?? context.l10n.confirm,
      style: destructive
          ? AppActionButtonStyle.destructive
          : AppActionButtonStyle.filled,
    ),
    AppActionButton(
      onPressed: onCancel ?? () => Navigator.pop(context, false),
      label: cancelLabel ?? context.l10n.cancel,
      style: AppActionButtonStyle.outlined,
    ),
  ];
}

class AppDialog extends StatelessWidget {
  final Widget? title;
  final Widget? body;
  final List<Widget> actions;
  final Widget? icon;
  final BoxConstraints constraints;

  const AppDialog({
    super.key,
    this.title,
    this.body,
    required this.actions,
    this.icon,
    this.constraints = const BoxConstraints(minWidth: 280, maxWidth: 560),
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = AppMetrics.dialogMaxHeight(
      context,
      constraints.hasBoundedHeight ? constraints.maxHeight : null,
    );
    return AlertDialog(
      icon: icon,
      title: title,
      scrollable: true,
      insetPadding: AppMetrics.dialogInsetPadding(context),
      constraints: BoxConstraints(maxHeight: maxHeight),
      content: body == null
          ? null
          : ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.minWidth,
                maxWidth: constraints.maxWidth,
              ),
              child: body,
            ),
      actions: actions,
    );
  }
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.55),
    builder: builder,
  );
}

class AppDialogFrame extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double? maxHeight;
  final EdgeInsets? insetPadding;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final Clip clipBehavior;
  final bool allowWide;

  const AppDialogFrame({
    super.key,
    required this.child,
    this.maxWidth = 560,
    this.maxHeight,
    this.insetPadding,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.clipBehavior = Clip.antiAlias,
    this.allowWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetPadding ?? AppMetrics.dialogInsetPadding(context),
      clipBehavior: clipBehavior,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppMetrics.dialogMaxWidth(
            context,
            maxWidth,
            allowWide: allowWide,
          ),
          maxHeight: AppMetrics.dialogMaxHeight(context, maxHeight),
        ),
        child: child,
      ),
    );
  }
}

class AppDialogHeader extends StatelessWidget {
  final Widget title;
  final IconData icon;
  final Color? color;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry padding;
  final double iconBoxSize;
  final double iconSize;

  const AppDialogHeader({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.onClose,
    this.padding = const EdgeInsets.fromLTRB(22, 16, 16, 14),
    this.iconBoxSize = 40,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return AppPanelSurface(
      width: double.infinity,
      color: effectiveColor.withValues(alpha: 0.12),
      borderRadius: BorderRadius.zero,
      padding: padding,
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
            color: effectiveColor,
            size: iconBoxSize,
            iconSize: iconSize,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            backgroundAlpha: 0.16,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DefaultTextStyle.merge(
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              child: title,
            ),
          ),
          if (onClose != null)
            AppIconButton(
              tooltip: context.l10n.close,
              onPressed: onClose,
              icon: Icons.close_rounded,
            ),
        ],
      ),
    );
  }
}

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? barrierColor,
  Color? backgroundColor,
  BoxConstraints? constraints,
  ShapeBorder? shape,
  Clip? clipBehavior,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.5),
    constraints: constraints,
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
    shape:
        shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
    clipBehavior: clipBehavior,
    builder: builder,
  );
}

class AppBottomSheetFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool includeKeyboardInset;

  const AppBottomSheetFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    this.includeKeyboardInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final resolved = padding.resolve(Directionality.of(context));
    return SafeArea(
      child: Padding(
        padding: resolved.copyWith(
          bottom:
              resolved.bottom + (includeKeyboardInset ? viewInsets.bottom : 0),
        ),
        child: child,
      ),
    );
  }
}
