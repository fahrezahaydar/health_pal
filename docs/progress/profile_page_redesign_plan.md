# Profile Page Redesign — Implementation Plan

**ADR:** 013-profile-page-redesign.md
**Wireframe:** 14-profile.md (v2.0)
**Status:** Draft
**Target Sprint:** A7 (Sprint 2)

---

## Overview

Redesign Profile Page (Shell Tab 4) mengikuti wireframe v2.0. Perubahan utama:
1. Tambah field `phone_number` ke schema + data layer (field baru)
2. Extract reusable widgets (ProfileHeader, ProfileMenuTile, LogoutMenuTile)
3. Rewrite profile_page.dart layout (avatar edit overlay, phone number, menu labels)
4. Update EditProfilePage (tambah input phone number)
5. Update menu labels (Notifications, Help & Support, Terms & Conditions, Log Out)
6. Reuse AppConfirmDialog untuk logout (bukan widget baru)

---

## Database Changes

### Migration SQL: `016_profile_phone_number.sql`

```sql
-- Add phone_number column to user_profiles
ALTER TABLE user_profiles
ADD COLUMN phone_number TEXT;

COMMENT ON COLUMN user_profiles.phone_number IS 'Nomor telepon pribadi user. Diisi via Edit Profile.';
```

- Kolom **nullable** — existing data tidak terpengaruh
- Tidak ada constraint unique — satu nomor bisa dipakai di banyak akun (keluarga)
- Tidak ada NOT NULL — tidak wajib diisi saat registrasi

### Blast Radius — Database
| Object | Impact | Action |
|--------|--------|--------|
| `user_profiles` table | ✅ ADD COLUMN | Migration 016 |
| RLS policy | ❌ No change | Existing `auth.uid() = auth_id` tetap berlaku |
| Index | ❌ No change | Tidak perlu index — query by phone jarang |
| Seed SQL | ❌ No change | Seed data tidak perlu phone_number (nullable) |

---

## API Contract Update

### §3.5 GET /me — Response Bertambah

```diff
{
  "id": "uuid",
  "auth_id": "uuid",
  "full_name": "Daniel Martinez",
  "nickname": "daniel",
  "avatar_url": "https://...",
+ "phone_number": "+123 856479683",
  "date_of_birth": "1990-05-15",
  "gender": "male",
  "notif_reminder_enabled": true,
  "is_profile_complete": true,
  "created_at": "...",
  "updated_at": "..."
}
```

### §3.2 PUT /profile — Request Bisa Include phone_number

```diff
PATCH /rest/v1/user_profiles?auth_id=eq.<auth_uid>
Content-Type: application/json

{
  "full_name": "Daniel Martinez",
  "nickname": "daniel",
+ "phone_number": "+123 856479683",
  "date_of_birth": "1990-05-15",
  "gender": "male"
}
```

### Blast Radius — API
| Endpoint | Impact | Action |
|----------|--------|--------|
| §3.5 GET /me | ✅ Response tambah field | Update docs + Flutter mapper handle nullable |
| §3.2 PUT /profile | ✅ Request+Response tambah field | Update docs + DataSource tambah param |
| §3.3 POST /storage/v1 | ❌ No change | Avatar upload tidak terpengaruh |

---

## Data Layer Changes

### 1. UserModel (`lib/features/auth/data/model/user_model.dart`)

| Change | Detail |
|--------|--------|
| **Field baru** | `final String? phoneNumber;` |
| **fromJson** | `phoneNumber: json['phone_number'] as String?` |
| **toJson** | `'phone_number': phoneNumber` |
| **toEntity** | Pass phoneNumber |
| **fromEntity** | Pass phoneNumber |

### 2. UserEntity (`lib/features/auth/domain/entity/user_entity.dart`)

| Change | Detail |
|--------|--------|
| **Field baru** | `final String? phoneNumber;` |
| **props** | Tambah `phoneNumber` ke list |
| **copyWith** | Tambah `String? phoneNumber` param |
| **mock** | Tambah phoneNumber (nullable, bisa null) |

### 3. ProfileRemoteDataSource (`lib/features/profile/data/datasource/profile_remote_datasource.dart`)

| Change | Detail |
|--------|--------|
| **updateProfile param** | Tambah `String? phoneNumber` |
| **body['phone_number']** | Set jika tidak null |

### 4. ProfileRepository (`lib/features/profile/domain/repository/profile_repository.dart`)

| Change | Detail |
|--------|--------|
| **updateProfile signature** | Tambah `String? phoneNumber` param |

### 5. ProfileRepositoryImpl (`lib/features/profile/data/repository/profile_repository_impl.dart`)

| Change | Detail |
|--------|--------|
| **Pass through** | Pass phoneNumber ke remote.updateProfile |

### Blast Radius — Data Layer
| File | Impact |
|------|--------|
| UserModel | ✅ Field baru, fromJson, toJson, toEntity, fromEntity |
| UserEntity | ✅ Field baru, props, copyWith, mock |
| ProfileRemoteDataSource | ✅ Parameter baru di updateProfile |
| ProfileRepository (interface) | ✅ Parameter baru di updateProfile |
| ProfileRepositoryImpl | ✅ Pass-through parameter |
| UpdateProfileUseCase | ✅ Parameter baru (pass-through) |
| EditProfileCubit | ✅ Parameter baru di event |
| GetProfileUseCase | ❌ No change (read-only, otomatis dapat field baru dari model) |

---

## Presentation Layer Changes

### 1. Profile Page Rewrite — `lib/features/profile/presentation/page/profile_page.dart`

| Change | Detail |
|--------|--------|
| **Layout** | Ganti Column → ListView dengan reusable widgets |
| **Header** | Avatar + overlay edit button + Nama + Phone (ganti nickname + email) |
| **Extract ProfileHeader** | Widget terpisah di `widgets/profile_header.dart` |
| **Extract ProfileMenuTile** | Widget terpisah di `widgets/profile_menu_tile.dart` |
| **Extract LogoutMenuTile** | Widget terpisah di `widgets/logout_menu_tile.dart` |
| **Logout dialog** | Panggil `AppConfirmDialog.show()` dengan params: title='Logout', message='Are you sure...', confirmLabel='Yes, Logout', cancelLabel='Cancel' |
| **Menu labels** | "Notifications", "Help & Support", "Terms & Conditions", "Log Out" |
| **Avatar edit overlay** | Stack: CircleAvatar + Positioned(bottom:0, right:0, child: IconButton) → `context.push(RoutePaths.editProfile)` |
| **Skeleton loading** | Retain skeletonizer — reuse ProfileHeader skeleton |

### 2. Reusable Widgets — `lib/features/profile/presentation/widget/`

#### ProfileHeader
```dart
class ProfileHeader extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onEditAvatar;
  // Stack: CircleAvatar + Positioned edit button
  // Column: Text(name), Text(phoneNumber)
  // Jika phoneNumber null → hidden
}
```

#### ProfileMenuTile
```dart
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  // ListTile dengan leading icon, title, trailing chevron
}
```

#### LogoutMenuTile
```dart
class LogoutMenuTile extends StatelessWidget {
  final VoidCallback onTap;
  // ListTile: red icon (logout), "Log Out" in red, onTap → confirmation dialog
}
```

### 3. EditProfilePage — `lib/features/profile/presentation/page/edit_profile_page.dart`

| Change | Detail |
|--------|--------|
| **Field baru** | Phone number input di bawah Full Name |
| **Validator** | Numeric-only, min 8 digits, max 15 digits, optional |
| **Label** | "Phone Number" |
| **Controller** | Pre-fill dari user.phoneNumber |
| **Submit** | Include phoneNumber di updateProfile call |

### 4. Menu Label Updates (semua pages yang punya referensi)

| File | Current | New |
|------|---------|-----|
| `profile_page.dart` | "Notification" | "Notifications" |
| `profile_page.dart` | "T & C" | "Terms & Conditions" |
| `profile_page.dart` | "Help and Support" | "Help & Support" |
| `profile_page.dart` | "Logout" (button text) | "Log Out" |

### 5. Bottom Navigation — NO CHANGE

- Ikon existing (home, location, calendar2, user) sudah match intent wireframe
- NavigationBar icon-only — tidak ada label yang perlu diubah
- Clarification di ADR sudah cukup

### Blast Radius — Presentation Layer
| File | Impact |
|------|--------|
| profile_page.dart | ✅ Rewrite layout + extract widgets |
| ProfileHeader (new) | ✅ New widget |
| ProfileMenuTile (new) | ✅ New widget |
| LogoutMenuTile (new) | ✅ New widget |
| edit_profile_page.dart | ✅ Tambah field phone number |
| favorite_page.dart | ❌ No change |
| notification_page.dart | ❌ No change |
| settings_page.dart | ❌ No change |
| app_shell.dart | ❌ No change |
| route_paths.dart | ❌ No change |
| app_router.dart | ❌ No change |

---

## Dependency Order

```
Step 1: Migration SQL (016_profile_phone_number.sql)
  │
  ▼
Step 2: UserModel + UserEntity (tambah phoneNumber field)
  │
  ▼
Step 3: Repository interface + impl + datasource (tambah phoneNumber param)
  │
  ▼
Step 4: EditProfileCubit (tambah phoneNumber di updateProfile event)
  │
  ▼
Step 5: Extract reusable widgets (ProfileHeader, ProfileMenuTile, LogoutMenuTile)
  │
  ▼
Step 6: Rewrite profile_page.dart (layout baru + widget substitution)
  │
  ▼
Step 7: Update edit_profile_page.dart (tambah phone input field)
  │
  ▼
Step 8: flutter analyze + fix
  │
  ▼
Step 9: dart run build_runner build --force-jit (jika ada generated files)
  │
  ▼
Step 10: Manual verification (hot reload/restart)
```

---

## Verification

| Check | Command / Method |
|-------|-----------------|
| Static analysis | `flutter analyze` — 0 errors, 0 warnings |
| Codegen | `dart run build_runner build --force-jit` |
| Profile load | Open Profile tab → avatar + name + phone displayed |
| Avatar edit overlay | Tap overlay button → navigate to Edit Profile |
| Edit phone number | Edit Profile → ubah phone → Save → kembali ke Profile → phone updated |
| Logout | Tap "Log Out" → dialog "Logout" → "Yes, Logout" → sign out |
| Logout cancel | Tap "Log Out" → dialog "Logout" → "Cancel" → dialog close |
| Menu navigation | All 6 menu items navigate to correct routes |
| Pull to refresh | Swipe down → profile refreshes |
| Error state | Airplane mode → error section with retry + logout button |
| Skeleton loading | Simulate slow connection → skeleton shown during loading |

---

## Blast Radius Summary

| Layer | Total Files Changed | New Files |
|-------|-------------------|-----------|
| Database (Migration) | 1 | supabase/migrations/016_profile_phone_number.sql |
| API Contract (Docs) | 1 | docs/api_contract/api_contract_health_pal.md |
| Data Layer | 5 | UserModel, UserEntity, remote datasource, repository interface, repository impl |
| Domain (UseCase) | 1 | UpdateProfileUseCase (param pass-through) |
| Presentation — Bloc | 1 | EditProfileCubit (param pass-through) |
| Presentation — Pages | 2 | profile_page.dart (rewrite), edit_profile_page.dart (tambah field) |
| Presentation — Widgets | 3 (new) | ProfileHeader, ProfileMenuTile, LogoutMenuTile |
| Total | ~14 files | 3 new, 11 modified |

---

## Open Questions — Resolved

| # | Question | Decision | Detail |
|---|----------|----------|--------|
| 1 | Format phone display | **Raw** | Tampilkan persis dari DB, no formatting |
| 2 | Phone validation | **Numeric only** | Hanya digit — tidak boleh +, -, spasi |
| 3 | Logout copy konsisten? | **Ya, seragamkan** | SettingsPage logout dialog pakai copy yang sama: title 'Logout', message 'Are you sure you want to log out?', confirmLabel 'Yes, Logout', cancelLabel 'Cancel' |

---

## Todo List — FIX Items

| ID | Deskripsi | File Target | Dependencies |
|----|-----------|-------------|--------------|
| FIX-1 | ✅ Migration SQL: `018_profile_phone_number.sql` — add `phone_number TEXT` to `user_profiles` | `supabase/migrations/018_profile_phone_number.sql` | None |
| FIX-2 | Core Data Model: tambah `phoneNumber` field ke UserEntity + UserModel (fromJson, toJson, toEntity, fromEntity, props, copyWith, mock) | `lib/features/auth/domain/entity/user_entity.dart`, `lib/features/auth/data/model/user_model.dart` | None |
| FIX-3 | Repository Chain: tambah `phoneNumber` param pass-through di ProfileRemoteDataSource.updateProfile → ProfileRepository interface → ProfileRepositoryImpl → UpdateProfileUseCase → EditProfileCubit.updateProfile | `lib/features/profile/data/datasource/profile_remote_datasource.dart`, `lib/features/profile/domain/repository/profile_repository.dart`, `lib/features/profile/data/repository/profile_repository_impl.dart`, `lib/features/profile/domain/usecase/update_profile_usecase.dart`, `lib/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart`, `lib/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart` | FIX-2 |
| FIX-4 | Reusable Widgets: buat 3 widget baru — `ProfileHeader` (avatar + edit overlay + nama + phone), `ProfileMenuTile` (icon + label + chevron), `LogoutMenuTile` (icon merah + "Log Out" merah + confirmation dialog via AppConfirmDialog) | `lib/features/profile/presentation/widget/profile_header.dart`, `lib/features/profile/presentation/widget/profile_menu_tile.dart`, `lib/features/profile/presentation/widget/logout_menu_tile.dart` | None |
| FIX-5 | Profile Page Rewrite: ganti layout sesuai wireframe v2.0 — ProfileHeader di atas, ListView dengan ProfileMenuTile + LogoutMenuTile, menu label updates (Notification→Notifications, T&C→Terms & Conditions, Help→Help & Support, Logout→Log Out), logout via AppConfirmDialog dengan copy baru | `lib/features/profile/presentation/page/profile_page.dart` | FIX-4 |
| FIX-6 | Edit Profile Page: tambah field phone number input di bawah Full Name, validasi numeric-only, pre-fill dari user.phoneNumber, kirim di submit | `lib/features/profile/presentation/page/edit_profile_page.dart` | FIX-3 |
| FIX-7 | Settings Page: unify logout dialog copy — title 'Logout', message 'Are you sure you want to log out?', confirmLabel 'Yes, Logout', cancelLabel 'Cancel' | `lib/features/settings/presentation/page/settings_page.dart` | None |
| FIX-8 | Final Verification: `flutter analyze` (0 issues), `dart run build_runner build --force-jit` | — | All |

---

## Aturan Eksekusi

1. **Satu fix per perintah** — Kerjakan FIX sesuai perintah "fix N" dari user (misal "fix 1", "fix 2", dst). Jangan mengerjakan fix lain yang belum diperintahkan.
2. **Wajib `flutter analyze` 0 issues** — Sebelum menandai FIX selesai, jalankan `flutter analyze`. Jika ada issues, selesaikan dulu. Baru update status FIX.
3. **Checklist + commit setiap fix** — Setiap FIX selesai: update checklist di section Todo List (tandai `✅`), lalu `git add` file-file yang terlibat + `git commit -m "fix(profile): FIX-N — deskripsi singkat"`.
4. **Dilarang membuat file test** — Sesuai Sprint 1 Testing Policy di AGENTS.md: "TIDAK BOLEH membuat file test apapun selama implementasi feature." Test infra yang sudah ada di-skip.
5. **Build runner setelah semua selesai** — `dart run build_runner build --force-jit` hanya dijalankan di FIX-8 (Final Verification), bukan di tiap FIX.
6. **Update doc setelah selesai** — Setelah semua FIX selesai dan lolos `flutter analyze`, update status plan ini ke `✅ Done`.

---

*Dokumen ini adalah living document. Update status dan progress setelah implementasi.*
