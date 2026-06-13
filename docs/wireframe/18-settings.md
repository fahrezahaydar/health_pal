# Settings Page

| Field | Detail |
|---|---|
| **Route** | `/profile/settings` (push) |
| **Component** | `SettingsPage` |
| **Status** | ✅ Existing (enhanced v1.0.1) |

---

## Purpose

Halaman pengaturan aplikasi yang dapat diakses dari menu Profile. Berisi opsi preferensi, maintenance cache, informasi aplikasi, dan link ke T&C serta Help & Support.

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Settings                │
│                                     │
│  ┌─ Akun ────────────────────────┐  │
│  │  🔒 Ubah Password         ▶  │  │
│  │  📧 Email Terdaftar          │  │
│  │     rina@example.com     ✓   │  │
│  ├──────────────────────────────┤   │
│  │  ☎️  Telepon Darurat          │  │
│  │     +62 812-xxxx-xxxx    ▶  │  │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Preferensi ──────────────────┐  │
│  │  🌐 Bahasa                  │  │
│  │     Indonesia           ▶  │  │
│  ├──────────────────────────────┤   │
│  │  🔔 Push Notification     ✅ │  │
│  │  📅 Reminder Booking       ✅ │  │
│  │  📧 Email Notification     ⬜ │  │
│  │  📲 SMS Notification       ⬜ │  │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Data & Cache ───────────────┐  │
│  │  💾 Hapus Cache             │  │
│  │     12.5 MB             [X] │  │
│  ├──────────────────────────────┤   │
│  │  📥 Download Riwayat         │  │
│  │     untuk offline        ⬇  │  │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Aplikasi ───────────────────┐  │
│  │  ℹ️ Versi Aplikasi           │  │
│  │     v1.0.0 (build 1)        │  │
│  ├──────────────────────────────┤   │
│  │  📄 Syarat & Ketentuan    ▶  │  │
│  ├──────────────────────────────┤   │
│  │  🆘 Bantuan & Dukungan    ▶  │  │
│  ├──────────────────────────────┤   │
│  │  🚪 Logout                  │  │
│  │     (merah)                 │  │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Confirmation Dialog — Hapus Cache
```
┌─────────────────────────────────────┐
│  ⚠️  Hapus Cache?                   │
│                                     │
│  Cache sebesar 12.5 MB akan         │
│  dihapus. Data login dan            │
│  appointment tidak akan             │
│  terpengaruh.                       │
│                                     │
│  [ Batal ]    [ Hapus ]             │
└─────────────────────────────────────┘
```

### Confirmation Dialog — Logout
```
┌─────────────────────────────────────┐
│  🚪  Logout?                        │
│                                     │
│  Anda akan keluar dari akun ini.    │
│                                     │
│  [ Batal ]    [ Logout ]            │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Section Header | `Text` | "Akun", "Preferensi", "Data & Cache", "Aplikasi" |
| List Item | `ListTile` atau custom `Row` | Icon + Label + Value/Trailing |
| Toggle Switch | `Switch` / `CupertinoSwitch` | untuk notifikasi |
| Confirmation Dialog | `AppCustomDialog` | Untuk Hapus Cache & Logout |
| Section Divider | `Divider` | Pemisah visual antar section |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap "Ubah Password"** | Tap | Navigasi ke `/sign-in/forgot-password` (reuse flow existing) |
| **Tap "Telepon Darurat"** | Tap | Bottom sheet input nomor → `PATCH /rest/v1/user_profiles` |
| **Tap "Bahasa"** | Tap | Bottom sheet pilihan bahasa (v1.1 — display only di MVP) |
| **Toggle Push Notification** | Toggle | `PATCH /rest/v1/user_profiles?notif_push_enabled` |
| **Toggle Reminder Booking** | Toggle | `PATCH /rest/v1/user_profiles?notif_reminder_enabled` |
| **Toggle Email Notification** | Toggle | (v1.1) — disabled di MVP dengan badge "Coming Soon" |
| **Toggle SMS Notification** | Toggle | (v1.1) — disabled di MVP dengan badge "Coming Soon" |
| **Tap "Hapus Cache"** | Tap | Dialog konfirmasi → `CacheService.clearAll()` + snackbar "Cache dihapus" |
| **Tap "Download Riwayat"** | Tap | Download appointment history untuk offline (v1.1) |
| **Tap "Syarat & Ketentuan"** | Tap | Push `/profile/tnc` |
| **Tap "Bantuan & Dukungan"** | Tap | Push `/profile/help` |
| **Tap "Logout"** | Tap | Dialog konfirmasi → `AppServices.logout()` → redirect `/sign-in` |
| **Tap "Versi Aplikasi"** | Tap (long press) | (Opsional) Trigger debug menu di mode dev |

**BLoC/Cubit:** `SettingsCubit` — states: `SettingsInitial`, `SettingsLoading`, `SettingsLoaded`, `SettingsActionInProgress`, `SettingsError`.

---

## API Endpoints yang Dipakai

| Endpoint | Untuk |
|---|---|
| `GET /rest/v1/me` (lihat API Contract §3.5) | Load email terdaftar + preference saat halaman dibuka |
| `PATCH /rest/v1/user_profiles?auth_id=eq.<auth_uid>` | Update preference notifikasi, telepon darurat |
| `POST /functions/v1/logout` (opsional) | Audit log logout (v1.1) |

---

## Notes

- **Bahasa:** Out of scope MVP (v1.1). Tampil statis "Indonesia" dengan chevron
- **Email/Telepon Darurat:** Read-only di MVP, editable via Profile Edit
- **Ubah Password:** Reuse flow Forgot Password yang sudah ada (User Flow 4.3) — tidak bikin flow baru
- **Hapus Cache:** Aman dilakukan kapan saja, tidak menghapus session Supabase
- **Download Riwayat:** Feature offline-first (v1.1, related to ERD SS sync metadata)
- **Logout:** Ada 2x — di Profile (14) dan Settings (18). Settings lebih cocok karena terkonsolidasi dengan maintenance lainnya

---

## Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Juni 2026 | Initial draft — minimal 4 item |
| v1.0.1 | 13 Jun 2026 | **SS#8 Enhanced:** Tambah section Akun, Preferensi, Data & Cache; tambah confirmation dialog untuk Hapus Cache & Logout; tambah API endpoint references; tambah Toggle notifikasi granular; tambah catatan navigasi |

---

*Wireframe ini adalah bagian dari konsistensi format 21 wireframe health_pal. Lihat `01-onboarding.md` untuk referensi format lengkap.*
