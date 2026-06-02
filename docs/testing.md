# Testing

## Current State
- **No tests exist** — `test/` directory is empty
- **No CI workflows** — `.github/workflows/` does not exist
- No snapshot or golden tests

## Commands
```powershell
# Run all tests
flutter test

# Static analysis (lint)
flutter analyze
```

## When Adding Tests
- Use `package:test` for unit tests, `flutter_test` for widget tests
- Mock external deps with `package:mockito` (generated via `build_runner`)
- Refer to generated file exclusion: `*.mocks.dart` is already in `analysis_options.yaml` exclusion list
