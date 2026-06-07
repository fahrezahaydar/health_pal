# Edit Profile Page

| Field | Detail |
|---|---|
| **Route** | `/profile/edit` (push) |
| **Component** | `EditProfilePage` |
| **Status** | 🔧 Proposed |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│ ← (back)    Edit Profile            │
│                                     │
│                                     │
│         ┌──────────────┐            │
│         │   Avatar     │            │
│         │   (120px)    │            │
│         │   [📷]       │            │
│         └──────────────┘            │
│                                     │
│  ┌─ Full Name ──────────────────┐   │
│  │  Rina Kartika                │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Nickname ───────────────────┐   │
│  │  @rina                       │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Email ──────────────────────┐   │
│  │  rina@example.com    (read)  │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Date of Birth ──────────────┐   │
│  │  15 Maret 1998          [📅] │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Gender ─────────────────────┐   │
│  │  Perempuan              ▼    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │          Save               │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Back Button | `GestureDetector` → `Icon` | `context.pop()` |
| Avatar Picker | `AppPhotoPicker` | Sama seperti Create Profile |
| Name Field | `AppTextFormField` | Required |
| Nickname Field | `AppTextFormField` | Required |
| Email Field | `AppTextFormField` | Read-only, disabled |
| Date of Birth | `AppDatePickerFormField` | Tap → date picker dialog |
| Gender | `AppDropdownFormField<String>` | Laki-Laki / Perempuan |
| Save Button | `LightFilledButton` | `PATCH /rest/v1/user_profiles` |
| Loading | `AppLoadingDialog` | During API call |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Tap avatar** | Tap | Bottom sheet: Kamera / Galeri / Hapus |
| **Edit name/nickname** | Mengetik | Validasi required |
| **Tap date of birth** | Tap | `showDatePicker` dialog |
| **Select gender** | Tap dropdown | Pilih opsi |
| **Tap "Save"** | Valid lolos | Loading → `PATCH /rest/v1/user_profiles` → sukses: pop + snackbar |
| **Tap "Save"** | Valid gagal | Error per field |
| **API error** | Auto | Snackbar: "Gagal simpan profil" |

**BLoC:** `EditProfileCubit` — states: `loading(initialData)`, `loaded`, `saving`, `saved`, `error`.
