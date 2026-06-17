# Sprint 5 Plan — Doctor

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | 16 Juni 2026 |
| **Sprint Window** | TBD (2 minggu) |
| **Tema Sprint** | **"Doctor Search & Detail — Audit & Polish"** |
| **Acuan** | `docs/wireframe/08-doctor-search.md` · `docs/wireframe/09-doctor-detail.md` · `docs/api_contract/api_contract_health_pal.md` §5.1-5.4 · `docs/erd/erd_healh_pal.md` · `home_page_audit.md` (template) |
| **Tech Lead** | MiniMax-M3 |
| **Testing Policy** | ❌ NO TEST FILES (deferred ke Sprint 9) |

---

## 📊 Sprint 5 Progress Tracker

**Last Updated:** 16 Juni 2026
**Overall:** 1/9 tasks (11%) — D1 Audit ✅ · 🟢 Score: 88%

| Task | Deskripsi | Audit Ref | Estimasi | Status | Commit |
|------|-----------|-----------|:--------:|--------|--------|
| D1 | Sprint Opening Audit — doctor_audit.md | — | 3h | ✅ Done | `5560c36` |
| D2 | Skeletonizer loading — Search + Detail | K1 | 1.5h | ⬜ Not Started | — |
| D3 | ErrorSection — Search + Detail | K2 | 0.5h | ⬜ Not Started | — |
| D4 | Implement "Lihat Peta" (reuse clinic_card pattern) | K3 | 1h | ⬜ Not Started | — |
| D5 | Pull-to-refresh Doctor Search + Detail | M1 | 1.5h | ⬜ Not Started | — |
| D6 | Skeletonizer slot loading area | M3 | 1h | ⬜ Not Started | — |
| D7 | Filter chips dinamis (dari SpecializationCubit) | M2 | 2h | ⬜ Not Started | — |
| D8 | Search empty state polish + initial state | — | 0.5h | ⬜ Not Started | — |
| D9 | Final QA + flutter analyze | — | 1h | ⬜ Not Started | — |

**Total:** ~12h

**Skipped:**
- D4 Icon consistency → sudah ✅ Material Icons (no change needed)
- D6 Doctor card layout → sudah sesuai wireframe ✅
- D7 Slot selection → sudah sesuai wireframe ✅

---

## 1. Sprint Opening Audit

### Audit Doc Target

`docs/progress/doctor_audit.md` — mengikuti template `home_page_audit.md`

### Hasil Audit — Temuan Aktual

| ID | Temuan | Tingkat | File |
|----|--------|---------|------|
| K1 | Loading pakai `LoadingView` / `CircularProgressIndicator` — harus Skeletonizer | 🔴 | `doctor_search_page.dart:188`, `doctor_detail_page.dart:107` |
| K2 | Error state custom (`_buildError`) — harus ErrorSection | 🔴 | `doctor_detail_page.dart:108-111` |
| K3 | "Lihat Peta" hanya TODO comment, belum implementasi | 🔴 | `doctor_detail_page.dart:268` |
| M1 | Pull-to-refresh tidak ada di Search + Detail | 🟡 | `doctor_search_page.dart`, `doctor_detail_page.dart` |
| M2 | Filter chips hardcoded (4 item) — wireframe harap dinamis | 🟡 | `doctor_search_page.dart:60-66` |
| M3 | Tidak ada Skeletonizer untuk slot loading area | 🟡 | `doctor_detail_page.dart:169-189` |
| L1 | Favorite + Share masih stub (onPressed kosong) | 🟢 | `doctor_detail_page.dart:97, 150` |

---

## 2. Task Details (Post-Audit)

#### D1 ✅ Sprint Opening Audit
`doctor_audit.md` — 88% score. Temuan: 3 🔴 (K1-K3), 3 🟡 (M1-M3), 2 🟢 (L1).

#### D2 Skeletonizer (1.5h) — Ref: K1
Ganti `LoadingView` / `CircularProgressIndicator` dengan `Skeletonizer` wrapping production widget di:
- Doctor Search: ganti `SearchLoading() => const LoadingView()` → `Skeletonizer(enabled: true, child: _buildList(mockDoctors, true))`
- Doctor Detail: ganti `DoctorDetailLoading() => CircularProgressIndicator()` → `Skeletonizer(enabled: true, child: _buildLoaded(...))` dengan `DoctorEntity.mock()` + `DoctorSlotEntity.mock()`

#### D3 ErrorSection (0.5h) — Ref: K2
Ganti `_buildError` di Doctor Detail dengan `ErrorSection` dari `lib/widgets/loader/error_section.dart`.

#### D4 Implement "Lihat Peta" (1h) — Ref: K3
Reuse `_openMaps` try-catch pattern dari `clinic_card.dart`:
```dart
onTap: () async {
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${doctor.clinic!.latitude},${doctor.clinic!.longitude}',
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
```

#### D5 Pull-to-refresh (1.5h) — Ref: M1
- Doctor Search: wrap `ListView` with `RefreshIndicator` → `context.read<SearchCubit>().searchDoctors(_controller.text)`
- Doctor Detail: wrap `SingleChildScrollView` with `RefreshIndicator` → `context.read<DoctorDetailCubit>().loadDetail(widget.doctorId)`

#### D6 Skeletonizer slot loading (1h) — Ref: M3
Wrap slot preview area (`Wrap` + `ChoiceChip`) with `Skeletonizer` saat state `DoctorDetailLoading`.

#### D7 Filter chips dinamis (2h) — Ref: M2
Ganti hardcoded `_filterSpecs` (4 item) dengan list dari `SpecializationCubit` (existing dari Home feature). Load via `getIt<SpecializationCubit>()` atau inject use case.

#### D8 Empty state polish (0.5h)
Polish `SearchInitial` + `SearchEmpty` states — konsisten dengan wireframe 08.

#### D9 Final QA (1h)
flutter analyze 0 issues + update tracker.

---

## 3. Definition of Done

- [ ] `doctor_audit.md` published
- [ ] Skeletonizer di Doctor Search + Detail
- [ ] ErrorSection di Doctor Search + Detail
- [ ] Icon consistency (Material + TODO)
- [ ] Search bar debounce + real-time filter
- [ ] Doctor card layout sesuai wireframe
- [ ] Empty state untuk 0 hasil
- [ ] Slot selection UI sesuai wireframe
- [ ] Pull-to-refresh di kedua halaman
- [ ] "Lihat Peta" error handling
- [ ] `flutter analyze` 0 issues

---

*Disusun oleh Tech Lead · 16 Juni 2026 · v1.0*
