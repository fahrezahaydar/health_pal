# ADR 005: Clinic Card Redesign v2.0

| Field | Detail |
|---|---|
| **Status** | ✅ Accepted |
| **Tanggal** | 24 Juni 2026 |
| **Penulis** | Tech Lead |
| **Pemutus** | CTO + Tech Lead |
| **Dampak** | ERD (`clinics` table), RPC `get_nearby_clinics`, API Contract, Data Layer (Model/Entity), UI (ClinicCard widget) |

---

## 1. Konteks

Wireframe Clinic Card v1.0 (`07-location-search.md`) hanya menampilkan informasi minimal: nama klinik, alamat, jarak, dan jumlah dokter. Setelah review desain, dibutuhkan informasi yang lebih kaya untuk membantu user memilih fasilitas kesehatan:

| Komponen | v1.0 | v2.0 |
|----------|------|------|
| Cover Image | Thumbnail kecil (72x72) | Full-width cover image |
| Favorite | ❌ Tidak ada | ✅ Ikon hati (toggle) |
| Rating | ❌ Tidak ada | ✅ Nilai + bintang + jumlah review |
| Category | ❌ Tidak ada | ✅ Badge (Hospital, Clinic, dll) |
| Distance | ✅ Jarak (km) | ✅ Jarak + estimasi waktu tempuh |
| Doctor Count | ✅ Ada | ❌ Dihapus (pindah ke detail) |
| "Lihat Peta" | ✅ Button | ❌ Dihapus (tap card → detail) |

---

## 2. Opsi yang Dipertimbangkan

### Opsi A: Expand existing card dengan layout baru (DIPILIH)

Update `ClinicCard` widget + tambah kolom di DB + update RPC.

- **Pro:** Satu widget untuk semua (Loc tab + Home Nearby).
- **Pro:** Data lengkap membantu user decision.
- **Kontra:** Butuh migration DB + update RPC + refactor model/entity.

### Opsi B: Split → ClinicCard (list) + ClinicDetailCard (expanded)

- **Pro:** Separation of concern.
- **Kontra:** Duplikasi layout, maintenance overhead, tidak ada beda signifikan.

### Opsi C: Floating card di atas Map View

- **Pro:** Lebih modern, mirip Google Maps.
- **Kontra:** Map View belum diimplementasi (deferred Sprint 5). Tidak konsisten dengan card style lain.

---

## 3. Keputusan

**Pilih Opsi A: Expand existing `ClinicCard` ke v2.0 dengan cover image, rating, favorite, category, duration.**

### Detail Keputusan

1. **Database**: Tambah kolom `rating_avg` (`NUMERIC(2,1)`, default 0), `review_count` (`INT`, default 0), `category` (`TEXT`, nullable) ke tabel `clinics`.
2. **Favorite**: Tidak buat tabel `clinic_favorites` dulu — favorite button bersifat local-state (belum persist ke server) di MVP. Jika diperlukan di sprint berikutnya, tambah migration.
3. **RPC `get_nearby_clinics`**: Update return type — tambah `rating_avg`, `review_count`, `category`, `duration_minutes`.
4. **Duration**: Estimasi waktu tempuh dihitung dari `distance_meters` dengan asumsi kecepatan rata-rata 30 km/jam (city driving). Formula: `duration_minutes = (distance_meters / 1000) / 30 * 60`.
5. **ClinicModel/Entity**: Tambah field `ratingAvg`, `reviewCount`, `category` — hapus `doctorCount` (pindah ke detail page).
6. **ClinicCard widget**: Redesign sesuai wireframe v2.0.
7. **Home Nearby**: Referensi wireframe yang sama (reuse `ClinicCard` widget).

---

## 4. Alasan

1. **User decision**: Rating + review + category membantu user membandingkan klinik tanpa harus tap satu-satu.
2. **Consistency**: Satu widget `ClinicCard` dipakai di Loc tab dan Home Nearby — zero duplikasi.
3. **Favorite local**: MVP tidak butuh persist server — cukup state di cubit. Jika nanti butuh sync, tambah tabel + migration.
4. **Duration estimate**: Cukup akurat untuk MVP (30 km/jam city average). Tidak perlu Google Maps Distance Matrix API (biaya).
5. **Hapus doctor_count + Lihat Peta**: Informasi dokter pindah ke halaman detail klinik (Sprint 5). "Lihat Peta" jadi bagian dari tap card → detail.

---

## 5. Konsekuensi

### Positif

- ✅ Card lebih informatif — rating, review, category, duration.
- ✅ Satu widget reusable untuk Loc + Home.
- ✅ Favorite button meningkatkan engagement.
- ✅ Cover image full-width memberi visual hierarchy lebih baik.

### Negatif

- ⚠️ **DB Migration**: Tambah 3 kolom ke `clinics` (`rating_avg`, `review_count`, `category`) — butuh migration baru.
- ⚠️ **RPC Update**: `get_nearby_clinics` harus di-update return type-nya.
- ⚠️ **Breaking change**: `ClinicEntity` kehilangan `doctorCount` — semua consumer harus diupdate.
- ⚠️ **Favorite tidak persist**: State hilang saat app restart (local only).

### Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| `rating_avg` dan `review_count` di `clinics` tidak ada datanya | Default 0. Admin input manual via dashboard untuk MVP. |
| Duration estimate tidak akurat | Tampilkan jarak saja jika duration tidak reliable. Formula: `duration_minutes = round(distance_meters / 500 * 60)` (asumsi 30 km/h). |
| Favorite hilang setelah restart | Simpan di SharedPreferences sementara (key: `favorite_clinic_ids`). Migrasi ke server di sprint berikutnya. |

---

## 6. Compliance

| Mekanisme | Detail |
|---|---|
| **Wireframe** | `docs/wireframe/07-location-search.md` v2.0 |
| **ADR ini** | Dokumen keputusan arsitektur |
| **Todo List** | `docs/progress/clinic_card_redesign_todo.md` |
| **Code Review** | WAJIB cek: (1) RPC return fields, (2) ClinicEntity fields, (3) ClinicCard layout match wireframe |

---

## 7. Referensi

- Wireframe: `docs/wireframe/07-location-search.md` — Clinic Card v2.0
- ERD: `docs/erd/erd_healh_pal.md` — `clinics` table
- API Contract: `docs/api_contract/api_contract_health_pal.md` §5.5
- Existing Migration: `supabase/migrations/005_get_nearby_clinics_function.sql`
- Existing Widget: `lib/widgets/card/clinic_card.dart`

---

*Dokumen ini adalah Architecture Decision Record (ADR). Ubah status menjadi `Superseded` jika ADR baru menggantikan keputusan ini.*
