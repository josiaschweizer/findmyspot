# FindMySpot

> Native iOS app for finding public, freely accessible places that match your current needs (quiet, Wi-Fi, power outlets ...).
> Built as part of the Vertiefungsarbeit (VA) at GBS St. Gallen. Pilot area: **City of St. Gallen**.

[findmyspot.ch](https://www.findmyspot.ch/)

---

## Team

| Name | Company |
| --- | --- |
| Josia Schweizer | Abacus Research AG |
| Janik Janesch | innosolv AG |
| Ben Lämmlin | Frontify |

--- 

## Repository Structure


```text
findmyspot/
├── FindMySpot/            # iOS app (Xcode project, Swift)
│   ├── FindMySpot/
│   │   ├── App/           # App entry point
│   │   ├── Data/
│   │   ├── Lib/           # Design system & reusable components
│   │   ├── Model/
│   │   ├── Services/      # Supabase, auth, places
│   │   ├── ViewModel/
│   │   ├── Views/
│   │   └── Assets.xcassets
│   ├── FindMySpotTests/
│   └── FindMySpotUITests/
├── supabase/              # Backend: migrations, RLS policies, storage, seed data
├── landing-page/          # Project website (Vite + React + TypeScript)
├── protoyp/simple/        # Early HTML/Leaflet prototype incl. FIGMA_SPEC.md
├── documentation/         # AI usage screenshots for the VA
└── PROJECT_GUIDELINES.md  # Project and code guidelines
```

---

## Tech Stack

| Area | Technology |
| --- | --- |
| iOS app | Swift, SwiftUI, MapKit, CoreLocation |
| Backend | Supabase (Auth, PostgreSQL, Storage) |
| Landing page | Vite, React, TypeScript, pnpm |
| Prototyping | Figma, HTML, Leaflet, OpenStreetMap |

---

## Features

- Map with Places and your current location (only if you allow location access)
- Search by place name or attribute
- Needs-based filters (e.g. quiet, Wi-Fi, power outlets)
- Place detail view with images and attributes
- Favorites and bookmarks (intentionally separate)
- Add new places (multi-step flow)
- Sign in / sign up via Supabase Auth

---

## Getting Started

### Prerequisites
- macOS with a recent version of Xcode
- [Supabase CLI](https://supabase.com/docs/guides/cli) + Docker (for the local backend)
- Node.js + **pnpm** (only for the landing page)

### iOS App

```bash
open FindMySpot/FindMySpot.xcodeproj
```

Xcode resolves Swift Package dependencies automatically. Pick a simulator or iPhone and run with `CMD + R`

> **Note (physical iPhone)**: If you see "Developer App Certificate is not trusted", go to
> *Settings -> General -> VPN & Device Management* and trust the developer certificate.

### Supabase (local)

```bash
supabase start
supabase db reset
```

Details on the test data: [`supabase/SEED_README.md`](supabase/SEED_README.md)

---


## Conventions

- **Design system first:** colors, spacing, radius, typography and icons only through central constant classes (`AppSpacing`, `AppRadius`, `AppTypography`, `AppIcons`, color assets). No magic numbers or magic strings.
- **Small views:** split features into subcomponents (not huge components with several thousand lines)
- **Semantic names:** `AppPrimary` instead of `Green1`
- **Commits:** small and easy to follow

See [`PROJECT_GUIDELINES.md`](PROJECT_GUIDELINES.md) for more

---

## License

School project for the VA at GBS St. Gallen. Not intended for commercial use (at least for now...)
