# Coding Style

## Language
- Old comments are **in Indonesian**; write new code and comments in **English**

## Theme
- Custom `AppTheme` class for colors (`lib/core/theme/app_theme.dart`) — no `ThemeData`
- Custom `AppTextTheme` class for typography (`lib/core/theme/app_text_theme.dart`)
- Fonts: **Inter** for headings/body, **Poppins** for labels — via `google_fonts`

## Reusable Widgets (`lib/widgets/`)
- **Form system**: `AppForm` + `AppTextFormField`
- **Buttons**: `LightFilledButton`, `LightOutlineButton`
- **Dialogs**: date picker, success, loading dialogs
- **Inputs**: dropdown, PIN, date picker fields
- **Pickers**: `AppImagePicker`
