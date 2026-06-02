import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../widgets/dialog/app_date_picker_dialog.dart';

@Preview(name: 'Date Picker Dialog Comparison')
Widget previewDatePickerDialogComparison() {
  return _PreviewDatePickerDialogComparison();
}

class _PreviewDatePickerDialogComparison extends StatefulWidget {
  @override
  State<_PreviewDatePickerDialogComparison> createState() =>
      _PreviewDatePickerDialogComparisonState();
}

class _PreviewDatePickerDialogComparisonState
    extends State<_PreviewDatePickerDialogComparison> {
  OverlayEntry? _overlay;

  DateTime selectedDate = DateTime.now();

  // ---------------------------------------------------------------------------
  // CUSTOM DIALOG
  // ---------------------------------------------------------------------------

  void _showCustomDialog() {
    _overlay?.remove();

    _overlay = OverlayEntry(
      builder: (_) {
        return AppDatePickerDialog(
          initialDate: selectedDate,

          onCancel: _hideDialog,

          onConfirm: (date) {
            setState(() {
              selectedDate = date;
            });

            _hideDialog();
          },
        );
      },
    );

    Overlay.of(context).insert(_overlay!);
  }

  void _hideDialog() {
    _overlay?.remove();
    _overlay = null;
  }

  // ---------------------------------------------------------------------------
  // MATERIAL DIALOG
  // ---------------------------------------------------------------------------

  Future<void> _showMaterialPicker() async {
    final picked = await showDatePicker(
      context: context,

      initialDate: selectedDate,

      firstDate: DateTime(1900),

      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    _hideDialog();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          // ---------------------------------------------------------------
          // CUSTOM BUTTON
          // ---------------------------------------------------------------
          GestureDetector(
            onTap: _showCustomDialog,

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),

                color: const Color(0xFF111111),
              ),

              child: const Text(
                'Open Custom Picker',

                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---------------------------------------------------------------
          // MATERIAL BUTTON
          // ---------------------------------------------------------------
          GestureDetector(
            onTap: _showMaterialPicker,

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),

                color: const Color(0xFF1976D2),
              ),

              child: const Text(
                'Open Material Picker',

                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---------------------------------------------------------------
          // RESULT
          // ---------------------------------------------------------------
          Text(
            '${selectedDate.day.toString().padLeft(2, '0')}/'
            '${selectedDate.month.toString().padLeft(2, '0')}/'
            '${selectedDate.year}',
          ),
        ],
      ),
    );
  }
}
