# ADR 002: Map View Package untuk Location Tab & Nearby Facilities

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 16 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | Arsitektur UI (map rendering, permission handling) + pubspec dependencies + API key management |

---

## 1. Konteks

Health Pal menampilkan peta interaktif di dua tempat:

| Lokasi | Kebutuhan |
|---|---|
| **Location tab** (`/loc`) | Map view dengan pin klinik terdekat, filter spesialisasi, sort |
| **Nearby Facilities** (Home — Sprint 5) | Mini map inline + pin fasilitas terdekat |
| **Doctor Detail** (`/doctor/:id`) | Mini map lokasi klinik (inline, bukan link external) |

Sebelum ADR ini, terdapat beberapa referensi yang saling tumpang tindih:

| Sumber | Menyebut | Catatan |
|---|---|---|
| PRD §2 — Tech Stack | `flutter_map` (OpenStreetMap) | *Google Maps diganti Sprint 4 — ADR: gratis, no API key* |
| PRD §4 — Fitur Peta | `flutter_map` | *Deferred ke Sprint 5 (AD-8: gratis, no API key)* |
| Wireframe `07-location-search.md` | `Google Map` di ASCII, `FlutterMap` di component table | *Deferred ke Sprint 5 via flutter_map* |
| `08-facility-todo.md` D.2 | `google_maps_flutter` ❌ Belum di pubspec | *Untuk map view di Location tab* |
| `USER_FLOW.md` §5.2 | `Google Maps + pin klinik` | Flow diagram |
| `clinic_card.dart` | `_openMaps()` → URL Google Maps external | Existing fallback |

Kondisi saat ini:
- **Tidak ada map package** di pubspec.
- **Tidak ada API key** untuk Google Maps atau Mapbox di `.env`.
- Location tab sudah diimplementasikan sebagai list saja (tanpa map).
- Mini map di Doctor Detail masih berupa link external (`_openMaps` → Google Maps URL).

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: `google_maps_flutter: ^2.10.0`

| Item | Detail |
|---|---|
| **Tile Provider** | Google Maps API (raster/vector tiles) |
| **Biaya** | Pay-as-you-go setelah $200/bulan free credit (usage-based) |
| **API Key** | WAJIB — Google Cloud Console |
| **Fitur** | Street View, Indoor maps, Places autocomplete, Traffic layer |
| **Platform** | Android + iOS (native SDK) |

**Pro:**
- Paling mature — community support besar, dokumentasi lengkap.
- UI/UX familiar bagi user Indonesia (Google Maps adalah default map app).
- Fitur lengkap: marker clustering, info window kustom, animated camera.

**Kontra:**
- **WAJIB API key** — harus ngurus Google Cloud billing, risiko exposure key.
- **Biaya** — meskipun ada $200 free credit, risiko tagihan jika usage melebihi.
- **Ukuran bundle** — native SDK tambah ~30 MB (Android) + ~20 MB (iOS).
- **Build complexity** — perlu konfigurasi `GoogleMaps.plist`, `AndroidManifest.xml`, API key restriction, SHA-1 fingerprint.
- **Gesekan developer** — tiap developer baru harus setup Google Cloud project + enable Maps SDK.

### Opsi B: `flutter_map: ^7.0.0` + `latlong2: ^0.9.0` (DIUSULKAN)

| Item | Detail |
|---|---|
| **Tile Provider** | OpenStreetMap (default) — bebas, gratis, tanpa API key |
| **Biaya** | **Gratis** — OSM tiles tidak perlu API key atau billing |
| **API Key** | **Tidak diperlukan** |
| **Fitur** | Marker, polyline, polygon, tile layers, custom tile providers |
| **Platform** | Flutter murni (Canvas) — tidak perlu platform-specific SDK |

**Pro:**
- **Zero cost** — tidak perlu API key, tidak perlu billing setup.
- **Zero platform config** — tidak perlu `AndroidManifest.xml` edit, `GoogleMaps.plist`, SHA-1, dll.
- **Entirely Dart** — semua rendering via Flutter Canvas, mudah di-debug.
- **Sama dengan PRD** — flutter_map adalah rekomendasi PRD sejak awal.
- **Ukuran bundle minimal** — ~500 KB (pure Dart, tanpa native SDK).
- **Plugin ecosystem** — `flutter_map_marker_cluster`, `flutter_map_cancellable_tile_provider`, `flutter_map_animations`.
- **Tile provider fleksibel** — bisa ganti ke Mapbox/Stadia/Thunderforest tiles tanpa ganti package.

**Kontra:**
- **Tidak ada Street View** — tidak bisa implementasi "Lihat lokasi 360°".
- **Tidak ada Places Autocomplete** — harus build sendiri atau pakai `google_maps_places` terpisah.
- **Marker clustering butuh plugin tambahan** (`flutter_map_marker_cluster`).
- **Performa** — untuk 100+ marker simultan mungkin butuh optimasi (`MarkerLayer` vs custom canvas).
- **UI tidak se-familiar Google Maps** — OSM tiles look sedikit berbeda.

### Opsi C: `mapbox_maps_flutter: ^2.0.0`

| Item | Detail |
|---|---|
| **Tile Provider** | Mapbox Vector Tiles (GL style JSON) |
| **Biaya** | 100k map loads/bulan gratis — $0.50/1000 setelahnya |
| **API Key** | WAJIB — Mapbox access token |
| **Fitur** | 3D terrain, custom style, real-time traffic, globe view |

**Pro:**
- Tile lebih modern + kustomisasi style tinggi.
- Mapbox Navigation SDK untuk booking transportasi (future).

**Kontra:**
- **API key tetap wajib** — meskipun Mapbox, tetap perlu access token.
- **Biaya** — gratis tier cukup (100k loads/bulan), tapi perlu monitor.
- **Bundle size** — native SDK, mirip Google Maps.
- **Community lebih kecil** — issue response lebih lambat.
- **Mapbox pricing berubah-ubah** — 2023 Mapbox batasi free tier jadi 100k.

### Opsi D: Custom WebView + Leaflet.js

| Item | Detail |
|---|---|
| **Tile Provider** | OpenStreetMap (via Leaflet) |
| **Biaya** | Gratis |
| **API Key** | Tidak diperlukan |
| **Fitur** | CSS/JS kustom penuh, plugin Leaflet raya |

**Pro:**
- Full control via HTML/CSS/JS.
- Tidak perlu Flutter package map — semua logika di web.

**Kontra:**
- **UX tidak native** — WebView terasa lambat, scroll conflict dengan Flutter.
- **Bridge communication** — Flutter ↔ JS bridge untuk pin/marker.
- **Memory** — WebView consume ~50-100 MB RAM + WebView engine.
- **Maintenance** — 2 codebase (Flutter + Leaflet JS).
- **Offline** — sulit handle offline tiles di WebView.

---

## 3. Keputusan

**Pilih Opsi B: `flutter_map: ^7.0.0` + `latlong2: ^0.9.0` sebagai satu-satunya map view package.**

### Detail Keputusan

1. **Tambah `flutter_map: ^7.0.0`** ke pubspec.
2. **Tambah `latlong2: ^0.9.0`** ke pubspec (dependency umum flutter_map untuk koordinat).
3. **Tambah `flutter_map_marker_cluster: ^1.6.0`** untuk marker clustering jika jumlah pin > 50.
4. **Tambah `geolocator: ^12.0.0`** untuk mendapatkan lokasi user (opsional — bisa manual input kota).
5. **Default tile provider: OpenStreetMap** — tidak perlu API key, bebas biaya.
6. **Future tile upgrade path** — jika ingin tile lebih cantik di rilis berikutnya:
   - Ganti ke **Mapbox Raster Tiles** (cukup set `urlTemplate` + `apiKey` tanpa ganti package).
   - Atau ke **Stadia / Thunderforest** tiles (berbayar, $20-50/bulan).
7. **Tidak perlu konfigurasi platform** — tidak ada edit `AndroidManifest.xml`, `GoogleMaps.plist`, atau API key restriction.

```dart
// Contoh implementasi (Location tab — map view)
FlutterMap(
  options: MapOptions(
    center: LatLng(userLat, userLng),
    zoom: 13.0,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.healthpal.app',
    ),
    MarkerLayer(
      markers: clinics.map((c) => Marker(
        point: LatLng(c.latitude, c.longitude),
        child: Icon(Icons.location_on, color: Colors.red),
      )).toList(),
    ),
  ],
)
```

---

## 4. Alasan

1. **Zero cost, zero friction** — tanpa API key, tanpa setup Google Cloud, tanpa risiko billing exposure. Developer cukup `flutter pub add` dan langsung jalan.
2. **PRD alignment** — ADR ini menegaskan keputusan PRD (Sprint 4 — gratis, no API key) yang sebelumnya masih ambigu antara `flutter_map` dan `google_maps_flutter`.
3. **Time to market** — implementasi map view bisa selesai dalam **1 hari** (setup + marker + permission handler) vs **3-5 hari** untuk `google_maps_flutter` (setup API key + platform config + review Google Terms).
4. **Eliminasi risiko billing** — Google Maps dan Mapbox sama-sama punya risiko tagihan tak terduga. OSM gratis selamanya.
5. **Fleksibilitas tile provider** — `flutter_map` mendukung OSM, Mapbox, Stadia, Thunderforest, dan custom tile URL. Bisa upgrade tiles kapan saja tanpa migrasi package.
6. **Ekosistem plugin cukup** — clustering, animation, cancellable tiles, polyline — semua ada sebagai plugin flutter_map.
7. **Ukuran bundle** — flutter_map ~500 KB vs google_maps_flutter ~50 MB. Signifikan untuk APK size.

---

## 5. Konsekuensi

### Positif

- ✅ Setup instan — `flutter pub add flutter_map` siap pakai.
- ✅ Tidak ada dependency pada Google Cloud / Mapbox account.
- ✅ Konfigurasi zero-platform — satu kode untuk semua platform.
- ✅ APK size jauh lebih kecil (estimasi -30 MB dari alternatif native SDK).
- ✅ Semua developer (termasuk kontributor baru) bisa langsung build tanpa setup API key.

### Negatif

- ⚠️ Tidak bisa pakai **Google Street View** — untuk "virtual tour klinik" butuh solusi alternatif (foto 360° gallery).
- ⚠️ Tidak bisa pakai **Google Places Autocomplete** — input kota fallback manual atau pakai `flutter_typeahead` + data dari database.
- ⚠️ OSM tiles tampilan lebih "plain" — tanpa label jalan yang rapi seperti Google Maps.
- ⚠️ Marker clustering butuh plugin tambahan (`flutter_map_marker_cluster`).

### Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| OSM tile server kadang lambat | Gunakan `flutter_map_cancellable_tile_provider` + fallback tile provider |
| Tampilan OSM kurang "premium" untuk aplikasi health | Upgrade tile provider ke Mapbox raster tiles tanpa ganti package (harga ~$50/bulan) — direncanakan untuk v1.1 |
| Marker 100+ menyebabkan lag | Gunakan `flutter_map_marker_cluster` atau `MarkerLayer` dengan custom widget ringan |
| Geolocation permission tidak diberikan | Fallback input kota manual (sudah ada di wireframe) |

---

## 6. Compliance

Kepatuhan terhadap ADR ini di-enforce melalui:

| Mekanisme | Detail |
|---|---|
| **AGENTS.md** | Tambah entry Map View Rule — flutter_map sebagai default, tanpa google_maps_flutter |
| **Code Review** | DILARANG merge PR yang menambahkan `google_maps_flutter` atau API key map tanpa persetujuan CTO |
| **pubspec.yaml** | Hanya `flutter_map` + `latlong2` yang diizinkan sebagai map dependency |
| **CI/CD** | Tidak perlu Google API key build environment — semua build menggunakan OSM tiles |
| **Dokumentasi** | UPDATE: `docs/adr/`, `docs/product/prd_health_pal.md`, `docs/wireframe/07-location-search.md`, `docs/todo/08-facility-todo.md` |

---

## 7. Referensi

- [flutter_map package (pub.dev)](https://pub.dev/packages/flutter_map)
- [latlong2 package (pub.dev)](https://pub.dev/packages/latlong2)
- [flutter_map_marker_cluster (pub.dev)](https://pub.dev/packages/flutter_map_marker_cluster)
- [geolocator package (pub.dev)](https://pub.dev/packages/geolocator)
- [OpenStreetMap Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/)
- ADR ini meng-override: `docs/todo/08-facility-todo.md` §D.2 (google_maps_flutter), `docs/product/prd_health_pal.md` §2 (Maps & Geolocation — final choice flutter_map)
- Dokumen yang diperbarui: `AGENTS.md`, `pubspec.yaml`, `docs/wireframe/07-location-search.md`, `docs/todo/08-facility-todo.md`, `docs/product/prd_health_pal.md`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
