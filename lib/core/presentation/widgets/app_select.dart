import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_buttons.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';

import 'dart:math' as math;

class _AppSelectFormField<T> extends FormField<T> {
  const _AppSelectFormField({
    required super.builder,
    super.initialValue,
    super.validator,
    super.autovalidateMode,
    super.onSaved,
    super.enabled,
    required this.onChanged,
    required this.acceptsValue,
  });

  final ValueChanged<T?> onChanged;
  final bool Function(T?) acceptsValue;

  @override
  FormFieldState<T> createState() => _AppSelectFormFieldState<T>();
}

class _AppSelectFormFieldState<T> extends FormFieldState<T> {
  bool focused = false;
  final dropdownFocusNode = FocusNode();

  void activateDropdown(FocusNode node) {
    if (!mounted || !widget.enabled) return;
    final context = node.context;
    if (context != null && context.mounted) {
      Actions.maybeInvoke(context, const ActivateIntent());
    }
  }

  @override
  void dispose() {
    dropdownFocusNode.dispose();
    super.dispose();
  }

  void changeFromUser(T? value) {
    if (!mounted) return;
    final field = widget as _AppSelectFormField<T>;
    if (!field.enabled || !field.acceptsValue(value)) return;
    didChange(value);
  }

  void setFocused(bool value) {
    if (mounted && value != focused) setState(() => focused = value);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    (widget as _AppSelectFormField<T>).onChanged(value);
  }

  @override
  void didUpdateWidget(covariant _AppSelectFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }

  @override
  void reset() {
    super.reset();
    (widget as _AppSelectFormField<T>).onChanged(value);
  }
}

class _AppSelectMenuSelection extends StatefulWidget {
  const _AppSelectMenuSelection({required this.child});

  final Widget child;

  @override
  State<_AppSelectMenuSelection> createState() =>
      _AppSelectMenuSelectionState();
}

class _AppSelectMenuSelectionState extends State<_AppSelectMenuSelection> {
  @override
  void initState() {
    super.initState();
    // Reveal after the eager menu has measured its multiline option heights.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      Scrollable.ensureVisible(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class AppSelect<T> extends StatelessWidget {
  final T? value;
  final Map<String, T> options;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final bool labelAbove;
  final bool wrapText;
  final bool useAnchoredMenu;
  final String? hintText;
  final String? description;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget Function(BuildContext context, T value)? optionPrefixBuilder;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode autovalidateMode;
  final bool enabled;
  final bool clearable;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextAlign textAlign;
  final double? width;
  final bool? compact;

  const AppSelect({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.label,
    this.labelAbove = false,
    this.wrapText = false,
    this.useAnchoredMenu = false,
    this.hintText,
    this.description,
    this.errorText,
    this.prefixIcon,
    this.optionPrefixBuilder,
    this.onSaved,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUnfocus,
    this.enabled = true,
    this.clearable = false,
    this.focusNode,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.width,
    this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null && options.isNotEmpty;
    Widget field = _AppSelectFormField<T>(
      initialValue: options.values.contains(value) ? value : null,
      enabled: enabled && onChanged != null,
      acceptsValue: (next) => next == null
          ? clearable || options.values.contains(null)
          : options.values.contains(next),
      onChanged: _handleChange,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onSaved: onSaved,
      builder: (formState) {
        final state = formState as _AppSelectFormFieldState<T>;
        final effectiveFocusNode = focusNode ?? state.dropdownFocusNode;
        return Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: state.setFocused,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTap: interactive
                ? () => state.activateDropdown(effectiveFocusNode)
                : null,
            child: InputDecorator(
              isFocused: state.focused,
              isEmpty: !options.values.contains(state.value),
              decoration: InputDecoration(
                enabled: interactive,
                labelText: labelAbove ? null : label,
                helper: description == null ? null : Text(description!),
                errorText: state.errorText ?? errorText,
                prefixIcon: prefixIcon == null
                    ? null
                    : Icon(prefixIcon, size: 18),
                suffixIcon:
                    clearable && value != null && enabled && onChanged != null
                    ? AppIconButton(
                        tooltip: context.l10n.clear,
                        icon: Icons.clear_rounded,
                        onPressed: () {
                          state.changeFromUser(null);
                        },
                      )
                    : null,
              ),
              child: Semantics(
                excludeSemantics: !interactive,
                button: interactive ? null : true,
                enabled: interactive ? null : false,
                label: interactive
                    ? null
                    : options.entries
                              .where((entry) => entry.value == state.value)
                              .firstOrNull
                              ?.key ??
                          hintText ??
                          context.l10n.selectOption,
                child: useAnchoredMenu
                    ? _anchoredMenu(
                        context,
                        state,
                        effectiveFocusNode,
                        interactive,
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<T>(
                          value: state.value,
                          onChanged: interactive ? state.changeFromUser : null,
                          hint: Text(hintText ?? context.l10n.selectOption),
                          focusNode: effectiveFocusNode,
                          autofocus: autofocus,
                          isExpanded: true,
                          isDense: !wrapText,
                          itemHeight: null,
                          alignment: textAlign == TextAlign.end
                              ? AlignmentDirectional.centerEnd
                              : AlignmentDirectional.centerStart,
                          items: [
                            for (final entry in options.entries)
                              DropdownMenuItem<T>(
                                value: entry.value,
                                child: _option(context, entry),
                              ),
                          ],
                          selectedItemBuilder: (context) => [
                            for (final entry in options.entries)
                              Semantics(
                                button: true,
                                enabled:
                                    enabled &&
                                    onChanged != null &&
                                    options.isNotEmpty,
                                child: Text(
                                  entry.key,
                                  textAlign: textAlign,
                                  overflow: wrapText
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );

    if (labelAbove && label != null) {
      field = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                label!,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          Semantics(label: label, child: field),
        ],
      );
    }

    final effectiveWidth = width ?? _defaultWidth(context);
    if (effectiveWidth == null) return field;
    return SizedBox(width: effectiveWidth, child: field);
  }

  void _handleChange(T? next) {
    final callback = onChanged;
    if (callback == null) return;
    if (next != null) {
      callback(next);
      return;
    }
    if (clearable || options.values.any((value) => value == null)) {
      callback(next);
    }
  }

  Widget _option(BuildContext context, MapEntry<String, T> entry) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (optionPrefixBuilder != null) ...[
          optionPrefixBuilder!(context, entry.value),
          const SizedBox(width: 8),
        ],
        Flexible(child: Text(entry.key, textAlign: textAlign)),
      ],
    );
  }

  Widget _anchoredMenu(
    BuildContext context,
    _AppSelectFormFieldState<T> state,
    FocusNode node,
    bool interactive,
  ) => LayoutBuilder(
    builder: (context, constraints) {
      final selected = options.entries
          .where((entry) => entry.value == state.value)
          .firstOrNull;
      return MenuAnchor(
        childFocusNode: node,
        crossAxisUnconstrained: false,
        consumeOutsideTap: true,
        style: MenuStyle(
          maximumSize: WidgetStatePropertyAll(
            Size(constraints.maxWidth, double.infinity),
          ),
        ),
        menuChildren: [
          for (final entry in options.entries)
            SizedBox(
              width: constraints.maxWidth,
              child: MergeSemantics(
                child: Semantics(
                  selected: entry.value == state.value,
                  child: MenuItemButton(
                    autofocus: entry.value == state.value,
                    trailingIcon: entry.value == state.value
                        ? const Icon(Icons.check_rounded, size: 18)
                        : null,
                    onPressed: interactive
                        ? () => state.changeFromUser(entry.value)
                        : null,
                    child: entry.value == state.value
                        ? _AppSelectMenuSelection(
                            child: _option(context, entry),
                          )
                        : _option(context, entry),
                  ),
                ),
              ),
            ),
        ],
        builder: (context, controller, _) => MergeSemantics(
          child: Semantics(
            expanded: controller.isOpen,
            child: TextButton(
              focusNode: node,
              autofocus: autofocus,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                textStyle: Theme.of(context).textTheme.titleMedium,
                alignment: AlignmentDirectional.centerStart,
              ),
              onPressed: !interactive
                  ? null
                  : () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selected?.key ?? hintText ?? context.l10n.selectOption,
                      textAlign: textAlign,
                      overflow: wrapText
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      maxLines: wrapText ? null : 1,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  double? _defaultWidth(BuildContext context) {
    if (compact == false) return null;
    if (label != null || description != null || errorText != null) {
      return null;
    }
    if (options.isEmpty) return null;

    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final painter = TextPainter(
      textDirection: direction,
      textScaler: textScaler,
      maxLines: 1,
    );
    var textWidth = 0.0;
    try {
      for (final label in [...options.keys, ?hintText]) {
        painter.text = TextSpan(
          text: label,
          style: theme.textTheme.titleMedium,
        );
        painter.layout();
        textWidth = math.max(textWidth, painter.width);
      }
    } finally {
      painter.dispose();
    }

    // Include the decorated dropdown's arrow, gaps and leading inset.
    final decoration = theme.inputDecorationTheme;
    final padding = decoration.contentPadding?.resolve(direction);
    final leadingPadding = direction == TextDirection.ltr
        ? padding?.left ?? 12.0
        : padding?.right ?? 12.0;
    final leadingWidth = prefixIcon == null
        ? leadingPadding + 4.0
        : (decoration.prefixIconConstraints?.minWidth ?? 48.0) + 4.0;
    final chromeWidth = leadingWidth + 40.0;
    final width = (textWidth + chromeWidth).ceilToDouble();
    final dense = AppMetrics.usesDenseLayout(context);
    final minWidth = dense ? 86.0 : 96.0;
    final maxWidth = math.max(
      minWidth,
      math.min(
        textScaler.scale(dense ? 240.0 : 280.0),
        MediaQuery.sizeOf(context).width - 32.0,
      ),
    );
    return width.clamp(minWidth, maxWidth).toDouble();
  }
}
