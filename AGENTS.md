# Health Pal — Agent Guide

Refer to `docs/` for detailed guidance:

| File | Covers |
|---|---|
| `docs/business_requirement/brd_health_pal.md` | Business requirements |
| `docs/product/product/prd_health_pal.md` | Product requirements |
| `docs/erd/erd_healh_pal.md` | Database schema, RLS, indexes |
| `docs/api_contract/api_contract_health_pal.md` | 19 REST endpoints |
| `docs/user_flow/USER_FLOW.md` | 7 Mermaid flow diagrams |
| `docs/tdd/01-arsitektur.md` through `docs/tdd/12-task-breakdown.md` | Complete TDD (12 docs) |
| `docs/wireframe/` | 21 per-page wireframes |

## Quick Commands
```powershell
dart run build_runner build --force-jit  # Codegen (injectable, freezed, json_serializable, mockito)
dart fix --apply                                          # Auto-fix lint issues
flutter analyze                                           # Static analysis
flutter test                                              # Tests
flutter pub get                                           # Get dependencies
```

## Project Structure
```
lib/
├── core/           # DI, router, theme, services, enums
├── features/
│   ├── auth/       # SignIn, SignUp, ForgotPassword, CreateProfile
│   ├── home/       # Home dashboard
│   └── onboarding/ # Onboarding carousel
├── widgets/        # Shared reusable widgets
└── main.dart       # Entrypoint (dotenv → DI → AppServices → runApp)
```

## Important Notes
- **No Material package** — use raw Flutter widgets only
- **Supabase** is sole backend (no Dio/http)
- **GoRouter** with `StatefulShellRoute` for bottom nav
- **Bloc/Cubit** for state management
- **injectable + get_it** for DI
- `.env` file required with `SUPABASE_URL` and `SUPABASE_ANON_KEY`
