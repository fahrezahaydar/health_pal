import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app_form.dart';
import 'app_input_field.dart';

// -----------------------------------------------------------------------------
// APP TEXT FORM FIELD
// -----------------------------------------------------------------------------
/// Wrapper AppInputField + AppFormField.
///
/// Sudah:
/// - auto register ke AppForm
/// - auto validate
/// - auto save/reset
/// - support initial value
/// - support autovalidate
/// - reusable
///
/// NOTE:
/// Widget ini khusus String/Text.
/// Untuk custom value gunakan generic AppFormField<T>.
class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.name,

    // value
    this.controller,
    this.initialValue,

    // ui
    this.hintText,
    this.prefix,
    this.suffix,

    // behavior
    this.isPassword = false,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.isShowError = true,

    // input
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.enableSuggestions = true,

    // callbacks
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onSubmitted,
  });

  // ---------------------------------------------------------------------------
  // IDENTIFIER
  // ---------------------------------------------------------------------------

  final String name;

  // ---------------------------------------------------------------------------
  // VALUE
  // ---------------------------------------------------------------------------

  /// Optional external controller.
  ///
  /// Jika null maka internal controller akan dibuat otomatis.
  final TextEditingController? controller;

  /// Initial value.
  ///
  /// Prioritas:
  /// 1. AppForm.initialValues
  /// 2. initialValue
  /// 3. controller.text
  final String? initialValue;

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  final String? hintText;

  final Widget? prefix;

  final Widget? suffix;

  // ---------------------------------------------------------------------------
  // BEHAVIOR
  // ---------------------------------------------------------------------------

  final bool isPassword;

  final bool readOnly;

  final bool autofocus;

  final bool enabled;

  final bool isShowError;

  // ---------------------------------------------------------------------------
  // INPUT
  // ---------------------------------------------------------------------------

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final int? maxLines;

  final int? minLines;

  final List<TextInputFormatter>? inputFormatters;

  final int? maxLength;

  final FocusNode? focusNode;

  final TextCapitalization textCapitalization;

  final TextAlign textAlign;

  final bool autocorrect;

  final bool enableSuggestions;

  // ---------------------------------------------------------------------------
  // CALLBACKS
  // ---------------------------------------------------------------------------

  final String? Function(String value)? validator;

  final ValueChanged<String>? onSaved;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField>
    implements AppFormFieldState<String> {
  AppFormState? _form;

  late final TextEditingController _controller;

  bool _isInternalController = false;

  String? _errorText;

  bool _hasInteracted = false;

  late String _initialValue;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  @override
  String get name => widget.name;

  @override
  String? get currentError => _errorText;

  @override
  String get value => _controller.text;

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    assert(
      widget.name.isNotEmpty,
      'AppTextFormField: name tidak boleh kosong.',
    );

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }

    _initialValue = widget.initialValue ?? _controller.text;

    _controller.text = _initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newForm = AppForm.maybeOf(context);

    if (_form != newForm) {
      _form?.unregister(this);

      _form = newForm;

      // ---------------------------------------------------------------------
      // PRIORITY:
      // form.initialValues
      // -> widget.initialValue
      // -> controller.text
      // ---------------------------------------------------------------------

      final formInitialValue = _form?.value<String>(widget.name);

      if (formInitialValue != null) {
        _initialValue = formInitialValue;

        if (_controller.text != formInitialValue) {
          _controller.text = formInitialValue;
        }
      }

      _form?.register(this);
    }
  }

  @override
  void didUpdateWidget(covariant AppTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.name != widget.name) {
      assert(widget.name.isNotEmpty, 'AppTextFormField: name cannot be empty.');

      _form?.renameField(oldName: oldWidget.name, field: this);
    }
  }

  @override
  void dispose() {
    _form?.unregister(this);

    if (_isInternalController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  void didChange(String? value) {
    final newValue = value ?? '';

    if (_controller.text != newValue) {
      _controller.text = newValue;

      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }

    _handleChanged(newValue);
  }

  // ---------------------------------------------------------------------------
  // VALIDATION
  // ---------------------------------------------------------------------------

  @override
  bool validate() {
    final error = widget.validator?.call(_controller.text);

    if (error != _errorText) {
      setState(() {
        _errorText = error;
      });
    }

    return error == null;
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  @override
  void reset() {
    setState(() {
      _errorText = null;
      _hasInteracted = false;

      _controller.text = _initialValue;
    });
  }

  // ---------------------------------------------------------------------------
  // SAVE
  // ---------------------------------------------------------------------------

  @override
  void save() {
    widget.onSaved?.call(_controller.text);
  }

  // ---------------------------------------------------------------------------
  // CHANGE
  // ---------------------------------------------------------------------------

  void _handleChanged(String value) {
    _hasInteracted = true;

    _form?.setValue(name, value);

    final mode = _form?.autovalidateMode ?? AutovalidateMode.disabled;

    if (mode == AutovalidateMode.always ||
        (mode == AutovalidateMode.onUserInteraction && _hasInteracted)) {
      final error = widget.validator?.call(value);

      if (error != _errorText) {
        setState(() {
          _errorText = error;
        });
      }
    }

    widget.onChanged?.call(value);
  } // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: _controller,

      // ui
      hintText: widget.hintText,
      prefix: widget.prefix,
      suffix: widget.suffix,

      // state
      errorText: _errorText,
      isShowError: widget.isShowError,

      // behavior
      isPassword: widget.isPassword,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      enabled: widget.enabled,

      // input
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,

      // callbacks
      onChanged: _handleChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
