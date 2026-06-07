# Sign Up Page

| Field | Detail |
|---|---|
| **Route** | `/sign-up` |
| **Component** | `SignUpPage` |
| **Status** | ✅ Existing |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│                                     │
│          ┌──────────────┐           │
│          │   Logo (108) │           │
│          └──────────────┘           │
│                                     │
│        "Create Account"             │
│      "We are here to help you!"     │
│                                     │
│  ┌─ Name ───────────────────────┐   │
│  │ 👤  Your Name                │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Email ──────────────────────┐   │
│  │ ✉  Your Email               │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Password ───────────────────┐   │
│  │ 🔒  Password           👁️    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │       Create Account        │    │
│  └─────────────────────────────┘    │
│                                     │
│  ────────── or ──────────           │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ [Google icon] Continue w/   │    │
│  │            Google           │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ [Facebook ic] Continue w/   │    │
│  │           Facebook          │    │
│  └─────────────────────────────┘    │
│                                     │
│  Do you have an account?  Sign In   │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Logo | `Image.asset` | Same as Sign In |
| Title | `Text` | `headlineLarge` |
| Subtitle | `Text` | `bodySmall` |
| Name Field | `AppTextFormField` | prefix `Iconsax.user`, required |
| Email Field | `AppTextFormField` | prefix `Iconsax.smsStyle5`, email format |
| Password Field | `AppTextFormField` | prefix `Iconsax.padlockStyle5`, min 8 char |
| Create Account | `LightFilledButton` | Full-width |
| Divider | `Row` + `SizedBox` | "or" |
| Google Button | `LightOutlineButton` | icon Google |
| Facebook Button | `LightOutlineButton` | icon Facebook |
| Sign In Link | `Text.rich` + `TapGestureRecognizer` | Navigate `/sign-in` |
| Form Wrapper | `AppForm` | |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Name field** | User mengetik | Validasi — required |
| **Email field** | User mengetik | Validasi — format email |
| **Password field** | User mengetik | Validasi — min 8 karakter |
| **Tap "Create Account"** | Validasi lolos | `POST /auth/v1/signup` |
| **Tap "Create Account"** | Validasi gagal | Error dialog: "Please correct the highlighted fields" |
| **API: 201 sukses** | Auto | Simpan email/password ke state.extra → push `/sign-up/create-profile` |
| **API: password too short** | Auto | Error: "Password minimal 8 karakter" |
| **API: user already exists** | Auto | Error: "Email sudah terdaftar" |
| **API: network error** | Auto | Snackbar: "Periksa koneksi" |
| **Tap Google** | Tap | OAuth flow |
| **Tap "Sign In"** | Tap link | `context.go('/sign-in')` |

**Data Passing:** Setelah register sukses, email, password, dan name dikirim ke `CreateProfilePage` via `state.extra`.
