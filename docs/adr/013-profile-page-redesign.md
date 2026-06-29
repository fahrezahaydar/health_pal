# ADR 013: Profile Page Redesign v2.0

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 30 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | UI (profile_page.dart rewrite), widget (extract ProfileHeader, ProfileMenuTile, LogoutMenuTile), data layer (add phone_number ke UserModel/UserEntity), DB (migration add phone_number ke user_profiles), API Contract (§3.2 PUT /profile, §3.5 GET /me), wireframe v2.0 |

---

## 1. Konteks

Wireframe Profile Page v1.0 (docs/wireframe/14-profile.md) mendefinisikan layout dengan:

- Avatar + nama lengkap + @nickname + email di header
- Menu list: Edit Profile, Favorite, Notification, Settings, Help and Support, T & C, Logout
- Logout dialog via AppConfirmDialog
- Bottom navigation icon-only

Wireframe baru (v2.0) mengubah layout secara fundamental:

- **Header**: Avatar dengan overlay edit button, full name, **phone number** (menggantikan nickname + email)
- **Menu labels**: "Notifications" (plural), "Help & Support" (dengan &), "Terms & Conditions" (spelled out), "Log Out" (dengan spasi)
- **Logout dialog**: Wireframe spesifik menampilkan layout "Logout" title + "Are you sure you want to log out?" message + "Cancel" / "Yes, Logout" buttons
- **Bottom navigation labels**: Wireframe menyebut "Home/Location/Calendar/Profile" — untuk klarifikasi vs implementasi aktual
- **Reusable widgets**: Wireframe menyarankan ekstraksi ProfileHeader, ProfileMenuTile, LogoutMenuTile

### Kondisi Saat Ini

| Aspek | Kondisi |
|---|---|
| **profile_page.dart** | ✅ Implementasi v1.0: user card (avatar + nama + nickname + email), menu list inline, logout via AppConfirmDialog, skeletonizer loading |
| **EditProfilePage** | ✅ Implementasi v1.0: form edit nama, nickname, tanggal lahir, gender, avatar |
| **FavoritePage** | ✅ Placeholder v1.1 (backend belum ada) |
| **NotificationPage** | ✅ Implementasi penuh dengan data real dari tabel notifications |
| **SettingsPage** | ✅ Implementasi penuh (toggle notif, emergency phone, cache, dll) |
| **Logout** | ✅ AppConfirmDialog.show(title: "Yakin ingin logout?", message: "Kamu akan keluar dari akun ini.", confirmLabel: "Logout") |
| **UserEntity / UserModel** | ✅ FullName, email, nickname, avatarUrl, dateOfBirth, gender — **TIDAK** ada phoneNumber |
| **UserProfiles table** | ✅ columns: id, auth_id, full_name, nickname, avatar_url, date_of_birth, gender, notif_reminder_enabled, is_profile_complete — **TIDAK** ada phone_number |
| **API §3.5 GET /me** | ✅ return: id, auth_id, full_name, nickname, avatar_url, date_of_birth, gender, notif_reminder_enabled, is_profile_complete — **TIDAK** ada phone_number |
| **API §3.2 PUT /profile** | ✅ request fields: full_name, nickname, date_of_birth, gender, avatar_url — **TIDAK** ada phone_number |
| **Bottom nav icons** | ✅ AppIcons.home, AppIcons.location, AppIcons.calendar2, AppIcons.user (icon-only, no labels) |
| **Reusable widgets** | ❌ Belum ada ProfileHeader, ProfileMenuTile, LogoutMenuTile — semua inline di profile_page.dart |
| **BUG-002-FIX-3** | ⏳ Deferred: try/catch di ProfileCubit.loadProfile (Sprint 2 — A7) |

---

## 2. Opsi yang Dipertimbangkan

### 2A: Phone Number — Field Baru

#### Opsi A1: Tambah phone_number ke user_profiles (DIUSULKAN)

Tambah kolom `phone_number TEXT` ke tabel `user_profiles`, update UserModel/UserEntity, API contract, profile header display, dan edit profile form.

**Pro:**
- Data tersimpan di database (persistent, queryable)
- Satu source of truth — tidak duplikasi dengan emergency_phone di SharedPreferences
- Bisa digunakan untuk notifikasi SMS di masa depan
- Konsisten dengan wireframe yang menampilkan nomor telepon sebagai identitas user

**Kontra:**
- Perlu migration SQL
- Perlu update API contract (request/response shape)
- Breaking change untuk UserModel dan UserEntity
- Create Profile flow mungkin perlu ditambah field phone (opsional)

#### Opsi A2: Gunakan emergency_phone dari Settings (SharedPreferences)

Tampilkan nomor telepon dari SharedPreferences (emergency_phone yang sudah ada di SettingsCubit).

**Pro:**
- Zero DB change — field sudah ada di Settings
- Zero API change
- Zero data layer change

**Kontra:**
- ❌ Emergency phone adalah kontak darurat, bukan nomor pribadi user — semantic mismatch
- ❌ Data hanya lokal — tidak sync antar device
- ❌ Belum tentu diisi user (opsional di Settings)
- ❌ Tidak sesuai wireframe yang menampilkan nomor pribadi +123 856479683 sebagai identitas

### 2B: Logout Dialog — Reuse vs New Widget

#### Opsi B1: Reuse AppConfirmDialog dengan parameter berbeda (DIUSULKAN)

`AppConfirmDialog` sudah mendukung title, message, confirmLabel, cancelLabel sebagai parameter. Cukup panggil dengan nilai wireframe:
```dart
AppConfirmDialog.show(
  context,
  title: 'Logout',
  message: 'Are you sure you want to log out?',
  confirmLabel: 'Yes, Logout',
  cancelLabel: 'Cancel',
)
```

**Pro:**
- ✅ DRY — reuse widget existing yang sudah established
- ✅ Konsisten dengan pattern penggunaan AppConfirmDialog di SettingsPage
- ✅ Zero new widget — tidak perlu maintenance tambahan
- ✅ Wireframe dialog layout cocok dengan AlertDialog bawaan

**Kontra:**
- ⚠️ Button order: AppConfirmDialog pakai Cancel → Confirm (wireframe juga Cancel → Yes,Logout) — match
- ⚠️ AppConfirmDialog pakai LightOutlineButton + LightFilledButton — match dengan wireframe OutlinedButton + FilledButton

#### Opsi B2: Widget LogoutDialog baru

Buat `LogoutDialog` widget khusus di `profile/widgets/logout_menu_tile.dart` atau `widgets/dialog/logout_dialog.dart`.

**Pro:**
- Bisa kustomisasi layout eksklusif untuk logout (misal icon logout di title)
- Wireframe compliance exact

**Kontra:**
- ❌ Duplikasi dengan AppConfirmDialog yang sudah punya semua parameter
- ❌ Maintenance overhead — perubahan style dialog harus sync manual
- ❌ Tidak konsisten dengan pattern dialog yang sudah established (SettingsPage, EditProfile success/error)

### 2C: Avatar Edit — Interaksi

#### Opsi C1: Overlay button navigate to Edit Profile (DIUSULKAN)

Stack avatar dengan Positioned IconButton overlay di pojok kanan bawah. Tap → navigate ke EditProfilePage (sama dengan tap "Edit Profile" menu item).

**Pro:**
- ✅ Konsisten — satu entry point untuk edit profile (baik dari overlay maupun menu)
- ✅ Implementasi sederhana — reuse EditProfilePage yang sudah ada
- ✅ UX jelas — user tahu akan diedit di halaman terpisah
- ✅ Wireframe menunjukkan "◉ Edit" — ini adalah navigasi action, bukan picker langsung

**Kontra:**
- ⚠️ Butuh satu tap tambahan dibanding picker langsung

#### Opsi C2: Overlay button langsung buka image picker

Tap overlay → bottom sheet: Kamera/Galeri/Hapus — langsung upload avatar.

**Pro:**
- Fast path untuk ganti foto

**Kontra:**
- ❌ Tidak konsisten — Edit Profile menu item akan membawa ke form yang juga ada avatar pickernya
- ❌ Dua entry point dengan behavior berbeda membingungkan user
- ❌ Wireframe menunjukkan "◉ Edit" tanpa spesifikasi bahwa ini image picker eksklusif

### 2D: Bottom Navigation Label — Wireframe vs Implementasi

#### Opsi D1: Dokumentasi sebagai referensi visual saja (DIUSULKAN)

Wireframe menyebut "Home/Location/Calendar/Profile" tapi implementasi menggunakan icon-only NavigationBar dengan ikon home/location/calendar2/user. Karena tidak ada label tekstual yang ditampilkan, perbedaan istilah ini murni dokumentasi. Cukup dicatat sebagai clarification di ADR.

**Pro:**
- ✅ Zero code change
- ✅ Ikon sudah match intent: home=🏠, location=📍, calendar2=📅, user=👤
- ✅ Route actual: Home, Loc, Booking History, Profile — konsisten dengan PRD §5

**Kontra:**
- ⚠️ Jika di masa depan label ditampilkan, "Calendar" tidak sama dengan "Booking History"

### 2E: Profile Header — Field yang Ditampilkan

#### Opsi E1: Ganti nickname + email dengan phone number (DIUSULKAN)

Header menampilkan: Avatar (+ overlay edit), Nama, Phone Number. Email dan nickname dipindah ke dalam Edit Profile form atau dihilangkan.

**Pro:**
- ✅ Wireframe compliance exact
- ✅ Phone number lebih relevan untuk kontak daripada nickname
- ✅ Email sudah visible di Edit Profile (read-only field)

**Kontra:**
- ⚠️ Kehilangan nickname — greeting di Home ("Halo, {nickname}!") tetap pakai nickname dari data yang sama
- ⚠️ Kehilangan email dari header — user harus buka Edit Profile untuk lihat email

### 2F: Reusable Widgets

#### Opsi F1: Extract ProfileHeader, ProfileMenuTile, LogoutMenuTile (DIUSULKAN)

Pisahkan bagian-bagian ProfilePage menjadi widget terpisah di `lib/features/profile/presentation/widget/`.

**Pro:**
- ✅ Maintainability — setiap widget punya tanggung jawab terpisah
- ✅ Testability — widget bisa di-test independently
- ✅ Wireframe compliance — wireframe v2.0 secara eksplisit menyarankan reusable widgets
- ✅ Konsisten dengan pattern DoctorCard, AppointmentCard, ClinicCard yang sudah standalone

**Kontra:**
- ⚠️ Perlu refactor profile_page.dart yang saat ini inline semua

---

## 3. Keputusan

**Pilih:**
- **Phone Number**: **Opsi A1** — Tambah `phone_number` ke `user_profiles`, data layer, API
- **Logout Dialog**: **Opsi B1** — Reuse `AppConfirmDialog` dengan parameter berbeda
- **Avatar Edit**: **Opsi C1** — Overlay button → navigasi ke EditProfilePage
- **Bottom Navigation**: **Opsi D1** — Dokumentasi referensi visual, clarification tanpa code change
- **Profile Header**: **Opsi E1** — Avatar + Nama + Phone (ganti nickname + email)
- **Reusable Widgets**: **Opsi F1** — Extract ProfileHeader, ProfileMenuTile, LogoutMenuTile

### Detail Keputusan

1. **Phone Number (`phone_number`)**:
   - Tambah field `phoneNumber` di UserEntity, UserModel, dan UserModel.toJson/fromJson
   - Migration SQL: `ALTER TABLE user_profiles ADD COLUMN phone_number TEXT;`
   - API §3.5 GET /me: tambah field `phone_number` di response
   - API §3.2 PUT /profile: tambah field `phone_number` di request body (opsional, partial update)
   - Profile header: tampilkan `phoneNumber` setelah nama
   - Edit Profile form: tambah field phone number input
   - **Create Profile (onboarding)**: **DEFER** — tidak tambah field di form Create Profile untuk saat ini. Phone number cukup diisi via Edit Profile. Evaluasi di sprint mendatang jika perlu dikoleksi saat onboarding.
   - **Emergency Phone di Settings**: RETAIN — tetap ada sebagai fitur terpisah (kontak darurat, bukan nomor pribadi). Keduanya coexist.

2. **Logout Dialog**:
   - `AppConfirmDialog.show()` dengan parameter:
     - `title: 'Logout'`
     - `message: 'Are you sure you want to log out?'`
     - `confirmLabel: 'Yes, Logout'`
     - `cancelLabel: 'Cancel'`
   - **Tidak perlu widget LogoutDialog baru** — AppConfirmDialog sudah mencakup semua kebutuhan.
   - Pattern sama persis dengan yang sudah dipakai di SettingsPage.
   - Jika di masa depan butuh kustomisasi layout (icon logout, dll), cukup tambah parameter `icon` ke AppConfirmDialog — bukan buat widget baru.

3. **Avatar Edit Overlay**:
   - Stack: CircleAvatar + Positioned(bottom: 0, right: 0, child: CircleAvatar(IconButton(icon: edit)))
   - Tap overlay → `context.push(RoutePaths.editProfile)`
   - Tidak langsung open image picker — konsisten dengan Edit Profile sebagai halaman terpisah

4. **Bottom Navigation Label Clarification**:
   - Wireframe menggunakan istilah "Home/Location/Calendar/Profile" sebagai referensi visual
   - Implementasi aktual: icon-only NavigationBar dengan ikon home/location/calendar2/user
   - Route aktual: Home, Loc (Search by Location), Booking History, Profile
   - **Tidak perlu perubahan kode** — ikon sudah match intent wireframe
   - **Catatan untuk dokumentasi masa depan**: Jika label ditambahkan ke NavigationBar, gunakan label aktual (Home, Loc, History, Profile) — bukan "Calendar" dan "Location" dari wireframe

5. **Menu Label Updates**:
   - "Notification" → "Notifications" (plural)
   - "T & C" → "Terms & Conditions" (spelled out)
   - "Help and Support" → "Help & Support" (dengan ampersand)
   - "Logout" → "Log Out" (dengan spasi)
   - Icon mapping: gunakan AppIcons yang sudah ada (person, favorite, notification, settings, help, description, logout)

6. **Reusable Widgets**:
   - `ProfileHeader`: Stack avatar + edit overlay + Column(nama, phone). Props: UserEntity + onEditTap
   - `ProfileMenuTile`: ListTile dengan leading icon, title, trailing chevron. Props: icon, label, onTap
   - `LogoutMenuTile`: ListTile dengan leading logout icon, title "Log Out", red text, red border. onTap → show AppConfirmDialog → logout
   - Tidak perlu `ProfileAvatar` terpisah — cukup inline di ProfileHeader

### Out of Scope (ADR Ini)

1. **Phone Number di Create Profile flow** — Tidak ditambahkan ke form onboarding. User mengisi phone number via Edit Profile setelah login. Keputusan ini untuk meminimalkan perubahan di flow autentikasi yang sudah stabil.

2. **Favorite backend table** — Favorites tetap placeholder v1.1. Tidak ada perubahan di ADR ini.

3. **Reschedule / Change Date** — Tidak relevan dengan Profile Page.

4. **BUG-002-FIX-3** (try/catch di ProfileCubit.loadProfile) — Sudah di-defer ke Sprint 2 — A7. ADR ini tidak mengubah cubit logic, hanya UI layout.

5. **Notification toggle di menu** — Wireframe v1.0 memiliki toggle notification di menu, tapi v2.0 menghilangkannya (notification menjadi menu item push biasa). Settings page tetap memiliki toggle notification. Tidak perlu perubahan.

---

## 4. Alasan

1. **Phone number sebagai field baru** — Wireframe v2.0 secara eksplisit menampilkan nomor telepon sebagai identitas user di header. Ini adalah data yang berbeda dari emergency_phone (Settings). Menambahkannya ke user_profiles adalah satu-satunya cara yang tepat untuk persistensi dan konsistensi data.

2. **Reuse AppConfirmDialog** — Widget sudah matang, punya parameter lengkap, dan sudah dipakai di SettingsPage. Membuat LogoutDialog baru akan melanggar DRY dan menambah maintenance overhead tanpa benefit signifikan.

3. **Avatar overlay → Edit Profile** — Konsisten dengan satu entry point. User tidak bingung antara "overlay untuk ganti foto" dan "menu item untuk edit semua data".

4. **Extract reusable widgets** — Profile_page.dart saat ini inline-heavy (~200 lines). Extract widgets mengikuti pattern DoctorCard, AppointmentCard, ClinicCard yang sudah established. Memudahkan testing dan maintenance.

5. **Bottom navigation clarification** — Menghindari kebingungan di masa depan ketika developer membaca wireframe dan melihat "Calendar" vs implementasi "Booking History". Keputusan eksplisit bahwa wireframe adalah referensi visual, bukan spesifikasi label literal.

---

## 5. Konsekuensi

### Positif

- ✅ Profile header lebih clean — hanya nama + nomor telepon
- ✅ Phone number tersimpan di database — persistent, bisa digunakan untuk notifikasi future
- ✅ Logout dialog konsisten dengan pattern existing
- ✅ Reusable widgets memudahkan testing dan maintenance
- ✅ Avatar edit button memberikan akses cepat ke Edit Profile
- ✅ Menu labels lebih eksplisit (Terms & Conditions, Notifications, Log Out)

### Negatif

- ⚠️ **Breaking change data layer** — UserModel, UserEntity, toJson/fromJson perlu update
- ⚠️ **Migration SQL** — Tambah kolom ke tabel user_profiles yang sudah production (perlu careful)
- ⚠️ **API Contract update** — Response GET /me dan request PUT /profile berubah
- ⚠️ **Edit Profile form perlu field baru** — Input phone number + validasi
- ⚠️ **Kehilangan email dari header** — User harus tap Edit Profile untuk lihat email
- ⚠️ **Kehilangan nickname dari header** — Home greeting tetap pakai nickname dari data yang ada

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| Phone number diisi dengan format tidak konsisten | Tambah validasi di form (numeric only + min/max digits) |
| Migration `ADD COLUMN NOT NULL` gagal karena existing data | Gunakan `ADD COLUMN ... DEFAULT NULL` (nullable) |
| User memiliki nomor lama tapi sudah diganti | Edit Profile bisa update kapan saja |
| Logout dialog berbeda dengan SettingsPage | Konsisten — keduanya pakai AppConfirmDialog dengan parameter sama. SettingsPage bisa diupdate ke parameter yang sama untuk konsistensi. |
| Notification toggle hilang dari menu | Tetap ada di Settings page. Profile menu cukup navigasi ke Notification page. |

---

## 6. Compliance

| Mekanisme | Detail |
|---|---|
| **Wireframe** | docs/wireframe/14-profile.md — v2.0 (baru) |
| **ADR ini** | Dokumen keputusan arsitektur |
| **Plan** | docs/progress/profile_page_redesign_plan.md |
| **Code Review** | WAJIB cek: (1) phone_number di UserEntity/UserModel, (2) migration SQL, (3) API contract sync, (4) ProfileHeader reuse widget, (5) logout via AppConfirmDialog (bukan widget baru), (6) avatar overlay button, (7) menu label updates |
| **Skeletonizer (ADR-001)** | Loading state wajib pakai Skeletonizer + reuse production widget |
| **CachedNetworkImage (ADR-006)** | Avatar wajib pakai AppNetworkImage (sudah existing) |
| **Reusable Widgets (ADR-008)** | ProfileHeader, ProfileMenuTile, LogoutMenuTile wajib reuse pattern yang ada |

---

## 7. Referensi

- Wireframe: docs/wireframe/14-profile.md — v2.0 (new)
- Wireframe old: docs/wireframe/14-profile.md — v1.0 (superseded)
- ADR 001: Skeletonizer - loading standard
- ADR 006: CachedNetworkImage - image loading standard
- ADR 008: Standard Placeholder Widgets
- ADR 012: Appointment Card Redesign - pattern reference
- ERD: docs/erd/erd_healh_pal.md - user_profiles table
- API Contract: docs/api_contract/api_contract_health_pal.md - §3.2, §3.5
- PRD: docs/product/prd_health_pal.md - §6.7 Profile Tab, §6.1 Onboarding
- Bug: docs/bug/BUG-002-profile.md - profile bug history
- Sprint Progress: docs/progress/sprint_progress.md - profile status
- Existing Page: lib/features/profile/presentation/page/profile_page.dart
- Existing Entity: lib/features/auth/domain/entity/user_entity.dart
- Existing Model: lib/features/auth/data/model/user_model.dart
- Existing Dialog: lib/widgets/dialog/app_confirm_dialog.dart
- Existing Shell: lib/widgets/app_shell.dart
- Existing Router: lib/core/router/route_paths.dart
- Plan: docs/progress/profile_page_redesign_plan.md

---

## 8. Implementation Plan (Ringkas)

| Step | Task | Dependencies |
|------|------|-------------|
| 1 | Migration SQL: ADD COLUMN phone_number | None |
| 2 | Update API Contract §3.2 + §3.5 | Step 1 |
| 3 | Update UserModel (fromJson/toJson + phoneNumber) | Step 1 |
| 4 | Update UserEntity (props + copyWith) | Step 3 |
| 5 | Update ProfileRepository / DataSource (updateProfile param) | Step 3 |
| 6 | Extract reusable widgets (ProfileHeader, ProfileMenuTile, LogoutMenuTile) | None |
| 7 | Rewrite profile_page.dart (new layout) | Step 4, 6 |
| 8 | Update EditProfilePage (phone field + avatar overlay target) | Step 4 |
| 9 | Update menu labels across pages | None |
| 10 | Flutter analyze + fix | All steps |
| 11 | Verify seed.sql + storage mapping | Step 1 |

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi Superseded jika ADR baru menggantikan keputusan ini.*
