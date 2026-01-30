# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter-based intercity ride-sharing passenger mobile application for iOS and Android.

- **App Name**: Ride Sharing Passenger
- **Package**: `com.ridesharing.passenger`
- **Dart SDK**: ^3.10.7
- **Style**: Minimalism (Uber/Bolt style)
- **Primary Color**: Teal (#009688)
- **Font**: Inter

## Documentation (READ FIRST!)

**Before starting any work, read these files:**

| File | Description |
|------|-------------|
| `docs/UI_UX_PLAN.md` | Detailed wireframes for all screens |
| `docs/DESIGN_SYSTEM.md` | Colors, typography, components, Flutter theme code |
| `docs/PROJECT_ROADMAP.md` | Development phases and current status |
| `docs/CLAUDE_PROMPT.md` | Prompts for continuing work in new chats |
| `../driver/api-1.json` | Backend API OpenAPI specification |

## Tech Stack (Planned)

```yaml
State Management: Riverpod
Navigation: go_router
Network: Dio + Retrofit
Architecture: Clean Architecture
```

## Common Commands

```bash
flutter run                    # Run debug
flutter build apk              # Build Android
flutter build ios              # Build iOS
flutter analyze                # Lint
flutter test                   # Run tests
flutter pub get                # Get dependencies
```

## Project Structure (Target)

```
lib/
├── core/           # Theme, network, storage, utils, widgets
├── features/       # Feature modules (auth, trips, etc.)
│   └── feature/
│       ├── data/           # Models, repositories impl
│       ├── domain/         # Entities, use cases
│       └── presentation/   # Screens, widgets, providers
└── l10n/           # Localization
```

## Current Development Phase

Check `docs/PROJECT_ROADMAP.md` for current status.

## API Base URL

```
https://mydemoapp.cc/api/v1/
```

## Target Market: USA

| Parameter | Value |
|-----------|-------|
| UI Language | English |
| Currency | USD ($) |
| Phone Format | +1 (XXX) XXX-XXXX |
| Distance | Miles |
| Date Format | MM/DD/YYYY |
| Time Format | 12-hour (AM/PM) |
| Cities | NYC, Boston, LA, San Diego, Chicago, Miami |

## Related Projects

- `../driver/` - Driver mobile app
- `../../backend/` - Backend services
