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
| `docs/adr/` | Architecture Decision Records |

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
│   ├── doctor/     # Doctor search + detail (Sprint 1)
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

## Skeleton Loading Rule (Architectural Standard)
- **WAJIB** pakai `skeletonizer: ^1.4.0` untuk semua loading skeleton UI.
- **DILARANG** membuat dedicated skeleton widgets (mis. `banner_skeleton.dart`, `upcoming_skeleton.dart`) — reuse production widget langsung via `Skeletonizer(enabled: ..., child: ...)`.
- Pengecualian hanya diizinkan dengan komentar `/* justify: skeletonizer cannot replace X because ... */`.
- Loading state pattern:
  ```dart
  // ✅ BENAR — reuse production widget
  Skeletonizer(
    enabled: state is Loading,
    child: BannerCarousel(banners: mockBanners),
  )

  // ❌ SALAH — dedicated skeleton file
  // class BannerSkeleton extends StatelessWidget { ... }
  ```
- **shimmer: ^3.0.0** resmi **DEPRECATED** sejak ADR Skeletonizer. Migrasi: hapus `shimmer` dari pubspec, ganti semua import dengan `skeletonizer`. Jika ada shimmer code yang sudah committed, jangan ubah (owner decide via TODO list).

## Icon Convention (Sprint 2+)
- **Default: pakai `Material Icons`** (`Icons.search`, `Icons.calendar`, dll) untuk fitur/icon BARU.
- **Jangan pakai `Iconsax` di code baru** — suffix convention `iconsax_latest ^1.0.0` sering error (mis. `search_normal` vs `search`, `arrow_left` vs `arrowLeft01`).
- Setiap kali pakai Material icon, **WAJIB** tambahkan TODO comment di file Dart:
  ```dart
  // TODO: change to iconsax — currently Material fallback (iconsax_latest 1.0.0 suffix error-prone)
  final IconData _icon = Icons.search;
  ```
- User (Project Owner) yang akan swap ke `Iconsax.X` icon yang benar secara manual setelah lihat TODO list.
- **Existing code** yang sudah pakai `Iconsax.X` (sudah committed) **TIDAK boleh diubah** — biarin sampai owner decide.
- Reason: mempercepat delivery Sprint 2 + mengurangi cycle "cari nama icon yang valid" di iconsax_latest 1.0.0.

### Cara kerja
1. Implementasi fitur baru → pakai `Icons.X` (Material) + tambah TODO comment.
2. Commit conventional.
3. Owner review, swap ke `Iconsax.X` yang sesuai + hapus TODO.
4. Future code baru: lihat existing TODO comments untuk pattern yang dipakai.

## Sprint 1 — Testing Policy
- **TIDAK BOLEH membuat file test apapun** selama implementasi feature.
- Fokus implementasi: Data Layer → Domain Layer → Presentation Layer → DI → `flutter analyze`.
- Testing (unit, widget, bloc, integration) dikerjakan **fase terpisah** setelah SEMUA feature Sprint 1 selesai.
- Test infrastructure (test/helpers, test/flutter_test_config.dart, mocks.mocks.dart) yang sudah ada di-skip dulu — tidak dipakai sampai fase testing dimulai.
