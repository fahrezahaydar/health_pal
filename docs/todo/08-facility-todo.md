# Facility — Nearby Medical Centers

> Referensi: `docs/wireframe/06-home.md` §6, `docs/erd/erd_healh_pal.md`, `docs/api_contract/api_contract_health_pal.md`

## Overview

Menampilkan fasilitas kesehatan (klinik/rumah sakit) terdekat berdasarkan lokasi user. Section ini ada di Home Page (bawah categories) dan Location tab.

**Posisi dalam roadmap:** Sebelum Push Notification (Fase 10).

---

## Data Model

### Tabel `clinics` (sudah ada)

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | `UUID` PK | |
| `name` | `TEXT` | Nama klinik / RS |
| `address` | `TEXT` | Alamat lengkap |
| `city` | `TEXT` | Kota (filter kasar) |
| `latitude` | `FLOAT8` | Koordinat lintang |
| `longitude` | `FLOAT8` | Koordinat bujur |
| `phone` | `TEXT` | Nomor telepon |
| `image_url` | `TEXT` | Foto klinik |
| `created_at` | `TIMESTAMPTZ` | Auto |

### Relasi

`doctors.clinic_id → clinics.id` (sudah ada)

---

## API Endpoints

### 1. Nearby Clinics (RPC)

```http
POST /rest/v1/rpc/get_nearby_clinics
```

**Request Body:**

```json
{
  "user_lat": -6.2088,
  "user_lng": 106.8456,
  "radius_meters": 10000
}
```

**Response:**

```json
[
  {
    "id": "uuid",
    "name": "Klinik Sehat Bersama",
    "address": "Jl. Sudirman No. 123",
    "city": "Jakarta",
    "latitude": -6.2100,
    "longitude": 106.8470,
    "phone": "021-1234567",
    "image_url": "https://...",
    "distance_meters": 1200,
    "doctor_count": 5
  }
]
```

**Keterangan:**

- PostgreSQL function `get_nearby_clinics` dengan Haversine formula
- Return `distance_meters` (jarak dari user dalam meter)
- Return `doctor_count` (jumlah dokter aktif di klinik)
- Ordered by `distance_meters` ASC
- Filter: `distance_meters <= radius_meters`

### 2. Clinic Detail

```http
GET /rest/v1/clinics?id=eq.<clinic_id>&select=*,doctors(*,specializations(*))
```

---

## PostgreSQL Function

```sql
CREATE OR REPLACE FUNCTION get_nearby_clinics(
  user_lat FLOAT8,
  user_lng FLOAT8,
  radius_meters INT DEFAULT 10000
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  address TEXT,
  city TEXT,
  latitude FLOAT8,
  longitude FLOAT8,
  phone TEXT,
  image_url TEXT,
  distance_meters FLOAT8,
  doctor_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    c.id,
    c.name,
    c.address,
    c.city,
    c.latitude,
    c.longitude,
    c.phone,
    c.image_url,
    (
      6371000 * ACOS(
        COS(RADIANS(user_lat)) * COS(RADIANS(c.latitude)) *
        COS(RADIANS(c.longitude) - RADIANS(user_lng)) +
        SIN(RADIANS(user_lat)) * SIN(RADIANS(c.latitude))
      )
    )::FLOAT8 AS distance_meters,
    (SELECT COUNT(*) FROM doctors d WHERE d.clinic_id = c.id AND d.is_active = true)::BIGINT AS doctor_count
  FROM clinics c
  WHERE (
    6371000 * ACOS(
      COS(RADIANS(user_lat)) * COS(RADIANS(c.latitude)) *
      COS(RADIANS(c.longitude) - RADIANS(user_lng)) +
      SIN(RADIANS(user_lat)) * SIN(RADIANS(c.latitude))
    )
  ) <= radius_meters
  ORDER BY distance_meters ASC;
END;
$$ LANGUAGE plpgsql;
```

---

## Dependencies

| Komponen | Status | Keterangan |
|---|---|---|
| `google_maps_flutter` | ❌ Belum di pubspec | Untuk map view di Location tab |
| `geolocator` | ❌ Belum di pubspec | Untuk ambil lokasi user |
| Route `/facilities/:id` | ❌ Belum ada | Clinic detail page |
| Route `/facilities` | ❌ Belum ada | Facility list page |
| Edge Function | ❌ Belum ada | Tidak diperlukan (pakai RPC langsung) |

---

## Task Breakdown

### Blok A: Data Layer

| # | Task | File | Keterangan |
|---|---|---|---|
| A.1 | `FacilityEntity` | `home/domain/entity/facility_entity.dart` | `id`, `name`, `address`, `city`, `latitude`, `longitude`, `phone`, `imageUrl`, `distanceMeters`, `doctorCount` |
| A.2 | `FacilityModel` | `home/data/model/facility_model.dart` | fromJson + toEntity |
| A.3 | PostgreSQL migration | `supabase/migrations/003_nearby_function.sql` | Function `get_nearby_clinics` |

### Blok B: Domain Layer

| # | Task | File | Keterangan |
|---|---|---|---|
| B.1 | `HomeRepository` — tambah `getNearby(lat, lng)` | `home/domain/repository/home_repository.dart` | Interface |
| B.2 | `HomeRemoteDataSource` — tambah `getNearby()` | `home/data/datasource/home_remote_datasource.dart` | RPC call |
| B.3 | `HomeRepositoryImpl` — implement `getNearby()` | `home/data/repository/home_repository_impl.dart` | |
| B.4 | `GetNearbyFacilitiesUseCase` | `home/domain/usecase/get_nearby_facilities_usecase.dart` | @injectable |

### Blok C: Presentation Layer

| # | Task | File | Keterangan |
|---|---|---|---|
| C.1 | `FacilityCubit` + `FacilityState` | `home/presentation/bloc/facility/` | Sealed state: Initial/Loading/Loaded/Error |
| C.2 | `NearbyFacilities` widget | `home/presentation/widget/nearby_facilities.dart` | Horizontal list, tap → detail |
| C.3 | Integrasi ke HomePage | `home/presentation/page/home_page.dart` | Tambah di bawah QuickCategories |

### Blok D: Dependencies

| # | Task | Keterangan | Prioritas |
|---|---|---|---|
| D.1 | Add `geolocator` ke pubspec | Untuk ambil lokasi user | **High** |
| D.2 | Add `google_maps_flutter` ke pubspec | Untuk map view (Location tab) | **Medium** |
| D.3 | Route `/facilities/:id` | Clinic detail page | **High** |
| D.4 | Route `/facilities` | Facility list page | **Medium** |

---

## Sequencing

```
A.1-A.3 (Models + Migration) → B.1-B.4 (Repo + Use Case) → C.1-C.3 (Cubit + Widget + Integrate)
```

D.1-D.4 (Dependencies) bisa dikerjakan paralel.
