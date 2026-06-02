# State Management

The project uses a **mix of approaches** — use the right tool per feature:

| Pattern | Where |
|---|---|
| `flutter_bloc` (Cubit) | Forgot-password flow (`lib/features/auth/bloc/forget_password/`) |
| `ChangeNotifier` + `Provider` | Onboarding flow (`lib/features/onboarding/bloc/`) |
| Raw `StatefulWidget` | Login, Sign Up, Create Profile pages |

## Guidelines
- Keep business logic in BLoC/ChangeNotifier, not in widgets
- Prefer Cubit over full Bloc for simple async flows (e.g., multi-step forgot-password)
- Use `ChangeNotifier` when the state is linear and UI is tightly coupled (onboarding page indicator)
- Raw `StatefulWidget` is acceptable for simple forms with local state only
