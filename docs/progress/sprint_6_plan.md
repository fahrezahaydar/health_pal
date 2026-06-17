# Sprint 6 Plan — Booking

| Field | Detail |
|---|---|
| **Tanggal** | 16 Juni 2026 |
| **Tema** | **"Booking Flow — Complete Polish"** |
| **Acuan** | `booking_audit.md` · wireframe 10-13 · api_contract §6.1-6.4 |

---

## 📊 Progress Tracker

| Task | Audit Ref | Estimasi | Status |
|------|-----------|:--------:|--------|
| B1 | Sprint Opening Audit → `booking_audit.md` | — | ✅ Done |
| B2 | Skeletonizer — semua 4 halaman | K1 | 2h |
| B3 | ErrorSection — history + detail + book_appointment | K2 | 1h |
| B4 | Pull-to-refresh — detail + book_appointment | M1 | 1h |
| B5 | Animated checkmark success page | M2 | 0.5h |
| B6 | TODO comments iconsax — semua file booking | M3 | 0.5h |
| B7 | Pagination "load more" indicator history | M4 | 1h |
| B8 | Final QA + flutter analyze | — | 1h |

**Skipped:** Icon consistency — sudah ✅ Material Icons (hanya kurang TODO comments)

---

## Task Details

#### B2 Skeletonizer (2h)
Ganti `CircularProgressIndicator` dengan `Skeletonizer` wrapping production widget di:
- `book_appointment_page.dart` — slot loading + form skeleton
- `booking_success_page.dart` — detail card skeleton
- `booking_history_page.dart` — list skeleton
- `booking_detail_page.dart` — header + info + timeline skeleton

#### B3 ErrorSection (1h)
Ganti custom `_errorState` / silent error dengan `ErrorSection` di:
- `booking_history_page.dart` — `_errorState` → `ErrorSection`
- `booking_detail_page.dart` — `_errorState` → `ErrorSection`
- `book_appointment_page.dart` — `BookingState.errorMessage` → tampilkan `ErrorSection`

#### B4 Pull-to-refresh (1h)
Tambahkan `RefreshIndicator` di:
- `booking_detail_page.dart`
- `book_appointment_page.dart`

#### B5 Animated checkmark (0.5h)
Ganti `Icon(Icons.check_circle)` static dengan `AnimatedIcon` atau Lottie animation di `booking_success_page.dart`.

#### B6 TODO comments (0.5h)
Tambahkan `// TODO: change to iconsax — currently Material fallback` ke semua Material Icons di booking files.

#### B7 Pagination indicator (1h)
Tambahkan `DotLoader` / loading indicator di bagian bawah list saat `loadMore()` dipanggil di `booking_history_page.dart`.

---

*Disusun oleh Tech Lead · 16 Juni 2026 · v1.0*
