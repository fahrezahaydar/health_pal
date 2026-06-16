# Sprint 4.5 Plan — Map View (flutter_map)

| Field | Detail |
|---|---|
| **Project** | health_pal |
| **Versi Dokumen** | v1.0 |
| **Tanggal** | 16 Juni 2026 |
| **Sprint Window** | TBD (1 minggu setelah Sprint 4) |
| **Tema Sprint** | **"Map View — flutter_map Implementation (ADR 002)"** |
| **Acuan** | `docs/adr/002_map_view.md` · `wireframe/07-location-search.md` · `api_contract_health_pal.md` §5.5 |
| **Tech Lead** | MiniMax-M3 |
| **Testing Policy** | **❌ NO TEST FILES** (deferred ke Sprint 9) |

---

## 📊 Sprint 4.5 Progress Tracker

**Last Updated:** 16 Juni 2026
**Overall:** 0/5 tasks (0%)

| Task | Deskripsi | Estimasi | Status | Commit | Catatan |
|------|-----------|:--------:|--------|--------|---------|
| M1 | Add flutter_map + latlong2 ke pubspec + `pub get` | 0.5h | ⬜ Not Started | — | ADR 002: flutter_map: ^7.0.0, latlong2: ^0.9.0 |
| M2 | Buat `LocMapWidget` — reusable map dengan tile OSM | 3h | ⬜ Not Started | — | FlutterMap + TileLayer + MarkerLayer dasar |
| M3 | Integrasi map ke LocPage (atas list, split view) | 2h | ⬜ Not Started | — | Map 40% screen + clinic list 60%, pin sesuai clinics |
| M4 | Pin marker + tap → info klinik | 2h | ⬜ Not Started | — | Marker dari clinic.lat/lng, tap → show clinic name |
| M5 | Animated camera follow user + radius circle | 1.5h | ⬜ Not Started | — | Camera ke posisi user, lingkaran radius 5/10km |

**Total:** ~9h

---

## 1. Latar Belakang

ADR 002 memutuskan menggunakan `flutter_map` + OpenStreetMap sebagai satu-satunya map view package. Loc tab saat ini list-only — Sprint 4.5 akan menambahkan map view di atas list (split view: map 40% + list 60%).

### Alasan Sprint 4.5 (terpisah dari Sprint 5 Doctor)

| Alasan | Detail |
|--------|--------|
| **Map view independen** | Tidak ada dependency ke feature Doctor |
| **Loc tab sudah siap** | Loc tab sudah complete (Sprint 4) — map tinggal ditambahkan |
| **Fokus** | Sprint 5 Doctor cukup besar (25 files) tanpa diganggu map |
| **Quick win** | flutter_map bisa selesai 1-2 hari |

---

## 2. Task Details

### M1: Add Dependencies (0.5h)

```yaml
# pubspec.yaml
dependencies:
  flutter_map: ^7.0.0
  latlong2: ^0.9.0
```

`flutter pub get` — no platform config needed (pure Dart).

### M2: Buat LocMapWidget (3h)

File baru: `lib/features/loc/presentation/widget/loc_map_widget.dart`

```dart
class LocMapWidget extends StatelessWidget {
  final List<ClinicEntity> clinics;
  final double? userLat;
  final double? userLng;
  final void Function(ClinicEntity clinic)? onMarkerTap;
  // ...
}
```

**Spec per ADR 002:**
- `FlutterMap` with `MapOptions` (center: user position, zoom: 13)
- `TileLayer` — OpenStreetMap tiles (`https://tile.openstreetmap.org/{z}/{x}/{y}.png`)
- `MarkerLayer` — pin untuk setiap clinic
- Tap marker → callback `onMarkerTap`
- `ClipRRect` + border radius konsisten dengan card lain

### M3: Integrasi ke LocPage (2h)

**Layout change:**
```
┌──────────────────────┐
│       Map View       │  ← LocMapWidget (40% height)
│   (40% screen)       │
├──────────────────────┤
│ Filter Chips + Sort  │  ← existing
├──────────────────────┤
│ Clinic List (60%)    │  ← existing ListView
│                      │
└──────────────────────┘
```

**Implementation:**
- `_loaded()` method → Column with `Expanded(flex: 2)` for map, `Expanded(flex: 3)` for list
- Or `SizedBox` with fixed height ratio
- Pass clinics list + position to `LocMapWidget`

### M4: Pin Marker + Tap Info (2h)

- `Marker` points: `LatLng(clinic.latitude, clinic.longitude)`
- Marker icon: `Icon(Icons.local_hospital, color: AppTheme.primary, size: 32)`
- Tap marker → show `PopupCard` or `SnackBar` with clinic name
- Future enhancement: info window widget (Sprint 6+)

### M5: Animated Camera + Radius Circle (1.5h)

- `MapController` → `animatedMapMove()` to user position on load
- Show circle overlay for search radius
- `flutter_map_animations` (optional plugin) for smooth camera transitions

---

## 3. Timeline

| Day | Tasks |
|:---:|-------|
| 1 | M1 — pubspec + pub get |
| 2 | M2 — LocMapWidget |
| 3 | M3 — Integrasi LocPage |
| 4 | M4 — Pin + tap info |
| 5 | M5 — Camera + radius |

---

## 4. Definition of Done

- [ ] `flutter_map` + `latlong2` di pubspec ✅
- [ ] `flutter analyze` 0 issues
- [ ] Map view muncul di atas Loc tab (40% screen)
- [ ] Pin marker untuk setiap clinic
- [ ] Tap marker → menampilkan nama klinik
- [ ] Camera mengikuti posisi user saat load
- [ ] Tidak ada API key / platform config

---

## 5. Referensi

- `docs/adr/002_map_view.md` — ADR lengkap dengan rationale, opsi, compliance
- `docs/wireframe/07-location-search.md` — wireframe map section
- `flutter_map` pub.dev: [https://pub.dev/packages/flutter_map](https://pub.dev/packages/flutter_map)

---

*Disusun oleh Tech Lead (MiniMax-M3) · 16 Juni 2026 · v1.0*
*Berdasarkan: ADR 002 — Map View Package untuk Location Tab & Nearby Facilities*
