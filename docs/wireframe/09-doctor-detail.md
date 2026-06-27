# Doctor Details Page Wireframe

| Field | Detail |
|---|---|
| **Route** | `/doctor/:doctorId` (push) |
| **Component** | `DoctorDetailPage` |
| **Status** | 🔧 Proposed |

---

## Page Wireframe (ASCII)

```text
┌──────────────────────────────────────────────┐
│ ←            Doctor Details             ♡    │
├──────────────────────────────────────────────┤
│ ┌────────┐  Dr. David Patel                 │
│ │        │───────────────────────────────── │
│ │ Photo  │  Cardiologist                    │
│ │ 2 : 3  │                                  │
│ │        │  📍 Golden Cardiology Center     │
│ └────────┘                                  │
├──────────────────────────────────────────────┤
│   👥            🎖            ⭐           💬 │
│ 2,000+         10+           5          1,872│
│ Patients   Experience     Rating      Reviews│
├──────────────────────────────────────────────┤
│ About Me                                     │
│ -------------------------------------------- │
│ Dr. David Patel, a dedicated cardiologist... │
│ View More                                    │
├──────────────────────────────────────────────┤
│ Working Time                                 │
│ -------------------------------------------- │
│ Monday–Friday, 08:00 AM – 06:00 PM           │
├──────────────────────────────────────────────┤
│ Reviews                              See All │
│ -------------------------------------------- │
│ ○ Emily Anderson                            │
│ ⭐ 5.0 ★★★★★                                │
│ Dr. Patel is a true professional...         │
│                                              │
│ ○ Another Review                            │
│ ⭐ 5.0 ★★★★★                                │
│ Lorem ipsum dolor sit amet...               │
├──────────────────────────────────────────────┤
│                                              │
│      [   Book Appointment Button   ]         │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Layout Structure

```text
Scaffold
└── SafeArea
    ├── AppBar
    │   ├── Back Button
    │   ├── Title
    │   └── Favorite Button
    │
    └── Column
        ├── Expanded
        │   └── SingleChildScrollView
        │       ├── DoctorInfoCard
        │       ├── SizedBox(24)
        │       ├── DoctorStatsRow
        │       ├── SizedBox(24)
        │       ├── AboutSection
        │       ├── SizedBox(24)
        │       ├── WorkingTimeSection
        │       ├── SizedBox(24)
        │       ├── ReviewsHeader
        │       ├── ReviewList
        │       └── Bottom Padding
        │
        └── SafeArea
            └── BookAppointmentButton
```

---

## Component Hierarchy

```text
DoctorDetailsPage
├── AppBar
│   ├── BackButton
│   ├── Title
│   └── FavoriteButton
│
├── DoctorInfoCard
│   ├── DoctorImage
│   ├── DoctorName
│   ├── Divider
│   ├── Specialization
│   └── HospitalRow
│
├── DoctorStatsRow
│   ├── StatItem (Patients)
│   ├── StatItem (Experience)
│   ├── StatItem (Rating)
│   └── StatItem (Reviews)
│
├── AboutSection
│   ├── SectionTitle
│   ├── Description
│   └── ViewMoreButton
│
├── WorkingTimeSection
│   ├── SectionTitle
│   └── ScheduleText
│
├── ReviewsSection
│   ├── Header
│   │   ├── Title
│   │   └── SeeAllButton
│   └── ReviewList
│       └── ReviewCard × N
│
└── BottomActionBar
    └── PrimaryButton
```

---

## Review Card

```text
ReviewCard
├── Row
│   ├── ReviewerAvatar
│   └── Expanded
│       ├── ReviewerName
│       ├── RatingRow
│       └── ReviewText
└── Divider
```

---

## Doctor Stats Item

```text
StatItem
├── CircleAvatar
│   └── Icon
├── Value
└── Label
```

---

## Components

| Component        | Description                                  |
| ---------------- | -------------------------------------------- |
| App Bar          | Back button, page title, favorite button     |
| Doctor Info Card | Doctor photo, name, specialization, hospital |
| Stats Row        | Patients, experience, rating, reviews        |
| About Section    | Doctor biography with expandable text        |
| Working Time     | Doctor availability schedule                 |
| Reviews Header   | Section title with "See All" action          |
| Review Card      | Reviewer avatar, name, rating, review text   |
| Bottom CTA       | Full-width "Book Appointment" button         |

---

## Suggested Flutter Widget Tree

```text
Scaffold
├── AppBar
├── SafeArea
│   └── Column
│       ├── Expanded
│       │   └── SingleChildScrollView
│       │       └── Padding(16)
│       │           └── Column
│       │               ├── DoctorInfoCard
│       │               ├── DoctorStatsRow
│       │               ├── AboutSection
│       │               ├── WorkingTimeSection
│       │               ├── ReviewsHeader
│       │               └── ListView.separated(
│       │                      shrinkWrap: true,
│       │                      physics: NeverScrollableScrollPhysics(),
│       │                  )
│       └── SafeArea
│           └── Padding(16)
│               └── FilledButton(
│                      child: Text("Book Appointment"),
│                  )
```

---

## Changelog

| Versi | Tanggal | Perubahan |
|-------|---------|-----------|
| v1.0 | Juni 2026 | Initial draft — layout with Info Card (Education, Experience, Clinic, Fee), Availability slots preview, Reviews placeholder |
| v1.0.1 | 13 Jun 2026 | **SS#10:** Hapus date picker; slot hanya preview 5 sample; navigasi booking tanpa selectedDate |
| v2.0 | 28 Juni 2026 | **Redesign:** Ganti layout header doctor (2:3 photo, divider, hospital row); tambah Stats Row (Patients, Experience, Rating, Reviews); tambah About Me section (expandable); tambah Working Time section; pindah Reviews ke section header + deferred list; hapus Education/Fee/Slot preview dari scroll; ubah AppBar title ke "Doctor Details"; hapus Share button |

> **Versi:** v2.0 — 28 Juni 2026
> **Perubahan dari versi sebelumnya:** Layout dirombak total — Info Card (Pendidikan, Pengalaman, Klinik, Biaya, Preview Slot) diganti dengan struktur baru: DoctorInfoCard (foto 2:3, nama, divider, spesialisasi, lokasi klinik), DoctorStatsRow (4 stat dengan icon), AboutSection (expandable), WorkingTimeSection, dan ReviewsSection header. Hapus elemen Education, Fee, dan Slot preview dari scroll. AppBar title berubah menjadi "Doctor Details". Share button dihapus.
> **Catatan:** Section Reviews di wireframe ini DIDOKUMENTASIKAN untuk referensi visual lengkap, tapi implementasinya DI-DEFER ke sprint mendatang (lihat ADR terkait).
