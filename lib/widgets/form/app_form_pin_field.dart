import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import '../input/app_pin_field.dart';
import 'app_form.dart';

class AppFormPinField extends StatefulWidget {
  const AppFormPinField({
    super.key,
    required this.name,

    // value
    this.controller,
    this.initialValue,

    // pin
    this.length = 6,

    // callbacks
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onCompleted,
  });

  final String name;

  final TextEditingController? controller;

  final String? initialValue;

  final int length;

  final String? Function(String value)? validator;

  final ValueChanged<String>? onSaved;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onCompleted;

  @override
  State<AppFormPinField> createState() => _AppFormPinFieldState();
}

class _AppFormPinFieldState extends State<AppFormPinField>
    implements AppFormFieldState<String> {
  AppFormState? _form;

  late final TextEditingController _controller;

  bool _isInternalController = false;

  String? _errorText;

  bool _hasInteracted = false;

  late String _initialValue;

  @override
  String get name => widget.name;

  @override
  String get value => _controller.text;

  @override
  String? get currentError => _errorText;

  @override
  void initState() {
    super.initState();

    assert(widget.name.isNotEmpty, 'AppFormPinField: name tidak boleh kosong.');

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

      final formInitialValue = _form?.value<String>(widget.name);

      if (formInitialValue != null) {
        _initialValue = formInitialValue;

        if (_controller.text != formInitialValue) {
          _controller.text = formInitialValue;
        }
      }

      _form?.register(this);

      _form?.setValue(name, _controller.text);
    }
  }

  @override
  void didUpdateWidget(covariant AppFormPinField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.name != widget.name) {
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
  bool validate() {
    final error = widget.validator?.call(_controller.text);

    if (error != _errorText) {
      setState(() {
        _errorText = error;
      });
    }

    return error == null;
  }

  @override
  void reset() {
    _controller.text = _initialValue;

    setState(() {
      _errorText = null;
      _hasInteracted = false;
    });

    _form?.setValue(name, _controller.text);
  }

  @override
  void save() {
    widget.onSaved?.call(_controller.text);
  }

  @override
  void didChange(String? value) {
    final newValue = value ?? '';

    if (_controller.text != newValue) {
      _controller.text = newValue;
    }

    _handleChanged(newValue);
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return AppPinField(
      controller: _controller,
      length: widget.length,
      errorText: _errorText,

      onChanged: _handleChanged,

      onCompleted: (value) {
        didChange(value);

        widget.onCompleted?.call(value);
      },

      deleteMode: PinDeleteMode.currentAndAfter,

      textStyle: const TextStyle(
        fontSize: 20,
        color: AppTheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
