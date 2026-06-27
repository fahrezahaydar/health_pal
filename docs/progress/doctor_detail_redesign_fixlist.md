# Doctor Detail Redesign — Fix List

**Tanggal:** 28 Juni 2026
**Referensi:** ADR-009, `docs/wireframe/09-doctor-detail.md` v2.0, `docs/progress/doctor_detail_redesign_plan.md`

---

## FIX-1: Database Migration — tambah kolom `total_patients`

**Deskripsi:** Tambah kolom `total_patients` (INT4, DEFAULT 0) ke tabel `doctors`.

**File target:** `supabase/migrations/009_total_patients.sql`

**Detail:**
```sql
ALTER TABLE doctors ADD COLUMN total_patients INT4 NOT NULL DEFAULT 0;
COMMENT ON COLUMN doctors.total_patients IS 'Total pasien yang pernah ditangani (display only)';
```

**Dependency:** None

**Verifikasi:** `supabase db reset` tidak error (atau jalankan migration manual).

**Status:** ✅

---

## FIX-2: Buat DoctorScheduleModel + DoctorScheduleEntity

**Deskripsi:** Buat data model dan entity untuk `doctor_schedules` table. Gunakan `@freezed` untuk model (sama seperti model lain). Entity menggunakan `Equatable`.

**File target:**
- `lib/features/doctor/data/model/doctor_schedule_model.dart`
- `lib/features/doctor/domain/entity/doctor_schedule_entity.dart`

**Detail field (mirror ERD `doctor_schedules`):**
| Field | Tipe | JSON Key |
|-------|------|----------|
| `id` | String | `id` |
| `doctorId` | String | `doctor_id` |
| `dayOfWeek` | int | `day_of_week` |
| `startTime` | String | `start_time` |
| `endTime` | String | `end_time` |
| `slotDurationMinutes` | int | `slot_duration_minutes` |
| `isActive` | bool | `is_active` |

**Entity harus punya computed getter `dayName` (map `dayOfWeek` ke nama hari Indonesia: 0=Minggu, 1=Senin, ..., 6=Sabtu).**

**Dependency:** FIX-1 ✅

**Verifikasi:** `dart run build_runner build --force-jit` — model + entity tidak error.

---

## FIX-3: Update DoctorModel — tambah `totalPatients`, `schedules`

**Deskripsi:** Tambah dua field baru ke `DoctorModel`:
- `totalPatients` (int, `@JsonKey(name: 'total_patients')`, `@Default(0)`)
- `schedules` (List of `DoctorScheduleModel`?, `@JsonKey(name: 'doctor_schedules')`, `@Default([])`)
  
Update `fromEntity` dan `toEntity` mapper.

**File target:** `lib/features/doctor/data/model/doctor_model.dart`

**Dependency:** FIX-2 ✅

**Verifikasi:** `dart run build_runner build --force-jit` — codegen ulang `doctor_model.g.dart` + `doctor_model.freezed.dart`.

---

## FIX-4: Update DoctorEntity — tambah `totalPatients`, `schedules`, `workingTimeDisplay`

**Deskripsi:** Tambah field dan computed getter ke `DoctorEntity`:
- `totalPatients` (int, default `0`)
- `schedules` (List of `DoctorScheduleEntity`?, default `null`)
- Computed getter `workingTimeDisplay` (String) — gabung data schedule jadi format display: `"Monday–Friday, 08:00 AM – 06:00 PM"`. Jika schedules kosong/null return `"No schedule available"`.
- Update `mock()` + `mockList()` — include field baru.
- Update `props` — include field baru.

**File target:** `lib/features/doctor/domain/entity/doctor_entity.dart`

**Dependency:** FIX-2 ✅

**Verifikasi:** Compile tanpa error.

---

## FIX-5: Codegen — build_runner

**Deskripsi:** Jalankan codegen untuk mengenerate file `.freezed.dart` dan `.g.dart` yang baru (DoctorScheduleModel, DoctorModel update).

**Command:**
```powershell
dart run build_runner build --force-jit
```

**Dependency:** FIX-2, FIX-3 ✅

**Verifikasi:** 0 error, file `doctor_schedule_model.freezed.dart`, `doctor_schedule_model.g.dart`, `doctor_model.g.dart` tergenerate dengan field baru.

---

## FIX-6: DataSource — tambah `getDoctorSchedules()` + update `getDoctorDetail()`

**Deskripsi:** Dua perubahan di `DoctorRemoteDataSource`:
1. **Update `getDoctorDetail()`** — tambah `doctor_schedules(day_of_week,start_time,end_time,is_active)` di select clause. Jika `.single()` PostgREST tidak support nested array, fallback:
2. **Tambah method baru `getDoctorSchedules(String doctorId)`** — query parallel ke `doctor_schedules` table dengan filter `doctor_id` dan `is_active`.

**File target:** `lib/features/doctor/data/datasource/doctor_remote_datasource.dart`

**Dependency:** FIX-5 ✅ (model exists)

**Verifikasi:** `flutter analyze` — 0 issues pada file ini.

---

## FIX-7: Repository + UseCase — wire schedule data

**Deskripsi:** Tiga layer update:
1. **`DoctorRepository`** (abstract) — tambah method `Future<Result<List<DoctorScheduleEntity>>> getDoctorSchedules(String doctorId);`
2. **`DoctorRepositoryImpl`** — implementasi method baru, delegasi ke `DoctorRemoteDataSource.getDoctorSchedules()`.
3. **Buat `GetDoctorSchedulesUseCase`** — use case baru untuk fetch schedules, @injectable.

**File target:**
- `lib/features/doctor/domain/repository/doctor_repository.dart`
- `lib/features/doctor/data/repository/doctor_repository_impl.dart`
- `lib/features/doctor/domain/usecase/get_doctor_schedules_usecase.dart`

**Dependency:** FIX-6 ✅

**Verifikasi:** `flutter analyze` — 0 issues.

---

## FIX-8: Buat DoctorInfoCard widget

**Deskripsi:** Widget baru untuk header dokter sesuai wireframe v2.0:
- Foto 2:3 aspect ratio (gunakan `AspectRatio(2/3)` di kiri, width ~96px)
- Nama dokter (bold, `titleLarge`)
- Divider horizontal (tipis, `grey200`)
- Specialization text (`bodySmall`, `grey600`)
- Hospital row: icon location + clinic name + address (tappable → buka Google Maps)
- Favorite icon button di pojok kanan atas (onFavoriteToggle callback)

**Input:** `DoctorEntity`, `isFavorite`, `onFavoriteToggle`

**File target:** `lib/widgets/card/doctor_info_card.dart`

**Dependency:** FIX-4 ✅ (DoctorEntity sudah punya field baru)

**Verifikasi:** Widget render tanpa error, layout match wireframe.

---

## FIX-9: Buat DoctorStatsRow widget

**Deskripsi:** Widget untuk 4 stat horizontal:
- `StatItem` (komponen internal): `CircleAvatar(icon)`, value (bold), label (small)
- 4 stat: Patients (`Icons.people`), Experience (`Icons.work_history`), Rating (`Icons.star`), Reviews (`Icons.chat_bubble_outline`)
- Value dari: `entity.totalPatients` (format: `"${value}+"`), `entity.experienceYears` (`"${value}+"`), `entity.ratingAvg` (`ratingDisplay`), `entity.ratingCount` (format: `"${value}"`)
- Tambah TODO untuk swap ke iconsax di setiap icon Material.

**Input:** `DoctorEntity`

**File target:** `lib/widgets/card/doctor_stats_row.dart`

**Dependency:** FIX-4 ✅

**Verifikasi:** Widget render 4 stat dengan icon + value + label.

---

## FIX-10: Buat AboutSection widget

**Deskripsi:** Widget untuk "About Me" section:
- Section title: "About Me" (atau "Tentang Saya")
- Description text dari `entity.description`
- Jika text > 3 line, tampilkan "View More" button (expandable → tampilkan semua text, ubah jadi "View Less")
- Gunakan `Text` dengan `maxLines: 3` + `TextSpan`/`LayoutBuilder` untuk expand logic atau `ReadMoreText` pattern (tanpa package baru — manual toggle dengan `_isExpanded` state internal).

**Input:** `String? description`

**File target:** `lib/widgets/card/about_section.dart`

**Dependency:** None (hanya string input)

**Verifikasi:** Widget expand/collapse berfungsi. Jika description null/kosong, return `SizedBox.shrink()`.

---

## FIX-11: Buat WorkingTimeSection widget

**Deskripsi:** Widget untuk "Working Time" section:
- Section title: "Working Time" (atau "Jam Praktik")
- Schedule text dari input string (display formatted)
- Jika string kosong/null, tampilkan "No schedule available" dalam grey italic.

**Input:** `String? workingTimeDisplay`

**File target:** `lib/widgets/card/working_time_section.dart`

**Dependency:** None (hanya string input)

**Verifikasi:** Widget render schedule text dengan benar.

---

## FIX-12: Buat ReviewsHeader widget

**Deskripsi:** Widget untuk Reviews section header:
- Row: "Reviews" title (kiri) + "See All" button (kanan — nonaktif/dummy, karena content di-defer)
- Tambah komentar: `// TODO: See All → navigate to full reviews page (deferred to future sprint)`

**File target:** `lib/widgets/card/reviews_header.dart`

**Dependency:** None

**Verifikasi:** Widget render title + disabled See All button.

---

## FIX-13: Update DoctorDetailState + DoctorDetailCubit

**Deskripsi:** Dua perubahan:

**State (`doctor_detail_state.dart`):**
- Tambah field `List<DoctorScheduleEntity> schedules` (default `[]`)
- Update `copyWith()` untuk include schedules
- Update `props`

**Cubit (`doctor_detail_cubit.dart`):**
- Inject `GetDoctorSchedulesUseCase`
- Update `loadDetail()`: fetch schedules parallel dengan detail (setelah detail sukses)
- Hapus fetch `getDoctorSlots` (slot preview tidak ada di wireframe v2.0) — **atau tetap pertahankan untuk transisi?** Keputusan: hapus slot preview karena wireframe v2.0 tidak menampilkan sample slots. Hanya `availableSlotCount` yang mungkin masih berguna (tapi tidak ada di wireframe v2.0 — jadi hapus juga)
- Update `DoctorDetailLoaded` emit: include schedules, tanpa sampleSlots dan availableSlotCount
- Simpan `suggestedSlotId` hanya untuk navigasi booking (tetap dipertahankan jika ada dari parameter)

**File target:**
- `lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_state.dart`
- `lib/features/doctor/presentation/bloc/doctor_detail/doctor_detail_cubit.dart`

**Dependency:** FIX-7 ✅ (use case exists), FIX-4 ✅ (entity updated)

**Verifikasi:** `flutter analyze` — 0 issues.

---

## FIX-14: Rewrite DoctorDetailPage — layout v2.0

**Deskripsi:** Rewrite `DoctorDetailPage` + `DoctorDetailView` layout sesuai wireframe v2.0:

**Hapus:**
- `DoctorCardDetail` — diganti dengan `DoctorInfoCard`
- `_buildInfoCard(doctor)` — section sudah dipecah ke widget terpisah
- Slot availability + sample slots preview
- `_buildReviewsPlaceholder()` — diganti dengan `ReviewsHeader`
- `_LoadedSkeleton` + `_buildLoadedStatic` — buat ulang skeleton dengan widget baru
- Import `doctor_card_detail.dart`, `slot_availability_text.dart`, `label_value_row.dart` (jika tidak dipakai lagi)

**Tambah:**
- `DoctorInfoCard` (FIX-8)
- `DoctorStatsRow` (FIX-9)
- `AboutSection` (FIX-10)
- `WorkingTimeSection` (FIX-11)
- `ReviewsHeader` (FIX-12)

**Update:**
- AppBar title: "Detail Dokter"
- Bottom bar: tetap `LightFilledButton` → "Book Appointment"
- Skeleton: reuse semua widget baru via `Skeletonizer(enabled: true, child: _buildLoaded(...))` — mock data dari `DoctorEntity.mock()`
- `_buildLoaded`: hapus parameter `sampleSlots`, `availableCount`. Gunakan `DoctorEntity` langsung.

**File target:** `lib/features/doctor/presentation/page/doctor_detail_page.dart`

**Dependency:** FIX-8, FIX-9, FIX-10, FIX-11, FIX-12, FIX-13 ✅

**Verifikasi:** Page render semua section sesuai wireframe.

---

## FIX-15: Cleanup — hapus DoctorCardDetail + file tidak terpakai

**Deskripsi:** Jika `DoctorCardDetail` tidak dipakai oleh halaman lain:
1. Cek konsumen dengan `grep -rln "DoctorCardDetail" lib/`
2. Jika cuma dipakai di `doctor_detail_page.dart` (yang sudah di-rewrite), hapus file:
   - `lib/widgets/card/doctor_card_detail.dart`
3. Jika dipakai di tempat lain (misal di beberapa page atau widget test), biarkan.

**Cek juga:**
- `slot_availability_text.dart` — jika tidak dipakai lagi, hapus
- Import cleanup di semua file yang diubah

**File target:** `lib/widgets/card/doctor_card_detail.dart` (opsional hapus)

**Dependency:** FIX-14 ✅ (page rewrite selesai)

**Verifikasi:** `flutter analyze` — 0 issues, tidak ada unused imports.

---

## FIX-16: Final Verify — flutter analyze

**Deskripsi:** Jalankan `flutter analyze` untuk memastikan 0 issues di seluruh project.

**Command:**
```powershell
flutter analyze
```

Jika ada issues, fix sesuai output. Pastikan:
- Tidak ada unused imports
- Tidak ada unused fields
- Semua `@freezed` generated files up-to-date
- Semua widget constructor parameter terisi

**Dependency:** FIX-15 ✅

**Verifikasi:** `flutter analyze` — 0 issues, 0 warnings, 0 errors.

---

## Dependency Graph

```text
FIX-1 (migration)
  │
  ▼
FIX-2 (schedule model/entity)
  │
  ├────────────────────┐
  ▼                    ▼
FIX-3 (update         FIX-4 (update
 DoctorModel)         DoctorEntity)
  │                    │
  └──────┬─────────────┘
         ▼
      FIX-5 (build_runner codegen)
         │
         ▼
      FIX-6 (DataSource)
         │
         ▼
      FIX-7 (Repository + UseCase)
         │
         ▼
 ┌───────┼───────────────────┐
 │       │                   │
 ▼       ▼                   ▼
FIX-8   FIX-9    FIX-10/11/12
(Info   (Stats  (About, WorkTime,
 Card)   Row)    ReviewsHeader)
 │       │            │
 └───────┴─────┬──────┘
               ▼
         FIX-13 (State + Cubit)
               │
               ▼
         FIX-14 (Page Rewrite)
               │
               ▼
         FIX-15 (Cleanup)
               │
               ▼
         FIX-16 (Final Verify)
```

---

## Aturan Eksekusi

1. **Satu fix per perintah** — kerjakan dengan `fix N` (misal `fix 1`, `fix 2`, dst).
2. **Urut sesuai nomor** — dependency sudah diperhitungkan. Jangan lompati fix sebelum dependency-nya selesai.
3. **`flutter analyze` wajib 0 issues** — sebelum menandai fix selesai, jalankan `flutter analyze`. Jika ada issue, fix dulu baru lanjut.
4. **Update status checkbox** — setelah fix selesai + `flutter analyze` 0, update checklist di file ini dari `⬜` → `✅`.
5. **Commit message convention:**
   - `fix N: deskripsi singkat` untuk setiap fix.
   - Setelah semua FIX selesai, commit final: `feat: implement doctor detail page redesign v2.0 (ADR-009)`.
6. **Tidak ada file test** — sesuai Testing Policy di AGENTS.md (test fase terpisah).
7. **Reviews section** — hanya header (title + See All). Konten review individual di-defer. JANGAN implementasi ReviewCard atau review data layer.
8. **Icon Material** — semua icon baru pakai `Icons.*` dengan TODO comment untuk swap ke iconsax (lihat Icon Convention di AGENTS.md).
