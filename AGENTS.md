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
| `docs/progress/plans/` | Sprint plans (Sprint A2-A9) |
| `docs/progress/audits/` | Sprint audit results |  
| `docs/progress/sprint_roadmap.md` | Sprint roadmap (A1-A9 done, B+ TBD) |
| `docs/reference/icons.md` | Icon mapping table |

## Quick Commands
```powershell
dart run build_runner build --force-jit  # Codegen (injectable, freezed, json_serializable, mockito)
dart fix --apply                                          # Auto-fix lint issues
flutter analyze                                           # Static analysis
flutter pub get                                           # Get dependencies
.\supabase\seed-assets.ps1                                # Upload seed images ke storage (banner, icon, foto dokter)
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

## Seed Assets Rule (Storage Workflow)

`supabase/seed-assets.ps1` mengupload semua file gambar dari `supabase/seed-assets/` ke Supabase Storage local (Docker volume). Karena storage **PERSIST** walau `supabase db reset`, script ini cukup dijalankan sekali, kecuali ada file baru/diubah.

### Kapan Harus Dijalankan

| Skenario | Wajib? | Keterangan |
|----------|--------|------------|
| Pertama kali clone repo + `supabase start` | ✅ Ya | Storage masih kosong |
| `supabase stop` lalu `supabase start` dengan **volume baru** (`--no-volume-persist` atau hapus Docker volume manual) | ✅ Ya | Volume storage hilang |
| Ada file **baru** di `seed-assets/<subfolder>/` | ✅ Ya | File baru harus diupload |
| Ada file **diubah** (nama sama, konten beda) | ✅ Ya | Script pakai PUT upsert — file lama ketimpa |
| `supabase db reset` | ❌ **Tidak perlu** | Storage PERSIST, hanya DB yang di-reset |
| `supabase start` ulang tanpa flag `--no-volume-persist` | ❌ **Tidak perlu** | Volume Docker persist |

> **Catatan:** Storage files disimpan di Docker volume, bukan di database. `supabase db reset` hanya reset schema SQL + data tabel, **tidak** menghapus file di bucket storage.

### Cara Menjalankan

```powershell
# Upload semua subfolder (banner, specialization_icon, doctor_avatar)
.\supabase\seed-assets.ps1

# Upload subfolder tertentu
.\supabase\seed-assets.ps1 -Bucket doctor_avatar
```

### Mapping Bucket Saat Ini

| Subfolder `seed-assets/` | Bucket | Path di Storage | Contoh URL `seed.sql` |
|--------------------------|--------|-----------------|-----------------------|
| `banner/` | `avatars` | `banner/nama-file.jpg` (preserve subfolder) | `http://127.0.0.1:54321/storage/v1/object/public/avatars/banner/banner_1.png` |
| `specialization_icon/` | `specialization-icons` | Flat — `nama-file.svg` | `http://127.0.0.1:54321/storage/v1/object/public/specialization-icons/umum.svg` |
| `doctor_avatar/` | `doctor-avatars` | Flat — `nama-file.jpg` | `http://127.0.0.1:54321/storage/v1/object/public/doctor-avatars/andi-pratama.jpg` |

### Panduan Menambah Bucket Baru

Jika ada kebutuhan bucket storage baru (misal `clinic-photos`), lakukan:

1. **Buat migration SQL** untuk bucket + RLS policy (lihat `008_doctor_avatars_bucket.sql` sebagai template).
2. **Buat folder** `supabase/seed-assets/<nama-subfolder>/` dan isi file.
3. **Update `$BUCKET_MAP`** di `supabase/seed-assets.ps1`:
   ```powershell
   $BUCKET_MAP = @{
     "banner"               = "avatars"
     "specialization_icon"  = "specialization-icons"
     "doctor_avatar"        = "doctor-avatars"
     "clinic_photo"         = "clinic-photos"      # ← tambah di sini
   }
   ```
4. **Update `seed.sql`** — referensi URL pakai bucket + path yang sesuai.
5. Jalankan `.\supabase\seed-assets.ps1` untuk upload file awal.

### Agent Proactive Rule

- **Saat user minta `supabase db reset`** → setelah reset selesai, **otomatis jalankan** `.\supabase\seed-assets.ps1` untuk memastikan storage tidak ketinggalan (meskipun storage seharusnya persist, safety measure). Alternatif minimal: ingatkan user untuk menjalankannya.
- **Saat user minta menambah bucket storage baru** → sebagai bagian dari task yang sama, **WAJIB**:
  - Buat migration SQL
  - Tambah entry `$BUCKET_MAP`
  - Buat folder `seed-assets/<nama>/`
  - Buat/update seed.sql references
  - **JANGAN** jadikan task terpisah atau minta diingatkan lagi
- **Perhatikan behavior khusus `banner/`**: subfolder `banner` preserve relative path (`banner/file.png`), sementara subfolder lainnya flat (`file.svg`). Kalau bucket baru butuh subfolder path, ikuti pola `banner`. Kalau flat, ikuti pola `specialization_icon` / `doctor_avatar`.

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
