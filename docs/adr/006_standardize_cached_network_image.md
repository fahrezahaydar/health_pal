# ADR 006: Standarisasi Network Image Loading ke CachedNetworkImage

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 27 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | 11 Dart files (image loading), pubspec (existing dep — belum dipakai), AGENTS.md |

---

## 1. Konteks

Health Pal menampilkan network image di berbagai konteks — foto dokter, foto klinik, avatar user, banner promosi — yang di-load berulang kali di list, card, carousel, dan halaman detail.

Audit pada 27 Juni 2026 menemukan inkonsistensi cara load network image:

| Metode | Jumlah File | Konteks |
|--------|-------------|---------|
| `Image.network()` | 10 | Doctor photo, clinic cover, user avatar, remote picker |
| `NetworkImage` via `DecorationImage` | 1 | Banner card |
| `CachedNetworkImage` | **0** | — |

Masalah yang diidentifikasi:

1. **Zero disk cache** — `Image.network` hanya menyimpan image di in-memory cache yang volatile. Setiap widget rebuild (navigasi, scroll, state change) memicu re-fetch dari network. Untuk foto dokter/klinik yang muncul di banyak tempat (search list → card → detail → booking), ini berarti **3-5 request redundant** per session.
2. **Tidak ada loading placeholder konsisten** — Hanya 1 dari 11 file (`app_image_picker.dart`) punya `loadingBuilder`. Sisanya menampilkan nothing/blank selama network fetch.
3. **Tidak ada cache policy** — `Image.network` tidak punya mekanisme TTL atau cache eviction. Gambar yang sama di-download berulang meskipun sudah pernah di-load sebelumnya.
4. **`banner_card.dart` rawan broken image** — Menggunakan `DecorationImage` + `NetworkImage` tanpa `errorBuilder` (API `DecorationImage` tidak support). Jika banner gagal load, card hanya menampilkan background color.
5. **`profile_avatar.dart` rawan wasted request** — Baris 21: `Image.network(avatarUrl ?? '')` — saat `avatarUrl` null, tetap membuat HTTP request ke URL kosong.
6. **`cached_network_image: ^3.4.1` sudah ada di pubspec** — Ditambahkan di sprint sebelumnya tapi **tidak pernah di-import** di file manapun. Dependency menganggur.

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: `CachedNetworkImage` — Standarisasi penuh (DIUSULKAN)

Migrasi SEMUA `Image.network` / `NetworkImage` ke `CachedNetworkImage` dengan pola seragam.

- **Pro:** Disk cache otomatis — image di-cache setelah download pertama, tidak perlu re-fetch.
- **Pro:** `placeholder` + `errorWidget` bawaan — loading state dan error state konsisten di semua tempat.
- **Pro:** Cache policy configurable — `memCacheWidth`, `memCacheHeight`, `maxWidthDiskCache`.
- **Pro:** Tidak perlu dependency baru — sudah ada di pubspec (`^3.4.1`).
- **Pro:** Community standard — 4k+ star, 6k+ score di pub.dev, maintenance aktif.
- **Kontra:** Perlu refactor di 11 file, beberapa dengan pola berbeda (`DecorationImage` perlu migrasi ke child widget).
- **Kontra:** Ukuran bundle + ~100 KB (cached_network_image + dio transitive dep).

### Opsi B: `Image.network` + custom cache wrapper (Status Quo)

Buat wrapper widget sendiri yang membungkus `Image.network` dengan `loadingBuilder`, `errorBuilder`, dan manual disk cache.

- **Pro:** Full control — bisa kustomisasi cache behavior sesuai kebutuhan Health Pal.
- **Kontra:** **Reinvent the wheel** — butuh ~200-300 baris kode untuk implementasi cache layer (file I/O, TTL, eviction policy, memory cache).
- **Kontra:** Maintenance burden — bug fix, testing, dan improvement jadi tanggung jawab internal.
- **Kontra:** Waktu implementasi ~8 jam vs ~2 jam migrasi ke CachedNetworkImage.
- **Kontra:** Tidak ada community support — issue ditemukan sendiri.

### Opsi C: `extended_image` package

Ganti dengan `extended_image: ^8.0.0` yang punya fitur lebih lengkap (cache, crop, zoom, paint transform).

- **Pro:** Fitur kaya — cache + edit + gesture.
- **Kontra:** **Overkill** untuk kebutuhan Health Pal — kita hanya butuh cache + placeholder + errorWidget.
- **Kontra:** Dependency baru — padahal `cached_network_image` sudah ada di pubspec.
- **Kontra:** Ukuran bundle lebih besar.
- **Kontra:** Learning curve baru untuk developer.

---

## 3. Keputusan

**Pilih Opsi A: Standarisasi SEMUA network image loading ke `CachedNetworkImage`.**

### Detail Keputusan

1. **Semua `Image.network()`** di 10 file diganti dengan `CachedNetworkImage` — pola seragam.
2. **`DecorationImage` + `NetworkImage`** di `banner_card.dart` dimigrasi: hapus `DecorationImage`, ganti dengan `CachedNetworkImage` sebagai child widget dalam `Container`/`Stack`.
3. **`profile_avatar.dart`** — tambah null check sebelum render image: `if (avatarUrl == null) return fallback`.
4. **Pola standar** untuk semua `CachedNetworkImage`:

   ```dart
   CachedNetworkImage(
     imageUrl: url,
     fit: BoxFit.cover,
     placeholder: (context, url) => _buildShimmer(context),    // shimmer atau loading indicator
     errorWidget: (context, url, error) => _buildFallback(),   // icon sesuai konteks
   )
   ```

5. **Placeholder pattern** — Gunakan `skeletonizer` shimmer effect (konsisten dengan ADR-001) atau widget `_Shimmer` yang sudah ada di `app_image_picker.dart`.
6. **Error fallback pattern** — Ikuti konteks:
   - **Doctor photo** → `Icons.person` / `AppIcons.user`
   - **Clinic cover** → `PlaceholderImage` (widget reusable yang sudah ada)
   - **User avatar** → Initial character fallback
   - **Banner** → Placeholder color (Container dengan background color)
7. **Cache policy** — Default `CachedNetworkImage` (disk cache indefinite). Jika perlu refresh di masa depan, gunakan `CachedNetworkImageProvider` dengan `maxAge` parameter atau panggil `imageCache.clear()`.

---

## 4. Alasan

1. **Eliminasi redundant network request** — Disk cache otomatis: foto dokter yang muncul di search list → card → detail → booking cukup di-download **sekali**, sisanya dari cache.
2. **Package sudah ada** — Tidak perlu nambah dependency. `cached_network_image: ^3.4.1` sudah terdaftar di pubspec sejak sprint sebelumnya, tapi tidak terpakai.
3. **Loading state konsisten** — Semua gambar punya placeholder (shimmer/indicator) saat loading, tidak ada lagi flash putih/kosong.
4. **Error state konsisten** — Error handling wajib di setiap `CachedNetworkImage`. `banner_card.dart` yang sebelumnya tanpa error handling otomatis mendapat `errorWidget`.
5. **Zero platform config** — Murni Dart package, tidak perlu edit `AndroidManifest.xml` atau `Info.plist`.
6. **Waktu migrasi minimal** — ~2 jam untuk refactor 11 file dengan pola seragam.
7. **Community & maintenance** — Package stable, update rutin, 4k+ bintang di GitHub.

---

## 5. Konsekuensi

### Positif

- ✅ Semua network image di-cache di disk — tidak ada re-fetch pada navigasi berulang.
- ✅ Semua tempat punya `placeholder` + `errorWidget` — UX lebih baik.
- ✅ `banner_card.dart` tidak lagi broken saat image gagal load.
- ✅ `profile_avatar.dart` tidak lagi mengirim request ke URL kosong.
- ✅ Satu dependency yang menganggur (`cached_network_image`) akhirnya terpakai.
- ✅ Pattern seragam — code review lebih mudah, developer onboarding lebih cepat.

### Negatif

- ⚠️ Ukuran bundle + ~100 KB (cached_network_image + transitive dep dio).
- ⚠️ `banner_card.dart` perlu perubahan arsitektur — `DecorationImage` di-refactor jadi child widget.
- ⚠️ Semua file yang dimigrasi perlu regression test untuk memastikan `placeholder`/`errorWidget` tidak broken.

### Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|----------|
| Cache tidak pernah expired — gambar lama tetap muncul walau sudah diganti di server | Default `CachedNetworkImage` menggunakan `cacheKey` dari URL. Jika URL server berubah (versioning), cache otomatis invalid. Jika perlu force refresh, gunakan `CachedNetworkImageProvider(url, maxAge: Duration(days: 7))`. |
| `CachedNetworkImage` mungkin tidak render di Flutter Web dengan benar | CachedNetworkImage versi 3.4.1 support Flutter Web via `Image.network` fallback. Test di Chrome setelah migrasi. |
| Developer tetap pakai `Image.network` di code baru | Enforce via code review + grep `Image\.network` di CI — return 0 setelah migrasi. |
| Migration `DecorationImage` ke child widget mengubah layout | Pastikan `aspectRatio`, `borderRadius`, `fit` dipertahankan identik. |

---

## 6. Compliance

Kepatuhan terhadap ADR ini di-enforce melalui:

| Mekanisme | Detail |
|---|---|
| **AGENTS.md** | Tambah Image Loading Rule — WAJIB pakai `CachedNetworkImage`, DILARANG pakai `Image.network` / `NetworkImage` |
| **Code Review** | DILARANG merge PR yang mengandung `Image.network` atau `NetworkImage` di `lib/` (kecuali `Image.file` untuk local file) |
| **CI/CD** | Script verifikasi: `Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" \| Select-String -Pattern "Image\.network\|NetworkImage"` harus return 0 hasil |
| **pubspec.yaml** | `cached_network_image` sudah ada — tidak perlu perubahan |
| **Todo List** | `docs/progress/cached_network_image_migration_todo.md` — daftar file dan status migrasi |

---

## 7. Referensi

- [cached_network_image package (pub.dev)](https://pub.dev/packages/cached_network_image)
- ADR 001: Skeletonizer — shimmer pattern untuk placeholder loading
- ADR 004: Specialization Icons — `Image.network` untuk SVG (akan dimigrasi setelah ADR ini)
- Dokumen yang diperbarui: `AGENTS.md`, `docs/progress/cached_network_image_migration_todo.md`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*