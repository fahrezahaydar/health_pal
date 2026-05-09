import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_form.dart';
import 'app_pin_field.dart';

class AppFormPinField extends StatefulWidget {
  const AppFormPinField({
    super.key,
    required this.name,
    required this.controller,
    this.length = 6,
    this.validator,
    this.onChanged,
    this.onCompleted,
  });

  final String name;
  final TextEditingController controller;
  final int length;

  final String? Function(String value)? validator;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<AppFormPinField> createState() => _AppFormPinFieldState();
}

class _AppFormPinFieldState extends State<AppFormPinField>
    implements AppFormFieldState {
  AppFormState? _form;

  String? _errorText;

  @override
  String get name => widget.name;

  @override
  String get value => widget.controller.text;

  @override
  String? get currentError => _errorText;

  @override
  bool validate() {
    final error = widget.validator?.call(widget.controller.text);

    if (error != _errorText) {
      setState(() {
        _errorText = error;
      });
    }

    return error == null;
  }

  @override
  void reset() {
    widget.controller.clear();

    setState(() {
      _errorText = null;
    });
  }

  @override
  void save() {}

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
  void dispose() {
    _form?.unregister(this);
    super.dispose();
  }

  void _handleChanged(String value) {
    final mode = _form?.autovalidateMode ?? AutovalidateMode.disabled;

    if (mode != AutovalidateMode.disabled) {
      final error = widget.validator?.call(value);

      if (error != _errorText) {
        setState(() {
          _errorText = error;
        });
      }
    }

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return AppPinField(
      controller: widget.controller,
      length: widget.length,
      errorText: _errorText,
      onChanged: _handleChanged,
      onCompleted: widget.onCompleted,
      deleteMode: PinDeleteMode.currentAndAfter,

      textStyle: TextStyle(
        fontSize: 20,
        color: AppTheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
