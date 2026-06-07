# Create Profile — Fill Profile Page

| Field | Detail |
|---|---|
| **Route** | `/sign-up/create-profile` |
| **Component** | `CreateProfilePage` |
| **Status** | ✅ Existing (Form UI, submit masih stub) |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back arrow)                      │
│                                     │
│                                     │
│         ┌──────────────┐            │
│         │   Avatar     │            │
│         │   Circle     │            │
│         │   (160px)    │            │
│         │   [📷]       │            │
│         └──────────────┘            │
│                                     │
│  ┌─ Name ───────────────────────┐   │
│  │  Your Name                   │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Email ──────────────────────┐   │
│  │  Your Email                  │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Nickname ───────────────────┐   │
│  │  Your Nickname               │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Gender ─────────────────────┐   │
│  │  Pilih Gender          ▼     │   │
│  └──────────────────────────────┘   │
│                                     │
│                                     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │        Save Profile         │    │
│  └─────────────────────────────┘    │
│                                     │
│  (↓ Dialog Loading saat tap Save)   │
│  ┌─────────────────────────────┐    │
│  │      ┌─────┐               │    │
│  │      │ ● ● │  Loading...   │    │
│  │      └─────┘               │    │
│  │   "Menyimpan profil..."    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `Iconsax.arrowLeft01Style4` |
| Avatar Picker | `AppPhotoPicker` | 160px, camera/gallery/delete bottom sheet |
| Name Field | `AppTextFormField` | Pre-filled dari Sign Up, editable |
| Email Field | `AppTextFormField` | Pre-filled, readonly |
| Nickname Field | `AppTextFormField` | Required |
| Gender Dropdown | `AppDropdownFormField<String>` | Laki-Laki / Perempuan |
| Save Button | `LightFilledButton` | "Save Profile" |
| Loading Dialog | `AppLoadingDialog` | Overlay dot loader |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap back arrow** | Tap | Konfirmasi dialog "Kembali ke Sign Up?" → ya: pop, tidak: tetap |
| **Tap avatar** | Tap | `AppPhotoPicker` bottom sheet: Kamera / Galeri / Hapus |
| **Pick photo** | Kamera/Galeri | `ImagePicker` → file disimpan di `_localPhoto` state |
| **Remove photo** | Tap "Hapus" | `_localPhoto = null` |
| **Fill Name** | Mengetik | Required validation |
| **Fill Nickname** | Mengetik | Required validation |
| **Select Gender** | Tap dropdown | Pilih Laki-Laki / Perempuan |
| **Tap "Save Profile"** | Validasi lolos | `AppLoadingDialog.show()` → `POST /rest/v1/user_profiles` |
| **Tap "Save Profile"** | Validasi gagal | Highlight error fields, tetap di halaman |
| **API: 201 sukses** | Auto | `AppLoadingDialog.dismiss()` → `AppServices.login()` → redirect `/home` |
| **API: error** | Auto | `AppLoadingDialog.dismiss()` → Snackbar "Gagal simpan profil" |

**⚠️ Missing (stub):** `_onSave()` di `CreateProfilePage` belum terimplementasi — form fields sudah ada, method submit masih kosong.
