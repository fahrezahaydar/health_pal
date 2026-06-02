import 'package:flutter/material.dart';

import 'app_form.dart';
import 'app_date_picker_field.dart';

class AppDatePickerFormField extends StatefulWidget {
  const AppDatePickerFormField({
    super.key,
    required this.name,
    this.initialValue,
    this.hintText,
    this.prefix,
    this.suffix,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
  });

  final String name;

  final DateTime? initialValue;

  final String? hintText;

  final Widget? prefix;

  final Widget? suffix;

  final DateTime? firstDate;

  final DateTime? lastDate;

  final String? Function(DateTime? value)? validator;

  final ValueChanged<DateTime?>? onChanged;

  final ValueChanged<DateTime?>? onSaved;

  final bool enabled;

  @override
  State<AppDatePickerFormField> createState() => _AppDatePickerFormFieldState();
}

class _AppDatePickerFormFieldState extends State<AppDatePickerFormField>
    implements AppFormFieldState<DateTime> {
  AppFormState? _form;

  DateTime? _value;

  late DateTime? _initialValue;

  String? _errorText;

  bool _hasInteracted = false;

  @override
  String get name => widget.name;

  @override
  DateTime? get value => _value;

  @override
  String? get currentError => _errorText;

  @override
  void initState() {
    super.initState();
    _initialValue = widget.initialValue;
    _value = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newForm = AppForm.maybeOf(context);

    if (_form != newForm) {
      _form?.unregister(this);

      _form = newForm;

      final formValue = _form?.value<DateTime>(widget.name);

      if (formValue != null) {
        _initialValue = formValue;
        _value = formValue;
      }

      _form?.register(this);

      _form?.setValue(name, _value);
    }
  }

  @override
  void dispose() {
    _form?.unregister(this);
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FORM SYNC
  // ---------------------------------------------------------------------------

  @override
  void didChange(DateTime? value) {
    _hasInteracted = true;

    setState(() {
      _value = value;
    });

    _form?.setValue(name, value);

    final mode = _form?.autovalidateMode ?? AutovalidateMode.disabled;

    if (mode == AutovalidateMode.always ||
        (mode == AutovalidateMode.onUserInteraction && _hasInteracted)) {
      validate();
    }

    widget.onChanged?.call(value);
  }

  @override
  bool validate() {
    final error = widget.validator?.call(_value);

    setState(() {
      _errorText = error;
    });

    return error == null;
  }

  @override
  void reset() {
    setState(() {
      _value = _initialValue;
      _errorText = null;
      _hasInteracted = false;
    });

    _form?.setValue(name, _value);
  }

  @override
  void save() {
    widget.onSaved?.call(_value);
  }

  // ---------------------------------------------------------------------------
  // PICKER
  // ---------------------------------------------------------------------------

  Future<void> _pick() async {
    if (!widget.enabled) return;

    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _value ?? now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (picked != null) {
      didChange(picked);
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AppDatePickerField(
      value: _value,
      hintText: widget.hintText,
      prefix: widget.prefix,
      suffix: widget.suffix,
      errorText: _errorText,
      enabled: widget.enabled,
      onTap: _pick,
    );
  }
}
