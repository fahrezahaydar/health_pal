# Sprint 7 Plan — Profile

| Field | Detail |
|---|---|
| **Tanggal** | 16 Juni 2026 |
| **Tema** | **"Profile — Audit & Polish (4 pages)"** |
| **Acuan** | `profile_audit.md` · wireframe 14-16 · api_contract §3.1-3.5 |

---

## 📊 Progress Tracker

| Task | Audit Ref | Estimasi | Status |
|------|-----------|:--------:|--------|
| P1 | Sprint Opening Audit → `profile_audit.md` | — | ✅ Done | `516c12a` |
| P2 | Skeletonizer loading — semua 4 halaman | K1 | 2h | ✅ Done | `70f8fcd` |
| P3 | ErrorSection — semua 4 halaman | K2 | 1h | ✅ Done | `70f8fcd` |
| P4 | Icon consistency: iconsax → Material + TODO | K3 | 2h | ✅ Done | `70f8fcd` |
| P5 | Favorite page: implement list item render | M1 | 0.5h | ✅ Done | `4f8c3c3` |
| P6 | ProfileCubit: hapus SupabaseClient langsung | M3 | 1h | ✅ Done *(already correct)* | — |
| P7 | Final QA + flutter analyze | — | 1h | ✅ Done | — |

**Total:** ~7.5h

**Skipped:**
- M2 (notification PATCH ke server) — deferred ke Sprint 8 (FCM)
- L1 (Favorite placeholder) — deferred ke v1.1

---

## Task Details

#### P2 Skeletonizer (2h)
Ganti `CircularProgressIndicator` dengan `Skeletonizer` wrapping production widget di:
- `profile_page.dart` — skeleton user card + menu list
- `edit_profile_page.dart` — skeleton form fields
- `notification_page.dart` — skeleton notification list
- `favorite_page.dart` — skeleton empty/favorite list

#### P3 ErrorSection (1h)
Ganti custom `_errorState` dengan `ErrorSection` dari `lib/widgets/loader/error_section.dart` di:
- `profile_page.dart`
- `edit_profile_page.dart`
- `notification_page.dart`
- `favorite_page.dart`

#### P4 Icon Consistency (2h)
Replace `Iconsax.*` dengan `Icons.*` + `// TODO: change to iconsax` di semua 4 halaman.
Hapus `import 'package:iconsax_latest/iconsax_latest.dart';` jika semua icon sudah diganti.

#### P5 Favorite Item Render (0.5h)
Implementasikan `_list` method di `favorite_page.dart` untuk render `DoctorCard` atau item sederhana.

#### P6 ProfileCubit Refactor (1h)
Hapus `SupabaseClient` langsung dari `profile_page.dart` — ganti dengan `AppServices.currentAuthId` (sama seperti fix A4 di Sprint 2).

---

*Disusun oleh Tech Lead · 16 Juni 2026 · v1.0*
