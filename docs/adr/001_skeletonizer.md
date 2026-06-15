# ADR 001: Standardisasi Loading Skeleton dengan Skeletonizer

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 15 Juni 2026 |
| **Penulis** | Tech Lead (MiniMax-M3) |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Arsitektur UI (loading state) + pubspec dependencies |

---

## 1. Konteks

Proyek Health Pal memiliki kebutuhan loading skeleton di seluruh halaman — terutama Home (Banner, Upcoming, Categories, Nearby, Greeting), Doctor Search, Doctor Detail, dan feature-feature berikutnya.

Sebelum ADR ini, terdapat dua pendekatan yang saling bertentangan:

| Pendekatan | Direkomendasikan di | Status |
|---|---|---|
| `shimmer: ^3.0.0` | `sprint_2_plan.md` AD-6 (v1.0) | ✅ Ada di pubspec |
| Dedicated skeleton widgets | `sprint_2_plan.md` Lampiran A (file touch list) | ⏸️ Direncanakan |
| `skeletonizer: ^1.4.0` | Belum pernah dipertimbangkan | ❌ Tidak ada |

Masalah yang diidentifikasi:

1. **Boilerplate tinggi** — Setiap section butuh 1 dedicated skeleton widget → 5 widget baru (banner, upcoming, categories, greeting, nearby).
2. **Fragmentasi** — Tidak ada pattern tunggal → implementasi loading state tidak konsisten antar feature.
3. **shimmer** membutuhkan `Shimmer.fromColors()` wrapper terpisah + dummy child → tidak otomatis reuse production widget.
4. **Maintenance burden** — Setiap perubahan UI di production widget harus di-sync ke skeleton variant.

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: `shimmer: ^3.0.0` + dedicated skeleton widgets (Status Quo)

- **Pro:** Sudah di pubspec, tidak perlu dependency baru.
- **Kontra:** 1 production widget → 1 skeleton variant file. Double maintenance.
- **Kontra:** Tidak reuse production widget — skeleton adalah widget terpisah dengan layout copy-paste.

### Opsi B: `skeletonizer: ^1.4.0` + reuse production widgets (DIUSULKAN)

- **Pro:** Zero dedicated skeleton files. Cukup `Skeletonizer(enabled: true, child: productionWidget)`.
- **Pro:** Skeletonizer otomatis render Text, Image, Container sebagai skeleton placeholder.
- **Pro:** Perubahan UI di production widget otomatis tercermin di loading state.
- **Kontra:** Dependency baru (perlu tambah ke pubspec).
- **Kontra:** Edge case: widget dengan custom shape atau animasi mungkin butuh penanganan khusus.

### Opsi C: Custom `SkeletonLoader` widget internal

- **Pro:** Full control, tidak ada dependency eksternal.
- **Kontra:** ~200-300 baris boilerplate untuk animasi + layout detection.
- **Kontra:** Tidak ada community support, bug fix internal.
- **Kontra:** Risiko inkonsistensi implementasi antar developer.

---

## 3. Keputusan

**Pilih Opsi B: `skeletonizer: ^1.4.0` sebagai satu-satunya solusi loading skeleton.**

### Detail Keputusan

1. **Hapus `shimmer: ^3.0.0`** dari pubspec.
2. **Tambah `skeletonizer: ^1.4.0`** ke pubspec.
3. **DILARANG** membuat dedicated skeleton widget files (mis. `banner_skeleton.dart`, `upcoming_skeleton.dart`).
4. **WAJIB** reuse production widget langsung via pattern:
   ```dart
   Skeletonizer(
     enabled: state is Loading,
     child: BannerCarousel(banners: mockBanners),
   )
   ```
5. Pengecualian hanya diizinkan dengan komentar:
   ```dart
   /* justify: skeletonizer cannot replace X because ... */
   ```

---

## 4. Alasan

1. **Productivity gain:** ~4 jam implementasi (wrapper existing widgets) vs ~16 jam (4 dedicated skeleton files × 4 jam).
2. **Maintainability:** Satu source of truth — production widget adalah satu-satunya layout definition.
3. **Consistency:** Semua feature (Home, Doctor, Booking, Profile, Loc) pakai pattern yang sama — `Skeletonizer(enabled: ..., child: ...)`.
4. **Testability:** Widget test cukup test production widget — skeleton variant tidak perlu test terpisah.
5. **Migration:** Tidak ada shimmer code di codebase saat ini (0 Dart files), jadi migration zero-cost.

---

## 5. Konsekuensi

### Positif

- ✅ Semua loading state menggunakan pattern yang seragam.
- ✅ Tidak ada duplikasi layout (production vs skeleton).
- ✅ Perubahan UI → loading state auto-update.
- ✅ Pengurangan file count: 3-5 skeleton files dieliminasi.
- ✅ Lebih mudah di-review (diff hanya +1 baris `Skeletonizer` wrapper, bukan +100 baris skeleton file baru).

### Negatif

- ⚠️ Skeletonizer tidak sempurna untuk widget dengan `CustomPainter` atau layout non-linear — perlu `/* justify */` comment.
- ⚠️ Butuh dummy/mock data untuk child widget saat loading (mis. `mockBanners`).
- ⚠️ Ukuran bundle + ~50 KB (skeletonizer package + transitive deps).

### Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| Skeletonizer tidak support Flutter version tertentu | Versi `^1.4.0` support Flutter 3.10+. Pin versi minor. |
| Developer tetap buat dedicated skeleton files | Enforce via code review + `flutter analyze` custom lint (future) |
| Custom animated skeleton dibutuhkan | Exception dengan `/* justify */` comment |

---

## 6. Compliance

Kepatuhan terhadap ADR ini di-enforce melalui:

| Mekanisme | Detail |
|---|---|
| **AGENTS.md** | Skeleton Loading Rule section — WAJIB dibaca oleh AI agent & developer |
| **Code Review** | DILARANG merge PR yang berisi dedicated skeleton widget files tanpa `/* justify */` |
| **TDD 04** | State Pattern Template sudah include Skeletonizer pattern |
| **Sprint Planning** | Semua task loading state harus refer ke ADR 001 ini |
| **Analisis Static** | (Future) Custom lint rule: `no_shimmer_import` + `no_skeleton_file` |

---

## 7. Referensi

- [skeletonizer package (pub.dev)](https://pub.dev/packages/skeletonizer)
- ADR ini meng-override: `sprint_2_plan.md` §6.6 AD-6 (v1.0 — shimmer decision)
- Dokumen yang diperbarui: `AGENTS.md`, `pubspec.yaml`, `README.md`, `docs/tdd/04-state-management.md`, `docs/wireframe/06-home.md`, `docs/wireframe/08-doctor-search.md`, `docs/wireframe/09-doctor-detail.md`, `docs/progress/sprint_2_plan.md`, `docs/todo/06-home-todo.md`, `docs/audit/audit_produk_health_pal.md`, `docs/audit/audit_integrasi_health_pal.md`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
