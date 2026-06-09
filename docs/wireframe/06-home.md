# Home Page

| Field         | Detail                       |
| ------------- | ---------------------------- |
| **Route**     | `/home` (Shell Tab 0)        |
| **Component** | `HomePage`                   |
| **Status**    | 🆕 Redesigned based on Figma |

---

# Purpose

Halaman utama untuk membantu pengguna:

1. Melihat jadwal treatment atau appointment terdekat.
2. Mencari dokter, klinik, rumah sakit, atau layanan kesehatan.
3. Menjelajahi kategori spesialisasi.
4. Menemukan fasilitas kesehatan terdekat.

---

# ASCII Layout

```text
┌─────────────────────────────────────┐
│ Halo, Andi!                   🔔   │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔍 Search doctor, treatment... │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌──── Promo Carousel ─────────────┐ │
│ │ Looking for Specialist Doctors │ │
│ │ Schedule appointment today     │ │
│ └────────────────────────────────┘ │
│             ● ○ ○                  │
│                                     │
│ Upcoming Treatment                  │
│ ┌────────────────────────────────┐ │
│ │ Dr. Budi Santoso               │ │
│ │ Dental Cleaning                │ │
│ │ 📅 15 Jun 2026 • 09:00         │ │
│ │ 🏥 Klinik Sehat Bersama        │ │
│ │ [View Detail]                  │ │
│ └────────────────────────────────┘ │
│                                     │
│ Categories                  See All │
│                                     │
│ 🦷      ❤️      🫁      🩺         │
│ Dentistry Cardio Pulmo General     │
│                                     │
│ 🧠      🫃      🧪      💉         │
│ Neuro   Gastro  Lab     Vaccine    │
│                                     │
│ Nearby Medical Centers     See All │
│                                     │
│ ┌────────────┐  ┌────────────┐      │
│ │ Image      │  │ Image      │      │
│ │ Clinic A   │  │ Hospital B │      │
│ └────────────┘  └────────────┘      │
│                                     │
│──────── Bottom Navigation ──────────│
│ Home | Explore | Booking | Profile │
└─────────────────────────────────────┘
```

---

# Empty State

## No Upcoming Treatment

```text
Upcoming Treatment

No upcoming treatment found.

[Book Appointment]
```

CTA akan mengarahkan user ke halaman pencarian dokter.

---

# Component Breakdown

| Zone       | Component           | Widget           | Data Source                |
| ---------- | ------------------- | ---------------- | -------------------------- |
| Header     | Greeting + Notif    | Text + Icon      | User Profile API           |
| Header     | Notification        | IconButton       | Notifications API          |
| Search     | Search Bar          | SearchInput      | Search Service             |
| Banner     | Promo Carousel      | PageView         | GET /banners               |
| Upcoming   | Treatment Card      | Card             | GET /appointments/upcoming |
| Categories | Specialization Grid | GridView         | GET /specializations       |
| Nearby     | Facility Cards      | Horizontal List  | GET /facilities/nearby     |
| Navigation | Bottom Navigation   | Shell Navigation | Local                      |

---

# Sections

## 1. Greeting Header

Menampilkan sapaan ke pengguna berdasarkan profil.

### Layout

```text
Halo, Andi!                       🔔
```

### Actions

| Action           | Result                 |
| ---------------- | ---------------------- |
| Tap Notification | Open notification page |

---

## 2. Search Bar

### Placeholder

```text
Search doctor, clinic, treatment...
```

### Search Scope

* Doctor
* Specialization
* Treatment
* Clinic
* Hospital
* Medical Center

### Action

Tap atau submit akan membuka:

```text
/search
```

---

## 3. Promo Carousel

Menampilkan promosi dan campaign kesehatan.

### Data Source

```http
GET /banners
```

### Behaviour

* Auto scroll 5 detik
* Swipeable
* Clickable

---

## 4. Upcoming Treatment

Menampilkan appointment terdekat pengguna.

### Data Source

```http
GET /appointments/upcoming
```

### Content

* Doctor Name
* Treatment Name
* Date & Time
* Facility Name
* Status

### Action

Tap card:

```text
/booking-history/:appointmentId
```

---

## 5. Categories

Grid kategori spesialisasi.

### Layout

2 rows × 4 columns

### Initial Categories

| Category         |
| ---------------- |
| Dentistry        |
| Cardiology       |
| Pulmonology      |
| General          |
| Neurology        |
| Gastroenterology |
| Laboratory       |
| Vaccination      |

### Action

Tap category:

```text
/search?specialization={id}
```

---

## 6. Nearby Medical Centers

Menampilkan fasilitas kesehatan terdekat berdasarkan lokasi user.

### Data Source

```http
GET /facilities/nearby
```

### Query

```json
{
  "latitude": "...",
  "longitude": "...",
  "radius": 10000
}
```

### Card Content

* Cover Image
* Facility Name
* Distance
* Rating

### Actions

Tap card:

```text
/facilities/:id
```

See All:

```text
/facilities
```

---

# State Management

| Section            | Cubit / Bloc        |
| ------------------ | ------------------- |
| Greeting           | HomeCubit           |
| Notification       | NotificationCubit   |
| Banner             | BannerCubit         |
| Upcoming Treatment | AppointmentCubit    |
| Categories         | SpecializationCubit |
| Nearby Facilities  | FacilityCubit       |

---

# Pull To Refresh

Refresh:

* Greeting (user profile)
* Banner
* Upcoming Treatment
* Categories
* Nearby Facilities

---

# Loading State

Order loading:

1. Greeting (user profile)
2. Banner
3. Upcoming Treatment
4. Categories
5. Nearby Facilities

Setiap section menggunakan skeleton loader secara independen.

---

# Navigation Flow

```text
Home
 ├─ Search
 ├─ Notification
 ├─ Banner Detail
 ├─ Appointment Detail
 ├─ Specialization Search
 ├─ Facility Detail
 └─ Facility List
```
