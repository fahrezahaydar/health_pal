# ADR 003: Migrasi google_fonts → Local Font Assets

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 21 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | pubspec dependencies, theme (app_text_theme.dart), 4 widget files, assets folder |

---

## 1. Konteks

Health Pal menggunakan dua font family yang didefinisikan di `AppTextTheme`:

| Font Family | Penggunaan | Weight |
|---|---|---|
| **Inter** | Headings, Body, Button, Label Large — 7 style variants | Bold (700), SemiBold (600), Medium (500), Regular (400) |
| **Poppins** | Label Medium (XS), Label Small (XS) — 2 style variants | Medium (500), Regular (400) |

Font di-load melalui `google_fonts: ^8.0.2`, yang melakukan HTTP request ke Google Fonts API saat runtime.

Masalah yang diidentifikasi:

1. **Loading delay —** Google Fonts melakukan network fetch saat pertama kali widget di-render. Pada koneksi lambat, terjadi flash of invisible text (FOIT) atau layout shift.
2. **Offline tidak support —** Aplikasi health harus bisa berfungsi offline. google_fonts tidak menyediakan font fallback tanpa koneksi.
3. **Bundle size tidak optimal —** google_fonts mendownload font dari network setiap kali, tidak memanfaatkan asset bundling Flutter.
4. **5 Dart files bergantung —** `app_text_theme.dart` + 4 widget files menggunakan `GoogleFonts.inter()` langsung, bukan melalui theme → tidak konsisten dengan theme-driven design.

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: google_fonts `^8.0.2` (Status Quo)

- **Pro:** Zero setup, zero assets — cukup `GoogleFonts.inter()` di kode.
- **Kontra:** Network dependency — font gagal load jika offline.
- **Kontra:** FOIT (Flash of Invisible Text) pada koneksi lambat — pengalaman pengguna buruk.
- **Kontra:** Tidak bisa di-preload atau di-cache secara native.
- **Kontra:** Beberapa widget bypass `AppTextTheme` dan panggil `GoogleFonts.inter()` langsung — melanggar DRY.

### Opsi B: Local font assets di `assets/fonts/` (DIUSULKAN)

- **Pro:** **Zero network —** font tersedia offline, tidak ada FOIT.
- **Pro:** Render instan — font di-bundle dalam APK, tidak perlu HTTP fetch.
- **Pro:** Ukuran font ~4 MB (Inter variable + Poppins weights) — satu kali di APK, tidak perlu redownload.
- **Pro:** Predictable — semua style didefinisikan lewat `AppTextTheme`, bukan `GoogleFonts.inter()` inline.
- **Pro:** Penggunaan `fontWeight` Flutter standard — tidak perlu mapping Google Fonts parameter.
- **Kontra:** Tambah ~4 MB ke APK size (Inter ~800 KB + Poppins ~3 MB).
- **Kontra:** Perlu konfigurasi `fonts:` di pubspec.yaml.
- **Kontra:** Font license (OFL) harus di-bundle.

### Opsi C: Preloaded google_fonts via `cacheFonts()`

- **Pro:** Masih bisa pakai Google Fonts API tanpa asset.
- **Kontra:** Workaround — tetap butuh network untuk pertama kali load.
- **Kontra:** Kompleksitas tambahan di init.
- **Kontra:** Tidak menyelesaikan masalah offline 100%.

---

## 3. Keputusan

**Pilih Opsi B: Local font assets — Inter variable font + Poppins individual weight files.**

### Detail Keputusan

1. **Tambahkan `fonts:` section di pubspec.yaml:**
   - Family `Inter`: variable font `Inter-VariableFont_opsz,wght.ttf` dengan weight range 100–900.
   - Family `Poppins`: individual files untuk Regular (400) dan Medium (500).

2. **Update `app_text_theme.dart`:**
   - Ganti `GoogleFonts.inter(...)` → `TextStyle(fontFamily: 'Inter', ...)`.
   - Ganti `GoogleFonts.poppins(...)` → `TextStyle(fontFamily: 'Poppins', ...)`.
   - Pertahankan semua parameter fontSize, fontWeight, height, color tanpa perubahan value.

3. **Update 4 widget files** yang masih menggunakan `GoogleFonts.inter()` langsung:
   - `app_date_picker_dialog.dart`
   - `app_date_picker_field.dart`
   - `app_input_field.dart`
   - `drop_down_button.dart`

4. **Hapus dependency `google_fonts: ^8.0.2`** dari pubspec.yaml.

5. **Hapus import** `package:google_fonts/google_fonts.dart` dari semua file.

6. **Bundle OFL license** untuk Inter dan Poppins sebagai persyaratan SIL Open Font License.

---

## 4. Alasan

1. **Offline-first —** Font tersedia tanpa koneksi internet. Kritis untuk aplikasi health yang harus berfungsi di daerah dengan koneksi tidak stabil.
2. **Zero FOIT —** Font sudah di-bundle di APK, render instan tanpa flash.
3. **Consistency —** Semua font style didefinisikan di satu tempat (`AppTextTheme`). Widget yang sebelumnya inline `GoogleFonts.inter()` akan direfactor ke `AppTextTheme` atau `DefaultTextTheme`.
4. **Eliminasi dependency —** Satu dependency (`google_fonts`) dihapus. Mengurangi potensi version conflict.
5. **Flutter native —** `fontFamily` + `fontWeight` adalah API Flutter standar, tidak perlu package eksternal.
6. **Performance —** Tidak ada HTTP request di runtime untuk font loading. Bundle size impact ~4 MB acceptable untuk production APK.

---

## 5. Konsekuensi

### Positif

- ✅ Font render instan — zero network roundtrip.
- ✅ Offline penuh — semua teks tetap tampil tanpa koneksi.
- ✅ Satu dependency berkurang dari pubspec.
- ✅ Semua font style via `AppTextTheme` — tidak ada lagi inline `GoogleFonts.inter()`.
- ✅ Penggunaan `fontWeight` Flutter standard (w400, w500, w600, bold) — tidak perlu mapping.

### Negatif

- ⚠️ APK size bertambah ~4 MB (Inter ~800 KB, Poppins ~3 MB).
- ⚠️ Jika font version update, font files harus diganti manual di assets/fonts/.
- ⚠️ OFL license files harus ikut di-bundle (sudah ada di masing-masing folder).

### Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| Inter variable font tidak di-render dengan weight yang benar di Flutter | Variable font support sudah stabil di Flutter 3.10+. Test semua weight setelah migrasi. |
| Poppins weight file tidak cocok dengan fontWeight declaration | Gunakan exact file: Poppins-Regular (w400), Poppins-Medium (w500). |
| Font licensing violation (OFL) | License file (OFL.txt) sudah included di assets/fonts/Inter/ dan assets/fonts/Poppins/. |
| Inline GoogleFonts.inter() terlewat di file non-widget | Code review + grep `GoogleFonts\.` dan `google_fonts` setelah migrasi — target zero hits. |

---

## 6. Compliance

Kepatuhan terhadap ADR ini di-enforce melalui:

| Mekanisme | Detail |
|---|---|
| **AGENTS.md** | Update Font Section — Wajib pakai local font assets, dilarang import google_fonts |
| **Code Review** | DILARANG merge PR yang mengandung `import 'package:google_fonts/google_fonts.dart'` atau `GoogleFonts.` |
| **CI/CD** | Script verifikasi: `grep -rn "GoogleFonts\|google_fonts" lib/ pubspec.yaml` harus return exit code 1 (zero matches) |
| **pubspec.yaml** | Tidak ada `google_fonts` di dependencies — hanya `fonts:` section |
| **Asset Structure** | Font files wajib di `assets/fonts/<Family>/` dengan OFL license |

---

## 7. Referensi

- [Inter variable font (Google Fonts)](https://fonts.google.com/specimen/Inter)
- [Poppins (Google Fonts)](https://fonts.google.com/specimen/Poppins)
- [SIL Open Font License 1.1](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL)
- [Flutter Fonts documentation](https://docs.flutter.dev/ui/design/material/fonts)
- ADR ini meng-override: `pubspec.yaml` §dependencies (google_fonts: ^8.0.2), `lib/core/theme/app_text_theme.dart` (GoogleFonts.inter/Poppins usage)
- Dokumen yang diperbarui: `pubspec.yaml`, `lib/core/theme/app_text_theme.dart`, `lib/widgets/dialog/app_date_picker_dialog.dart`, `lib/widgets/input/app_date_picker_field.dart`, `lib/widgets/input/app_input_field.dart`, `lib/widgets/input/drop_down_button.dart`, `AGENTS.md`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
