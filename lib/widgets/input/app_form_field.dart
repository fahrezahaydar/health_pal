import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'app_form.dart';
import 'app_input_field.dart'; // ganti dengan path yang sesuai

// ---------------------------------------------------------------------------
// AppFormField
// ---------------------------------------------------------------------------
/// Wrapper di atas [AppInputField] yang auto-register ke [AppForm].
///
/// [name] wajib diisi dan harus unik dalam satu [AppForm].
/// Digunakan sebagai key di [AppFormState.errors].
///
/// Contoh:
/// ```dart
/// final _formKey = GlobalKey<AppFormState>();
///
/// AppForm(
///   key: _formKey,
///   child: Column(
///     children: [
///       AppFormField(
///         name: 'Email',
///         controller: _emailController,
///         hintText: 'Email',
///         validator: (v) => v.isEmpty ? 'Email wajib diisi' : null,
///       ),
///       AppFormField(
///         name: 'Password',
///         controller: _passwordController,
///         hintText: 'Password',
///         isPassword: true,
///         validator: (v) => v.isEmpty ? 'Password wajib diisi' : null,
///       ),
///       GestureDetector(
///         onTap: () {
///           if (!_formKey.currentState!.validate()) {
///             final errors = _formKey.currentState!.errors;
///             // errors == {"Email": "...", "Password": "..."}
///           }
///         },
///         child: const Text('Submit'),
///       ),
///     ],
///   ),
/// );
/// ```
class AppFormField extends StatefulWidget {
  const AppFormField({
    super.key,
    required this.name,
    required this.controller,
    this.hintText,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.initialValue,
    this.isShowError = true,
  });

  /// Nama unik field dalam form. Wajib diisi.
  /// Digunakan sebagai key di [AppFormState.errors].
  final String name;

  final TextEditingController controller;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool isPassword;

  /// Validator dipanggil saat [AppFormState.validate()] atau autovalidate aktif.
  final String? Function(String value)? validator;

  /// Dipanggil saat [AppFormState.save()].
  final ValueChanged<String>? onSaved;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool isShowError;

  /// Nilai awal; diset ke controller saat [AppFormState.reset()] dipanggil.
  final String? initialValue;

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField>
    implements AppFormFieldState {
  AppFormState? _form;
  String? _errorText;
  bool _hasInteracted = false;
  late String _initialValue;

  // -------------------------------------------------------------------------
  // AppFormFieldState impl
  // -------------------------------------------------------------------------

  @override
  String get name => widget.name;

  @override
  String? get currentError => _errorText;

  @override
  String get value => widget.controller.text;

  @override
  bool validate() {
    final error = widget.validator?.call(widget.controller.text);
    if (error != _errorText) {
      setState(() => _errorText = error);
    }
    return error == null;
  }

  @override
  void reset() {
    setState(() {
      _errorText = null;
      _hasInteracted = false;
      widget.controller.text = _initialValue;
    });
  }

  @override
  void save() {
    widget.onSaved?.call(widget.controller.text);
  }

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    assert(widget.name.isNotEmpty, 'AppFormField: name tidak boleh kosong.');
    _initialValue = widget.initialValue ?? widget.controller.text;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newForm = AppForm.maybeOf(context);

    if (_form != newForm) {
      _form?.unregister(this);

      _form = newForm;

      _form?.register(this);
    }
  }

  @override
  void didUpdateWidget(covariant AppFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.name != widget.name) {
      assert(widget.name.isNotEmpty, 'AppFormField: name cannot be empty.');

      _form?.renameField(oldName: oldWidget.name, field: this);
    }
  }

  @override
  void dispose() {
    _form?.unregister(this);
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Handlers
  // -------------------------------------------------------------------------

  void _handleChanged(String value) {
    _hasInteracted = true;
    _form?.fieldDidChange();

    final mode = _form?.autovalidateMode ?? AutovalidateMode.disabled;
    if (mode == AutovalidateMode.always ||
        (mode == AutovalidateMode.onUserInteraction && _hasInteracted)) {
      final error = widget.validator?.call(value);
      if (error != _errorText) setState(() => _errorText = error);
    }

    widget.onChanged?.call(value);
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppInputField(
      controller: widget.controller,
      hintText: widget.hintText,
      prefix: widget.prefix,
      suffix: widget.suffix,
      isPassword: widget.isPassword,
      errorText: _errorText,
      isShowError: widget.isShowError,
      onChanged: _handleChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      focusNode: widget.focusNode,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
    );
  }
}
