# Architecture

## Entrypoint & Init Order
- `lib/main.dart` → `configureDependencies()` (DI) → `appService.init()` → `runApp`
- DI uses `get_it` + `injectable` with codegen — run `dart run build_runner build --delete-conflicting-outputs` after adding/changing `@injectable`/`@lazySingleton` annotations

## Layering
- **Feature-first**: each feature under `lib/features/` owns its `bloc/` and `page/`
- **Domain layer** at `lib/domain/` — entities in `entity/`, use cases in `usecases/` (currently **empty**)
- **Core layer** at `lib/core/` — DI, routing, services, theme, enums
- **Shared widgets** at `lib/widgets/`

## Routing
- `go_router` via `WidgetsApp.router` (NOT `MaterialApp.router`) — see `lib/core/router/app_router.dart`
- All navigation uses `context.go()` (no named routes)

## Route Auth Guard
- `GoRouter.redirect` reads `AppServices.status` (`AppStatus` enum)
- Flow: `loading` → `onboarding` → `unauthenticated` → `authenticated`
- `AppServices` is a `ChangeNotifier` registered as GoRouter's `refreshListenable`

## DI Registration Pattern
```dart
@lazySingleton     // AppServices, SharedPrefService, AppRouter
@injectable        // OnboardingNotifier
@module            // RegisterModule: SharedPreferences (preResolve)
```
