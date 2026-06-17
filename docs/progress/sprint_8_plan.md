# Sprint 8 Plan — Auth + Onboarding + FCM

| Field | Detail |
|---|---|
| **Tanggal** | 16 Juni 2026 |
| **Tema** | **"Auth Ecosystem — Final Polish + Icon Reference"** |
| **Acuan** | `onboarding_auth_fcm_audit.md` · wireframe 01-05, 17 · api_contract §2 |

---

## 📊 Progress Tracker

| Task | Audit Ref | Estimasi | Status |
|------|-----------|:--------:|--------|
| A1 | Sprint Opening Audit → `onboarding_auth_fcm_audit.md` | — | ✅ Done |
| A2 | Skeletonizer — loading states (login, create-profile) | K1 | 1.5h |
| A3 | ErrorSection — login error display | K2 | 0.5h |
| A4 | Icon consistency: iconsax → Material + TODO | K3 | 2h |
| A5 | Onboarding page audit + polish | L1 | 0.5h |
| A6 | Icon reference table `docs/reference/icons.md` | D7 | 1.5h |
| A7 | Final QA + flutter analyze | — | 1h |

**Total:** ~7h

**Skipped:**
- M1 (forgot password step indicator) — wireframe sudah OK
- M2 (Google/Facebook login) — placeholder v1.1
- M3 (FCM notification nav) — Sprint 9 testing

---

## Task Details

#### A2 Skeletonizer (1.5h)
Ganti `AppLoadingDialog` / loading indicator dengan `Skeletonizer` di:
- `login_page.dart` — skeleton form saat `SignInLoading`
- `create_profile_page.dart` — skeleton form saat `CreateProfileLoading`

#### A3 ErrorSection (0.5h)
Ganti error text di `login_page.dart` (`BlocBuilder` → `Text(state.message)`) dengan `ErrorSection`.

#### A4 Icon Consistency (2h)
Replace `Iconsax.*` dengan `Icons.*` + `// TODO: change to iconsax` di:
- `sign_up_page.dart`
- `login_page.dart`
- `forgot_password_page.dart`
- `create_profile_page.dart`
- `onboarding_page.dart`
- Hapus import `iconsax_latest` setelah semua icon diganti

#### A5 Onboarding Polish (0.5h)
Verifikasi onboarding page sesuai wireframe 01. Minor polish jika ada gap.

#### A6 Icon Reference Table (1.5h)
Buat `docs/reference/icons.md` — mapping semua icon yang sudah di-Material-kan dengan TODO untuk owner swap ke Iconsax.

---

*Disusun oleh Tech Lead · 16 Juni 2026 · v1.0*
