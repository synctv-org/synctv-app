import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_responsive.dart';

class AppSelectableText extends StatelessWidget {
  final String data;
  final String? semanticLabel;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool monospace;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextScaler? textScaler;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final SelectionChangedCallback? onSelectionChanged;

  const AppSelectableText(
    this.data, {
    super.key,
    this.semanticLabel,
    this.style,
    this.maxLines,
    this.textAlign,
    this.monospace = false,
    this.autofocus = false,
    this.focusNode,
    this.textScaler,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = monospace && style?.fontFamily == null
        ? style?.copyWith(fontFamily: 'monospace') ??
              const TextStyle(fontFamily: 'monospace')
        : style;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 28),
      child: Semantics(
        label: semanticLabel ?? data,
        readOnly: true,
        child: ExcludeSemantics(
          child: SelectableText(
            data,
            style: effectiveStyle,
            maxLines: maxLines,
            textAlign: textAlign,
            autofocus: autofocus,
            focusNode: focusNode,
            textScaler: textScaler,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            onSelectionChanged: onSelectionChanged,
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final bool showLabel;
  final bool labelAbove;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final BorderSide? enabledBorderSide;
  final BorderSide? focusedBorderSide;
  final BorderSide? disabledBorderSide;
  final TextStyle? style;
  final GestureTapCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool showClearButton;
  final bool showVisibilityToggle;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? counterText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;
  final bool? selectAllOnFocus;
  final UndoHistoryController? undoController;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.showLabel = true,
    this.labelAbove = false,
    this.focusNode,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.filled = false,
    this.fillColor,
    this.contentPadding,
    this.borderRadius,
    this.enabledBorderSide,
    this.focusedBorderSide,
    this.disabledBorderSide,
    this.style,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.showClearButton = true,
    this.showVisibilityToggle = true,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.counterText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.smartDashesType,
    this.smartQuotesType,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.selectAllOnFocus,
    this.undoController,
    this.spellCheckConfiguration,
    this.contentInsertionConfiguration,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  FocusNode? _ownedFocusNode;
  bool _capsLockOn = false;
  bool _keyboardHandlerRegistered = false;

  bool get _enabled => widget.enabled && !widget.readOnly;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());
  bool get _showCapsLockWarning =>
      widget.obscureText && _effectiveFocusNode.hasFocus && _capsLockOn;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    widget.controller.addListener(_handleControllerChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);
    _syncKeyboardHandler();
    _updateCapsLockState();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      final previousFocusNode = oldWidget.focusNode ?? _ownedFocusNode!;
      previousFocusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) {
        previousFocusNode.dispose();
        _ownedFocusNode = null;
      }
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }
    if (oldWidget.obscureText != widget.obscureText && widget.obscureText) {
      _obscure = true;
    }
    _syncKeyboardHandler();
    _updateCapsLockState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    if (_keyboardHandlerRegistered) {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKeyEvent);
    }
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  void _handleFocusChanged() => _updateCapsLockState(forceRebuild: true);

  bool _handleHardwareKeyEvent(KeyEvent event) {
    _updateCapsLockState();
    return false;
  }

  void _syncKeyboardHandler() {
    if (widget.obscureText == _keyboardHandlerRegistered) return;
    if (widget.obscureText) {
      HardwareKeyboard.instance.addHandler(_handleHardwareKeyEvent);
    } else {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKeyEvent);
    }
    _keyboardHandlerRegistered = widget.obscureText;
  }

  void _updateCapsLockState({bool forceRebuild = false}) {
    final next = HardwareKeyboard.instance.lockModesEnabled.contains(
      KeyboardLockMode.capsLock,
    );
    if ((_capsLockOn == next && !forceRebuild) || !mounted) return;
    setState(() => _capsLockOn = next);
  }

  void _setText(String value) {
    final next = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
    setState(() => widget.controller.value = next);
    widget.onChanged?.call(value);
  }

  void _clear() {
    _setText('');
    _effectiveFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final maxLines = widget.obscureText ? 1 : widget.maxLines;
    final field = _buildNativeTextField(context, maxLines);
    if (!widget.showLabel || !widget.labelAbove) return field;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
        Semantics(label: widget.label, child: field),
      ],
    );
  }

  Widget _buildNativeTextField(BuildContext context, int? maxLines) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dense = AppMetrics.usesDenseLayout(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);
    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide:
          widget.enabledBorderSide ??
          BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide:
          widget.focusedBorderSide ??
          BorderSide(color: scheme.primary, width: 1.4),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide:
          widget.disabledBorderSide ??
          BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.35)),
    );
    final suffix = _hasSuffixActions
        ? Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _buildNativeSuffix(context),
          )
        : null;

    return TextFormField(
      controller: widget.controller,
      focusNode: _effectiveFocusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      obscureText: _obscure,
      enableInteractiveSelection: true,
      enableSuggestions: widget.obscureText ? false : widget.enableSuggestions,
      autocorrect: widget.obscureText ? false : widget.autocorrect,
      minLines: widget.obscureText ? null : widget.minLines,
      maxLines: maxLines,
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      // Default to an empty autofill hint list instead of null: a null list
      // selects the engine's autofill-disabled text input path, which on
      // mobile browsers dismisses the keyboard right after focus
      // (flutter/flutter#164071). An empty enabled configuration is inert on
      // every platform and keeps the soft keyboard open.
      autofillHints: widget.autofillHints ?? const <String>[],
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      validator: widget.validator,
      errorBuilder: (context, error) => _buildError(error),
      autovalidateMode: widget.autovalidateMode,
      selectAllOnFocus: widget.selectAllOnFocus,
      undoController: widget.undoController,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      style: widget.style ?? theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        isDense: dense,
        labelText: widget.showLabel && !widget.labelAbove ? widget.label : null,
        hintText: widget.hintText,
        helperText: _showCapsLockWarning ? null : widget.helperText,
        helper: _showCapsLockWarning
            ? _PasswordCapsLockHelper(helperText: widget.helperText)
            : null,
        error: widget.errorText == null ? null : _buildError(widget.errorText!),
        counterText: widget.counterText,
        filled: widget.filled || widget.fillColor != null,
        fillColor: widget.fillColor ?? scheme.surfaceContainerHighest,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: 18),
        suffixIcon: suffix,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 10 : 13),
        border: enabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        disabledBorder: disabledBorder,
        errorBorder: enabledBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: focusedBorder.copyWith(
          borderSide: BorderSide(color: scheme.error, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildError(String message) =>
      Text(message, softWrap: true, overflow: TextOverflow.visible);

  Widget _buildNativeSuffix(BuildContext context) {
    final actions = <Widget>[];
    if (widget.suffix != null) actions.add(widget.suffix!);
    if (widget.obscureText && widget.showVisibilityToggle) {
      actions.add(
        IconButton(
          tooltip: _obscure
              ? context.l10n.showPassword
              : context.l10n.hidePassword,
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18,
          ),
          onPressed: widget.enabled
              ? () => setState(() => _obscure = !_obscure)
              : null,
        ),
      );
    }
    if (_enabled &&
        widget.showClearButton &&
        widget.controller.text.isNotEmpty) {
      actions.add(
        IconButton(
          tooltip: context.l10n.clear,
          icon: const Icon(Icons.close_rounded, size: 18),
          onPressed: _clear,
        ),
      );
    }
    return ExcludeFocus(
      child: Row(mainAxisSize: MainAxisSize.min, children: actions),
    );
  }

  bool get _hasSuffixActions {
    return widget.suffix != null ||
        (widget.obscureText && widget.showVisibilityToggle) ||
        (_enabled &&
            widget.showClearButton &&
            widget.controller.text.isNotEmpty);
  }
}

class _PasswordCapsLockHelper extends StatelessWidget {
  const _PasswordCapsLockHelper({this.helperText});

  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final warningColor = Theme.of(context).colorScheme.tertiary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (helperText != null) Text(helperText!),
        Semantics(
          liveRegion: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_capslock_rounded,
                size: 14,
                color: warningColor,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  context.l10n.capsLockOn,
                  style: TextStyle(color: warningColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppReadOnlyField extends StatefulWidget {
  final String label;
  final String value;
  final IconData? prefixIcon;
  final int? maxLines;
  final bool labelAbove;

  const AppReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    this.prefixIcon,
    this.maxLines = 1,
    this.labelAbove = false,
  });

  @override
  State<AppReadOnlyField> createState() => _AppReadOnlyFieldState();
}

class _AppReadOnlyFieldState extends State<AppReadOnlyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant AppReadOnlyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _controller,
      label: widget.label,
      labelAbove: widget.labelAbove,
      prefixIcon: widget.prefixIcon,
      readOnly: true,
      showClearButton: false,
      enableSuggestions: false,
      autocorrect: false,
      maxLines: widget.maxLines,
    );
  }
}

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final double? width;
  final IconData icon;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.width,
    this.icon = Icons.search_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final field = AppTextField(
      controller: controller,
      label: hintText,
      showLabel: false,
      hintText: hintText,
      prefixIcon: icon,
      enabled: enabled,
      showClearButton: true,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: (value) => onSubmitted(value.trim()),
    );
    if (width == null) return field;
    return SizedBox(width: width, child: field);
  }
}

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final SemanticFormatterCallback? semanticFormatterCallback;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.semanticFormatterCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      semanticFormatterCallback: semanticFormatterCallback,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
    );
  }
}

class AppSegmentedControl<T> extends StatelessWidget {
  final T value;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onChanged;
  final ButtonStyle? style;
  final bool showSelectedIcon;
  final Axis direction;

  const AppSegmentedControl({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.style,
    this.showSelectedIcon = false,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      direction: direction,
      style: style,
      segments: segments,
      selected: {value},
      showSelectedIcon: showSelectedIcon,
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final String? errorText;
  final String? semanticsLabel;
  final bool enabled;
  final bool leadingLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.errorText,
    this.semanticsLabel,
    this.enabled = true,
    this.leadingLabel = false,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onChanged != null;
    final control = Switch(
      value: value,
      onChanged: effectiveEnabled ? onChanged : null,
      focusNode: focusNode,
      autofocus: autofocus,
    );
    final labelWidget = label == null
        ? control
        : Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: leadingLabel ? TextDirection.rtl : null,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label!),
                    if (description != null)
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (errorText != null)
                      Text(
                        errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              control,
            ],
          );
    return MergeSemantics(
      child: Semantics(
        label: label == null
            ? semanticsLabel ?? context.l10n.switchControl
            : semanticsLabel,
        child: label == null
            ? labelWidget
            : InkWell(
                canRequestFocus: false,
                excludeFromSemantics: true,
                onTap: effectiveEnabled ? () => onChanged?.call(!value) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: labelWidget,
                ),
              ),
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  final bool value;
  final Color? activeColor;
  final OutlinedBorder? shape;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? description;
  final String? errorText;
  final String? semanticsLabel;
  final bool enabled;
  final bool leadingLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.shape,
    this.label,
    this.description,
    this.errorText,
    this.semanticsLabel,
    this.enabled = true,
    this.leadingLabel = false,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveEnabled = enabled && onChanged != null;
    final control = Checkbox(
      value: value,
      activeColor: activeColor,
      shape: shape,
      semanticLabel: semanticsLabel,
      onChanged: effectiveEnabled
          ? (next) {
              if (next != null) onChanged?.call(next);
            }
          : null,
      focusNode: focusNode,
      autofocus: autofocus,
    );
    if (label == null) {
      return control;
    }
    final labelWidget = Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: leadingLabel ? TextDirection.rtl : null,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label!),
              if (description != null)
                Text(
                  description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (errorText != null)
                Text(
                  errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        control,
      ],
    );
    return MergeSemantics(
      child: InkWell(
        canRequestFocus: false,
        excludeFromSemantics: true,
        onTap: effectiveEnabled ? () => onChanged?.call(!value) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: labelWidget,
        ),
      ),
    );
  }
}
