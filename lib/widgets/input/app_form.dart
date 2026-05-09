import 'package:flutter/widgets.dart';

// ---------------------------------------------------------------------------
// AppFormFieldState
// ---------------------------------------------------------------------------

abstract class AppFormFieldState {
  /// Nama unik field dalam form.
  String get name;

  /// Error aktif saat ini.
  String? get currentError;

  String get value;

  bool validate();

  void reset();

  void save();
}

// ---------------------------------------------------------------------------
// _AppFormScope
// ---------------------------------------------------------------------------

class _AppFormScope extends InheritedWidget {
  const _AppFormScope({required this.formState, required super.child});

  final AppFormState formState;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

// ---------------------------------------------------------------------------
// AppForm
// ---------------------------------------------------------------------------

class AppForm extends StatefulWidget {
  const AppForm({
    super.key,
    required this.child,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
  });

  final Widget child;

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

// ---------------------------------------------------------------------------
// AppFormState
// ---------------------------------------------------------------------------

class AppFormState extends State<AppForm> {
  /// key = field name
  /// value = field state
  final Map<String, AppFormFieldState> _fields = {};

  // -------------------------------------------------------------------------
  // Internal API
  // -------------------------------------------------------------------------

  void register(AppFormFieldState field) {
    final existing = _fields[field.name];

    assert(
      existing == null || identical(existing, field),
      'Duplicate AppFormField name: "${field.name}". '
      'Every AppFormField inside one AppForm must have unique name.',
    );

    _fields[field.name] = field;
  }

  void unregister(AppFormFieldState field) {
    final current = _fields[field.name];

    if (identical(current, field)) {
      _fields.remove(field.name);
    }
  }

  /// Digunakan saat field rename.
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

  void fieldDidChange() {
    widget.onChanged?.call();

    if (widget.autovalidateMode == AutovalidateMode.always) {
      validate();
    }
  }

  // -------------------------------------------------------------------------
  // Public API
  // -------------------------------------------------------------------------

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

  Map<String, String> get values => {
    for (final entry in _fields.entries) entry.key: entry.value.value,
  };

  String? value(String name) {
    return _fields[name]?.value;
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return _AppFormScope(formState: this, child: widget.child);
  }
}
