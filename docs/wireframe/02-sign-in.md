# Sign In Page

| Field | Detail |
|---|---|
| **Route** | `/sign-in` |
| **Component** | `SignInPage` |
| **Status** | ✅ Existing (rename from `LoginPage`) |

---

## ASCII Layout

```
┌─────────────────────────────────────┐
│                                     │
│          ┌──────────────┐           │
│          │   Logo (108) │           │
│          └──────────────┘           │
│                                     │
│       "Hi, Welcome Back!"           │
│      "Hope you're doing fine."      │
│                                     │
│  ┌─ Email ──────────────────────┐   │
│  │ ✉  Your Email                │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Password ───────────────────┐   │
│  │ 🔒  Password           👁️    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │         Sign In             │    │
│  └─────────────────────────────┘    │
│                                     │
│  ────────── or ──────────           │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ [Google icon] Sign in w/   │    │
│  │            Google           │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ [Facebook ic] Sign in w/   │    │
│  │           Facebook          │    │
│  └─────────────────────────────┘    │
│                                     │
│          "Forgot password?"         │
│                                     │
│  Don't have an account?  Sign up    │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Logo | `Image.asset` | `assets/logo-dark.png`, 108x108 |
| Title | `Text` | `headlineLarge`, `primary` |
| Subtitle | `Text` | `bodySmall`, `grey500` |
| Email Field | `AppTextFormField` | prefix `Iconsax.smsStyle5`, email keyboard |
| Password Field | `AppTextFormField` | prefix `Iconsax.padlockStyle5`, toggle visibility |
| Sign In Button | `LightFilledButton` | Full-width |
| Divider | `Row` + `SizedBox` | "or" text between lines |
| Google Button | `LightOutlineButton` | icon `assets/icon/google.png` |
| Facebook Button | `LightOutlineButton` | icon `assets/icon/facebook.png` |
| Forgot Password | `GestureDetector` → `Text` | Navigate `/sign-in/forgot-password` |
| Sign Up Link | `Text.rich` + `TapGestureRecognizer` | Navigate `/sign-up` |
| Form Wrapper | `AppForm` | `AppFormState` global key |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Email field** | User mengetik | Validasi `onUserInteraction` — format email |
| **Password field** | User mengetik | Validasi — required, min 8 char |
| **Show/hide password** | Tap icon 👁️ | `_isShowPassword` toggle → `isPassword` negasi |
| **Tap "Sign In"** | Tap button → email+password valid | Loading dialog → `POST /auth/v1/token` |
| **Tap "Sign In"** | Validasi gagal | Error per field ditampilkan |
| **API: invalid_credentials** | Auto | Snackbar: "Email atau password salah" |
| **API: email_not_confirmed** | Auto | Dialog: "Verifikasi email dulu" |
| **API: network error** | Auto | Snackbar: "Periksa koneksi internet" |
| **Tap Google** | Tap button | `supabase.auth.signInWithOAuth(Google)` |
| **Tap Facebook** | Tap button | Snackbar: "Fitur belum tersedia" (v1.0) |
| **Tap "Forgot password?"** | Tap text | `context.go('/sign-in/forgot-password')` |
| **Tap "Sign up"** | Tap link | `context.go('/sign-up')` |

**State Management:** `AppServices.login()` dipanggil setelah auth sukses → mengubah `AppStatus` ke `authenticated` → GoRouter redirect ke `/home` (atau `/sign-up/create-profile` jika `is_profile_complete = false`).
