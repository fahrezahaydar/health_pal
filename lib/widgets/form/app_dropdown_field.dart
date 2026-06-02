import 'package:flutter/widgets.dart';

import '../input/drop_down_button.dart';
import 'app_form.dart';

export '../input/drop_down_button.dart' show AppDropdownItem;

class AppDropdownFormField<T> extends StatefulWidget {
  const AppDropdownFormField({
    super.key,
    required this.name,
    required this.items,

    this.initialValue,

    this.hintText,
    this.prefix,
    this.suffix,

    this.enabled = true,
    this.isShowError = true,

    this.validator,
    this.onSaved,
    this.onChanged,
  });

  final String name;

  final List<AppDropdownItem<T>> items;

  final T? initialValue;

  final String? hintText;

  final Widget? prefix;

  final Widget? suffix;

  final bool enabled;

  final bool isShowError;

  final String? Function(T? value)? validator;

  final ValueChanged<T?>? onSaved;

  final ValueChanged<T?>? onChanged;

  @override
  State<AppDropdownFormField<T>> createState() =>
      _AppDropdownFormFieldState<T>();
}

class _AppDropdownFormFieldState<T> extends State<AppDropdownFormField<T>>
    implements AppFormFieldState<T> {
  AppFormState? _form;

  T? _value;

  late T? _initialValue;

  String? _errorText;

  bool _hasInteracted = false;

  @override
  String get name => widget.name;

  @override
  T? get value => _value;

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

      final formInitialValue = _form?.value<T>(widget.name);

      if (formInitialValue != null) {
        _initialValue = formInitialValue;
        _value = formInitialValue;
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

  @override
  void didChange(T? value) {
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

  @override
  Widget build(BuildContext context) {
    return AppDropdownButton<T>(
      items: widget.items,
      value: _value,

      hintText: widget.hintText,
      prefix: widget.prefix,
      suffix: widget.suffix,

      enabled: widget.enabled,

      errorText: _errorText,
      isShowError: widget.isShowError,

      onChanged: didChange,
    );
  }
}
