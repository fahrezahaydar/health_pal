# Forgot Password Page (3-Step)

| Field | Detail |
|---|---|
| **Route** | `/sign-in/forgot-password` |
| **Component** | `ForgotPasswordPage` |
| **Status** | ✅ Existing (step state via `ForgotPasswordCubit`) |

---

## ASCII Layout (Step 1 — Email Input)

```
┌─────────────────────────────────────┐
│ ← (back arrow)     Logo (108)       │
│                                     │
│       "Forget Password?"            │
│      "Hope you're doing fine."      │
│                                     │
│  ┌─ Email ──────────────────────┐   │
│  │ ✉  Your Email               │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │         Send Code           │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

## ASCII Layout (Step 2 — Verify Code)

```
┌─────────────────────────────────────┐
│ ← (back)          Logo (108)        │
│                                     │
│         "Verify Code"               │
│  "Enter the code we just sent you   │
│       on your registered Email"     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  [_][_][_][_][_] (5 digit)  │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │        Verify Code          │    │
│  └─────────────────────────────┘    │
│                                     │
│  Didn't get the Code?  Resend       │
└─────────────────────────────────────┘
```

## ASCII Layout (Step 3 — Create New Password)

```
┌─────────────────────────────────────┐
│ ← (back)          Logo (108)        │
│                                     │
│      "Create new password"          │
│  "Your new password must be diff-   │
│   erent from previously used pwd."  │
│                                     │
│  ┌─ New Password ───────────────┐   │
│  │ 🔒  Password           👁️    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─ Confirm New Password ───────┐   │
│  │ 🔒  Confirm Password    👁️    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐    │
│  │        Reset Password       │    │
│  └─────────────────────────────┘    │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Step | Component | Widget |
|---|---|---|
| **All** | Back Button | `GestureDetector` → `Icon(Iconsax.arrowLeft01Style4)` |
| **All** | Logo | `Image.asset` |
| **1** | Email Field | `AppTextFormField`, email keyboard |
| **1** | Send Code Button | `LightFilledButton` |
| **2** | OTP Field | `AppFormPinField`, length 5 |
| **2** | Verify Button | `LightFilledButton` |
| **2** | Resend Link | `Text.rich` + `TapGestureRecognizer` |
| **3** | New Password | `AppTextFormField`, toggle visibility |
| **3** | Confirm Password | `AppTextFormField`, toggle visibility |
| **3** | Reset Button | `LightFilledButton` |
| **All** | Loading Dialog | `AppLoadingDialog` |

---

## State & Interaction Specs

| Step | Elemen | Interaksi | Efek |
|---|---|---|---|
| 1 | **Back** | Tap | `ForgotPasswordCubit.back()` (step awal → pop) |
| 1 | **Email field** | Mengetik | Validasi format email |
| 1 | **Tap "Send Code"** | Valid lolos | Loading → `POST /auth/v1/recover` → step 2 |
| 1 | **Tap "Send Code"** | Valid gagal | Error: "Format email tidak valid" |
| 2 | **OTP field** | Mengetik | 5 digit angka |
| 2 | **Tap "Verify Code"** | OTP = 5 digit | Verify OTP → sukses: step 3, gagal: error |
| 2 | **Tap "Resend"** | Tap | `POST /auth/v1/recover` ulang |
| 2 | **Tap back** | Step 2 → Step 1 | `ForgotPasswordCubit.back()` |
| 3 | **New Password** | Mengetik | Min 8 karakter |
| 3 | **Confirm Password** | Mengetik | Harus sama dengan New Password |
| 3 | **Tap "Reset Password"** | Valid lolos | Loading → reset API |
| 3 | **Tap "Reset Password"** | Password != Confirm | Error: "Konfirmasi password tidak cocok" |
| 3 | **API sukses** | Auto | Popup sukses → `context.pop()` → `/sign-in` |
| 3 | **Tap back** | Step 3 → Step 2 | `ForgotPasswordCubit.back()` |

**State Management:** `ForgotPasswordCubit` (flutter_bloc Cubit) dengan 3 step enum: `initial` → `verify` → `newPassword`. Masing-masing method (`sendEmail`, `verifyCode`, `resetPassword`) saat ini masih menggunakan `Future.delayed(5s)` — belum terhubung ke API nyata.
