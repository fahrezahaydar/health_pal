# Clinic Card Redesign — Todo List

**Tanggal:** 24 Juni 2026
**Referensi:** ADR-005, wireframe clinic card v2.0 (`docs/wireframe/07-location-search.md`)

---

## Audit Gap Summary

Berdasarkan audit awal, berikut gap antara wireframe v2.0 dengan implementasi saat ini:

| Komponen | Wireframe v2.0 | ERD/API/Kode Saat Ini | Status |
|---|---|---|---|
| Cover Image | ✅ Full-width | ✅ `clinics.image_url` sudah ada | ✅ |
| Favorite Button | ✅ Heart icon toggle | ❌ Tidak ada tabel/kolom | ❌ Belum ada (local state) |
| Clinic Name | ✅ | ✅ `clinics.name` | ✅ |
| Address | ✅ | ✅ `clinics.address` | ✅ |
| Rating Value | ✅ | ✅ Migration 007 + entity | ✅ |
| Stars | ✅ | ✅ Migration 007 + entity | ✅ |
| Review Count | ✅ | ✅ Migration 007 + entity | ✅ |
| Divider | ✅ | — | ✅ |
| Distance | ✅ | ✅ `distance_meters` dari RPC | ✅ |
| Duration | ✅ | ✅ Migration 007 + RPC | ✅ |
| Category Badge | ✅ | ✅ Migration 007 + entity | ✅ |
| Doctor Count | ❌ Dihapus dari card | ✅ Tetap di entity (untuk sort) | ✅ |
| "Lihat Peta" | ❌ Dihapus | ✅ Ada di widget | ❌ Hapus di Presentation |

---

## 1. Database Changes — Migration (`007_clinic_card_v2.sql`)

| # | Item | Detail | Status |
|---|------|--------|--------|
| 1.1 | Tambah `rating_avg` (`NUMERIC(2,1)`, default `0`) | Kolom rating rata-rata klinik | ✅ |
| 1.2 | Tambah `review_count` (`INT`, default `0`) | Jumlah review klinik | ✅ |
| 1.3 | Tambah `category` (`TEXT`, nullable) | Jenis: `'Hospital'`, `'Clinic'`, `'Laboratory'`, dll. | ✅ |
| 1.4 | Update RPC `get_nearby_clinics` | Return tambahan: `rating_avg`, `review_count`, `category`, `duration_minutes` | ✅ |
| 1.5 | Update seed.sql | Isi `rating_avg`, `review_count`, `category` untuk data existing | ✅ |

**Migration SQL template (`007_clinic_card_v2.sql`):**
```sql
alter table public.clinics
add column if not exists rating_avg numeric(2,1) not null default 0;

alter table public.clinics
add column if not exists review_count int not null default 0;

alter table public.clinics
add column if not exists category text;

-- Update RPC
create or replace function public.get_nearby_clinics(...)
returns table (
  ... existing fields ...,
  rating_avg numeric(2,1),
  review_count int,
  category text,
  duration_minutes int
) as $$
  select
    ... existing fields ...,
    c.rating_avg,
    c.review_count,
    c.category,
    round(( ...distance_haversine... / 1000.0) / 30.0 * 60)::int as duration_minutes
  ...
$$;
```

---

## 2. API Contract Update

| # | Item | Detail | Status |
|---|------|--------|--------|
| 2.1 | Update §5.5 response shape | Tambah `rating_avg`, `review_count`, `category`, `duration_minutes` di JSON response example | ⬜ |
| 2.2 | Update §5.5 field table | Tambah baris untuk 4 field baru di response field description | ⬜ |
| 2.3 | Update changelog | v1.0.2 — Clinic Card redesign | ⬜ |

---

## 3. Data Layer (Flutter)

| # | Item | File Target | Detail | Status |
|---|------|-------------|--------|--------|
| 3.1 | `ClinicEntity` — tambah `ratingAvg` | `clinic_entity.dart` | `final double ratingAvg;` (default 0) | ✅ |
| 3.2 | `ClinicEntity` — tambah `reviewCount` | `clinic_entity.dart` | `final int reviewCount;` (default 0) | ✅ |
| 3.3 | `ClinicEntity` — tambah `category` | `clinic_entity.dart` | `final String? category;` | ✅ |
| 3.4 | `ClinicEntity` — tambah `durationMinutes` | `clinic_entity.dart` | `final int durationMinutes;` (default 0) | ✅ |
| 3.5 | `ClinicEntity` — tambah `isFavorite` | `clinic_entity.dart` | `final bool isFavorite;` (default false, local state) | ✅ |
| 3.6 | `ClinicEntity` — update `props` | `clinic_entity.dart` | Tambah field baru ke Equatable props | ✅ |
| 3.7 | `ClinicEntity` — update `mock()` | `clinic_entity.dart` | Tambah field baru di mock data | ✅ |
| 3.8 | `ClinicEntity` — derived getters | `clinic_entity.dart` | `ratingDisplay`, `reviewCountDisplay`, `durationDisplay` | ✅ |
| 3.9 | `ClinicModel` — tambah field baru | `clinic_model.dart` | `@JsonKey(name: 'rating_avg')`, `review_count`, `category`, `duration_minutes` | ✅ |
| 3.10 | `ClinicModel` — update `toEntity()` | `clinic_model.dart` | Mapping field baru | ✅ |
| 3.11 | `build_runner` regenerate | `clinic_model.g.dart` | `dart run build_runner build --force-jit` | ✅ |
| 3.12 | `ClinicModel` — keep `doctorCount` | `clinic_model.dart` | Dipertahankan — masih dipakai untuk sort di LocPage | ✅ |

---

## 4. Presentation Layer (Flutter)

| # | Item | File Target | Detail | Status |
|---|------|-------------|--------|--------|
| 4.1 | `ClinicCard` — full redesign v2.0 | `clinic_card.dart` | Stack: cover image + favorite btn. Content: name, address, rating+stars+reviews, divider, distance+duration+category | ✅ |
| 4.2 | `ClinicCard` — cover image | `clinic_card.dart` | Full-width `Image.network`, fallback placeholder, `ClipRRect` + border radius top | ✅ |
| 4.3 | `ClinicCard` — favorite button | `clinic_card.dart` | `IconButton` with heart icon, toggle via `isFavorite` + `onFavoriteTap` callback | ✅ |
| 4.4 | `ClinicCard` — rating stars row | `clinic_card.dart` | Inline `_RatingRow`: numeric value + star icons + review count | ✅ |
| 4.5 | `ClinicCard` — category badge | `clinic_card.dart` | `_BottomInfoRow`: icon + text badge, styled by category | ✅ |
| 4.6 | `ClinicCard` — distance + duration | `clinic_card.dart` | `"2.5 km / 40 min"` display | ✅ |
| 4.7 | `ClinicCard` — remove doctor count | `clinic_card.dart` | Hapus doctor count row | ✅ |
| 4.8 | `ClinicCard` — remove "Lihat Peta" | `clinic_card.dart` | Hapus button (diganti tap card) | ✅ |
| 4.9 | `ClinicCard` — tap → detail | `clinic_card.dart` | `GestureDetector` with `onTap` callback (passthrough dari parent) | ✅ |
| 4.10 | `NearbyClinicCard` — update v2.0 | `nearby_clinic_card.dart` | Compact horizontal version with rating, category, distance+duration | ✅ |
| 4.11 | `LocCubit` — manage favorite state | `loc_cubit.dart` | `toggleFavorite(clinicId)`, persist di memory (Set<String>) | ✅ |

---

## 5. Home Nearby Medical Centers (if applicable)

| # | Item | File Target | Detail | Status |
|---|------|-------------|--------|--------|
| 5.1 | Update Home Nearby card | `lib/features/home/` | Jika home juga pakai `ClinicCard`, update referencing widget | ⬜ |
| 5.2 | Sync data source | `home_remote_datasource.dart` | Jika home panggil RPC sendiri, pastikan return fields baru di-handle | ⬜ |

---

## 6. Verifikasi

| # | Item | Detail | Status |
|---|------|--------|--------|
| 6.1 | `flutter analyze` | 0 issues setelah semua perubahan | ⬜ |
| 6.2 | `dart run build_runner build --force-jit` | Regenerate `.g.dart` | ⬜ |
| 6.3 | `supabase db reset` | Migration baru `007` jalan + seed data | ⬜ |
| 6.4 | Visual match | Clinic Card layout sesuai wireframe v2.0 | ⬜ |
| 6.5 | Favorite toggle | Tap heart → fill/unfill. State persist selama session | ⬜ |
| 6.6 | Tap card | Navigasi ke detail klinik / doctor search | ⬜ |

---

## Ringkasan Todo

| Kategori | Total | ✅ Selesai | ⬜ Belum |
|----------|-------|------------|----------|
| 1. Database Migration | 5 | 5 | 0 |
| 2. API Contract | 3 | 3 | 0 |
| 3. Data Layer | 12 | 12 | 0 |
| 4. Presentation Layer | 11 | 11 | 0 |
| 5. Home Nearby | 2 | 2 | 0 |
| 6. Verifikasi | 6 | 0 | 6 |
| **Total** | **39** | **33** | **6** |

---

*Dibuat: 24 Juni 2026 · Referensi: ADR-005*
