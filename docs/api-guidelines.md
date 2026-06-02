# API Guidelines

## Current State
- **Auth service calls are stubs** — no real backend integration
  - e.g. `ForgotPasswordCubit` uses `Future.delayed(const Duration(seconds: 5))`
  - Login/social buttons have `onTap: () {}` placeholders
- `domain/auth/usecases/` is **empty** — ready for implementation
- `domain/auth/entity/user.dart` has both `photourl` (local path) and `photoRemoteUrl` (CDN/remote URL)

## Data Model Conventions
- `User` entity uses `Equatable` for value equality
- Serialization via `fromMap(Map<String, dynamic>)` / `toMap()` — not code-generated
- Static `m*` constants on entity class for map keys (e.g., `mFullName`, `mEmail`)

## Implementation Notes
- When wiring real API calls, prefer a `Repository` pattern behind use cases
- Photo upload flow: pick locally → copy to app cache (`photourl`) → upload to CDN (`photoRemoteUrl`)
