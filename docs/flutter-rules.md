# Flutter Rules

## Key Packages
| Package | Purpose |
|---|---|
| `go_router` | Declarative routing + redirect guard |
| `get_it` + `injectable` | DI + codegen |
| `flutter_bloc` | Cubit for forgot-password flow |
| `provider` | ChangeNotifier provider for onboarding |
| `shared_preferences` | Persist onboarding & login state |
| `google_fonts` | Inter (headings/body) + Poppins (labels) |
| `iconsax_latest` | Icon set |
| `smooth_page_indicator` | Onboarding dots |
| `image_picker` | Profile photo picker |
| `equatable` | User entity value equality |
| `flutter_native_splash` | Splash screen config (color `#1C2A3A`, logo `assets/logo.png`) |
| `widget_previews` | Dev-only widget previews in `lib/preview/` |

## Important Conventions
- Use `WidgetsApp.router` (not `MaterialApp.router`) when setting up GoRouter
- **Splash screen** is configured declaratively via `flutter_native_splash` in `pubspec.yaml`, not in Dart code
- Generated files excluded from static analysis: `*.g.dart`, `*.freezed.dart`, `*.mocks.dart`, `*.config.dart`
