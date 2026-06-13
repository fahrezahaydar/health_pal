# Onboarding Page

| Field | Detail |
|---|---|
| **Route** | `/onboarding` |
| **Component** | `OnboardingPage` |
| **Status** | ✅ Existing |

---

## ASCII Layout (per slide)

### Slide 1
```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│            ┌──────────┐             │
│            │  Image   │             │
│            │  Illus-  │             │
│            │  tration │             │
│            │    #1    │             │
│            └──────────┘             │
│                                     │
│        "Find the Right Doctor"      │
│    "Easily find and book doctors    │
│     near you with just a few taps"  │
│                                     │
│                                     │
│           [ Skip ]                  │
│                                     │
│  ┌─────────────────────────────┐    │
│  │          Next →             │    │
│  └─────────────────────────────┘    │
│                                     │
│         ● ○ ○   (Page 1/3)         │
│                                     │
└─────────────────────────────────────┘
```

### Slide 2
```
┌─────────────────────────────────────┐
│                                     │
│            ┌──────────┐             │
│            │  Image   │             │
│            │  Illus-  │             │
│            │  tration │             │
│            │    #2    │             │
│            └──────────┘             │
│                                     │
│       "Real-Time Appointments"      │
│    "See available slots instantly   │
│     and book without calling."      │
│                                     │
│           [ Skip ]                  │
│                                     │
│  ┌─────────────────────────────┐    │
│  │          Next →             │    │
│  └─────────────────────────────┘    │
│                                     │
│         ○ ● ○   (Page 2/3)         │
│                                     │
└─────────────────────────────────────┘
```

### Slide 3
```
┌─────────────────────────────────────┐
│                                     │
│            ┌──────────┐             │
│            │  Image   │             │
│            │  Illus-  │             │
│            │  tration │             │
│            │    #3    │             │
│            └──────────┘             │
│                                     │
│      "Never Miss an Appointment"    │
│    "Get reminders before your       │
│     visit so you're always on time" │
│                                     │
│           [ Skip ]                  │
│                                     │
│  ┌─────────────────────────────┐    │
│  │       Get Started →         │    │
│  └─────────────────────────────┘    │
│                                     │
│         ○ ○ ●   (Page 3/3)         │
│                                     │
└─────────────────────────────────────┘
```

---

## Component Breakdown

| Component | Widget | Keterangan |
|---|---|---|
| Image Illustration | `Image.asset` | `assets/onboarding-{1,2,3}.png` |
| Title Text | `Text` | `AppTextTheme.headlineLarge` |
| Description Text | `Text` | `AppTextTheme.bodySmall`, grey |
| Skip Button | `GestureDetector` → `Text` | Posisi kanan atas |
| Next / Get Started | `LightFilledButton` | Full-width, bawah |
| Page Indicator | `SmoothPageIndicator` | 3 dots, `primary` color |
| Page View | `PageView` | Swipe horizontal |

---

## State & Interaction Specs

| Elemen | Interaksi | Efek |
|---|---|---|
| **Swipe kiri** | User geser ke kiri | `PageController.nextPage()` → slide berikutnya |
| **Tap "Next"** | Tap button | `PageController.nextPage()` |
| **Tap "Skip"** | Tap text kanan atas | `onboardingNotifier.skip()` → `AppServices.completeOnboarding()` → redirect `/sign-in` |
| **Tap "Get Started"** | Tap button (slide 3) | Sama seperti Skip |
| **Page Indicator** | Tap dot | `PageController.animateToPage(index)` |

**Cubit/Notifier:** `OnboardingNotifier` (ChangeNotifier) — menyimpan `currentIndex`, punya `nextPage()`, `skip()`.

---

## Catatan Format

Wireframe ini sudah lengkap dengan format standar 21 wireframe health_pal:
- ✅ ASCII Layout (3 slide detail)
- ✅ Component Breakdown (7 komponen)
- ✅ State & Interaction Specs (5 interaksi)
- ✅ Cubit/Notifier reference

## Changelog

| Versi | Tanggal | Perubahan |
|---|---|---|
| v1.0 | Juni 2026 | Initial — 3 slide carousel dengan PageView |
| v1.0.1 | 13 Jun 2026 | **SS#8 Verified:** Format lengkap, no changes needed. Audit showstopper entry: "Wireframe 01-onboarding.md sudah detail 3 slide layout, tidak perlu dibuat ulang" |
