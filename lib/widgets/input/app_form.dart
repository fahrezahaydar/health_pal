import 'package:flutter/widgets.dart';

// -----------------------------------------------------------------------------
// FIELD CONTROLLER
// -----------------------------------------------------------------------------

class AppFormFieldController<T> {
  AppFormFieldController({
    required this.name,
    required this.value,
    required this.errorText,
    required this.didChange,
  });

  final String name;

  final T? value;

  final String? errorText;

  final void Function(T? value) didChange;
}

// -----------------------------------------------------------------------------
// FIELD STATE
// -----------------------------------------------------------------------------

abstract class AppFormFieldState<T> {
  String get name;

  T? get value;

  String? get currentError;

  bool validate();

  void reset();

  void save();

  void didChange(T? value);
}

// -----------------------------------------------------------------------------
// SCOPE
// -----------------------------------------------------------------------------

class _AppFormScope extends InheritedWidget {
  const _AppFormScope({required this.formState, required super.child});

  final AppFormState formState;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

// -----------------------------------------------------------------------------
// APP FORM
// -----------------------------------------------------------------------------

class AppForm extends StatefulWidget {
  const AppForm({
    super.key,
    required this.child,
    this.initialValues,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
  });

  final Widget child;

  final Map<String, dynamic>? initialValues;

  final AutovalidateMode autovalidateMode;

  final VoidCallback? onChanged;

  static AppFormState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AppFormScope>()
        ?.formState;
  }

  static AppFormState of(BuildContext context) {
    final result = maybeOf(context);

    assert(result != null, 'No AppForm found in widget tree.');

    return result!;
  }

  @override
  State<AppForm> createState() => AppFormState();
}

// -----------------------------------------------------------------------------
// APP FORM STATE
// -----------------------------------------------------------------------------

class AppFormState extends State<AppForm> {
  final Map<String, AppFormFieldState<dynamic>> _fields = {};

  final Map<String, dynamic> _values = {};

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _values.addAll(widget.initialValues ?? {});
  }

  // ---------------------------------------------------------------------------
  // INTERNAL API
  // ---------------------------------------------------------------------------

  void register(AppFormFieldState field) {
    final existing = _fields[field.name];

    assert(
      existing == null || identical(existing, field),
      'Duplicate AppFormField name: ${field.name}',
    );

    _fields[field.name] = field;
  }

  void unregister(AppFormFieldState field) {
    final current = _fields[field.name];

    if (identical(current, field)) {
      _fields.remove(field.name);
    }
  }

  void renameField({
    required String oldName,
    required AppFormFieldState field,
  }) {
    final current = _fields[oldName];

    if (identical(current, field)) {
      _fields.remove(oldName);
    }

    register(field);
  }

  void setValue(String name, dynamic value) {
    _values[name] = value;

    widget.onChanged?.call();

    if (widget.autovalidateMode == AutovalidateMode.always) {
      validate();
    }
  }

  // ---------------------------------------------------------------------------
  // PUBLIC API
  // ---------------------------------------------------------------------------

  T? value<T>(String name) {
    return _values[name] as T?;
  }

  Map<String, dynamic> get values => _values;

  bool validate() {
    bool valid = true;

    for (final field in _fields.values) {
      final result = field.validate();

      if (!result) {
        valid = false;
      }
    }

    return valid;
  }

  Map<String, String>? get errors {
    final result = <String, String>{};

    for (final entry in _fields.entries) {
      final error = entry.value.currentError;

      if (error != null) {
        result[entry.key] = error;
      }
    }

    return result.isEmpty ? null : result;
  }

  void reset() {
    for (final field in _fields.values) {
      field.reset();
    }
  }

  void save() {
    for (final field in _fields.values) {
      field.save();
    }
  }

  AutovalidateMode get autovalidateMode {
    return widget.autovalidateMode;
  }

  @override
  Widget build(BuildContext context) {
    return _AppFormScope(formState: this, child: widget.child);
  }
}

// -----------------------------------------------------------------------------
// APP FORM FIELD
// -----------------------------------------------------------------------------

class AppFormField<T> extends StatefulWidget {
  const AppFormField({
    super.key,
    required this.name,
    required this.builder,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.enabled = true,
  });

  final String name;

  final T? initialValue;

  final String? Function(T? value)? validator;

  final ValueChanged<T?>? onSaved;

  final bool enabled;

  final Widget Function(AppFormFieldController<T> field) builder;

  @override
  State<AppFormField<T>> createState() => _AppFormFieldState<T>();
}

class _AppFormFieldState<T> extends State<AppFormField<T>>
    implements AppFormFieldState<T> {
  AppFormState? _form;

  late T? _initialValue;

  T? _value;

  String? _error;

  bool _hasInteracted = false;

  @override
  String get name => widget.name;

  @override
  T? get value => _value;

  @override
  String? get currentError => _error;

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
        _value = formInitialValue;
        _initialValue = formInitialValue;
      }

      _form?.register(this);

      _form?.setValue(widget.name, _value);
    }
  }

  @override
  void didUpdateWidget(covariant AppFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.name != widget.name) {
      _form?.renameField(oldName: oldWidget.name, field: this);
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

    final mode = _form?.widget.autovalidateMode;

    if (mode == AutovalidateMode.always ||
        (mode == AutovalidateMode.onUserInteraction && _hasInteracted)) {
      validate();
    }
  }

  @override
  bool validate() {
    final error = widget.validator?.call(_value);

    setState(() {
      _error = error;
    });

    return error == null;
  }

  @override
  void reset() {
    setState(() {
      _value = _initialValue;
      _error = null;
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
    return widget.builder(
      AppFormFieldController<T>(
        name: name,
        value: _value,
        errorText: _error,
        didChange: didChange,
      ),
    );
  }
}
