# Doctor Card Redesign — Todo List

**Tanggal:** 27 Juni 2026
**Referensi:** ADR-007, wireframe doctor card v2.0 (`docs/wireframe/08-doctor-search.md`)

---

## 1. Database Changes (Backend)

**Tidak ada perubahan —** semua field yang dibutuhkan sudah ada di tabel `doctors`:

| Field | ERD | Status |
|-------|-----|--------|
| `photo_url` | ✅ `TEXT` | OK |
| `rating_avg` | ✅ `NUMERIC(3,2)` | OK |
| `rating_count` | ✅ `INT4` | OK |

Favorite state dikelola local di cubit (`Set<String>`), tidak perlu tabel `favorites` di MVP.

---

## 2. API Contract Update

**Tidak ada perubahan —** endpoint `GET /rest/v1/doctors` sudah return `rating_avg` dan `rating_count`.

Favorite toggle tidak perlu API — state lokal cukup untuk MVP.

---

## 3. Data Layer (Flutter)

**Tidak ada perubahan —** `DoctorEntity` dan `DoctorModel` sudah punya semua field.

| Field | Entity | Model | Status |
|-------|--------|-------|--------|
| `photoUrl` | ✅ | ✅ | OK |
| `ratingAvg` | ✅ | ✅ | OK |
| `ratingCount` | ✅ | ✅ | OK |
| `specializationName` | ✅ (derived) | ✅ | OK |
| `clinicName` | ✅ (derived) | ✅ | OK |
| `isFavorite` | ❌ — tidak perlu | ❌ — tidak perlu | Sengaja local state |

---

## 4. Presentation Layer (Flutter)

| # | Item | File Target | Estimasi | Status |
|---|------|-------------|----------|--------|
| 1 | **Redesign DoctorCard widget** — layout horizontal, image 1:1, divider, favorite, rating+review | `lib/widgets/card/doctor_card.dart` | 30 menit | ⬜ |
| 2 | Update parameter: tambah `reviewCount`, `isFavorite`, `onFavoriteTap`; hapus `fee` | `doctor_card.dart` | (include di #1) | ⬜ |
| 3 | Update `DoctorCard.fromEntity` — include `entity.ratingCount` | `doctor_card.dart` | 5 menit | ⬜ |
| 4 | Update `doctor_search_page.dart` — pass `reviewCount`, `isFavorite`, `onFavoriteTap` | `doctor_search_page.dart` | 10 menit | ⬜ |
| 5 | Update `favorite_page.dart` — pass `reviewCount`, `isFavorite`, `onFavoriteTap` | `favorite_page.dart` | 10 menit | ⬜ |
| 6 | State management: `Set<String>` favorite IDs + `toggleFavorite` di SearchCubit (atau cubit yang relevan) | `search_cubit.dart` atau `loc_cubit.dart` | 15 menit | ⬜ |

### Catatan Implementasi

**Pattern Favorite State:**
```dart
// Di cubit (misal SearchCubit)
final Set<String> _favoriteDoctorIds = {};

void toggleFavorite(String doctorId) {
  if (_favoriteDoctorIds.contains(doctorId)) {
    _favoriteDoctorIds.remove(doctorId);
  } else {
    _favoriteDoctorIds.add(doctorId);
  }
  emit(state.copyWith(favoriteIds: Set.of(_favoriteDoctorIds)));
}
```

**DoctorCard.fromEntity (update):**
```dart
factory DoctorCard.fromEntity(
  DoctorEntity entity, {
  bool isFavorite = false,
  VoidCallback? onTap,
  VoidCallback? onFavoriteTap,
}) {
  return DoctorCard(
    name: entity.fullName,
    specialization: entity.specializationName,
    rating: entity.ratingAvg,
    reviewCount: entity.ratingCount,
    clinic: entity.clinicName,
    photoUrl: entity.photoUrl,
    isFavorite: isFavorite,
    onTap: onTap,
    onFavoriteTap: onFavoriteTap,
  );
}
```

---

## 5. Verifikasi

| # | Item | Status |
|---|------|--------|
| 1 | `dart run build_runner build --force-jit` — 0 error | ⬜ |
| 2 | `flutter analyze` — 0 issues | ⬜ |
| 3 | Visual match dengan wireframe v2.0 | ⬜ |
| 4 | Favorite toggle berfungsi — icon berubah outline ↔ filled | ⬜ |
| 5 | Favorite state sync antara Search page ↔ Favorite page | ⬜ |
| 6 | Foto 1:1 tampil benar (tidak stretch) dengan CachedNetworkImage | ⬜ |
| 7 | Rating row tidak tampil jika `ratingCount == 0` | ⬜ |
| 8 | DoctorCard di Favorite page tetap tampil saat offline (dari cache) | ⬜ |
| 9 | Skeletonizer loading state DoctorCard tidak broken | ⬜ |

---

## 6. Blast Radius

| Consumer | File | Perubahan |
|----------|------|-----------|
| ✅ Doctor Search | `doctor_search_page.dart:264` | Update parameter DoctorCard (tambah reviewCount, isFavorite, onFavoriteTap; hapus fee) |
| ✅ Favorite Page | `favorite_page.dart:70` | Update parameter DoctorCard (tambah reviewCount, isFavorite, onFavoriteTap; hapus fee) |
| ❌ Tidak ada consumer lain | — | `grep -rln "DoctorCard(" lib/` hanya return 2 file di atas |

---

*Dibuat: 27 Juni 2026 · Referensi: ADR-007*