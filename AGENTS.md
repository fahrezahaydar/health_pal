# Health Pal — Agent Guide

Refer to `docs/` for detailed guidance:

| File | Covers |
|---|---|
| `docs/architecture.md` | Entrypoint, layering, routing, auth guard, DI pattern |
| `docs/coding-style.md` | Language, theme, reusable widgets |
| `docs/flutter-rules.md` | Key packages, important conventions, generated file exclusions |
| `docs/state-management.md` | BLoC Cubit vs ChangeNotifier vs StatefulWidget |
| `docs/testing.md` | Current state (none), commands, how to add tests |
| `docs/api-guidelines.md` | Stub auth calls, data model conventions, implementation notes |
| `docs/non-material-widgets.md` | Build widgets without Material — widgets-only patterns |

## Quick Commands
```powershell
dart run build_runner build --delete-conflicting-outputs  # codegen
flutter analyze                                           # static analysis
flutter test                                              # tests
```
