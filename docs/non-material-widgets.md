# Non-Material Widget Guide

## Golden Rule
Gunakan `import 'package:flutter/widgets.dart'` — jangan `package:flutter/material.dart`.

## Color & Typography
```dart
import 'package:health_pal/core/theme/app_theme.dart';
import 'package:health_pal/core/theme/app_text_theme.dart';
```

- Warna: `AppTheme.primary`, `AppTheme.grey500`, dll.
- TextStyle: `AppTextTheme.bodyMedium`, `AppTextTheme.labelLarge`, dll.
- Fallback: `GoogleFonts.inter(...)` / `GoogleFonts.poppins(...)`

## Pengganti Material Widgets

| Material | Non-Material |
|---|---|
| `InkWell` / `ElevatedButton` | `GestureDetector` + `AnimatedContainer` |
| `TextField` | `EditableText` (contoh: `AppInputField`) |
| `showDialog()` | `OverlayEntry` + `Overlay.of(context).insert()` |
| `MaterialApp.router` | `WidgetsApp.router` |
| `ThemeData` | `AppTheme` + `AppTextTheme` |

## Tekan & Efek (Press Feedback)
```dart
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) => setState(() => _pressed = false),
  onTapCancel: () => setState(() => _pressed = false),
  onTap: widget.onTap,
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 120),
    decoration: BoxDecoration(
      color: _pressed ? AppTheme.deepTeal : AppTheme.primary,
      borderRadius: BorderRadius.circular(42),
    ),
    child: Text(widget.label, style: ...),
  ),
)
```

## Layout
- `Row`/`Column`: pakai `spacing` (bukan `SizedBox` antar children)
- Selalu set `mainAxisSize: MainAxisSize.min` di dalam container
- Hindari unbounded height — pakai `Expanded` / `ConstrainedBox`

## File Referensi di `lib/widgets/`
- `button/primary_button.dart` — button dengan press feedback
- `button/outline_button.dart` — variant outline
- `input/app_input_field.dart` — `EditableText` + focus + error
- `input/app_form_field.dart` — form + validasi
- `dialog/app_date_picker_dialog.dart` — dialog via `OverlayEntry`
