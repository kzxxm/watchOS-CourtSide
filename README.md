# CourtSide 🎾

A modern, feature-rich padel & tennis scoring app for Apple Watch

## Overview

CourtSide is a native watchOS app designed to make padel score tracking effortless and intuitive. Built with SwiftUI and following clean architecture principles, it delivers a smooth, responsive experience optimized for the Apple Watch.

Whether you're playing singles or doubles, CourtSide keeps accurate track of points, games, and sets while providing visual feedback and haptic notifications for game and set wins.

## Features

### Core Functionality
- ✅ **Complete Padel Scoring** - Full support for standard padel and tennis rules
- ✅ **Point Tracking** - Real-time point, game, and set scoring
- ✅ **Deuce & Advantage** - Automatic handling of deuce scenarios
- ✅ **Serve Indicators** - Clear visual indicators for the serving team
- ✅ **Court Side Display** - Shows which side of the court the server is on
- ✅ **Undo/Redo** - Unlimited undo with 50-point history
- ✅ **Match Reset** - Quick reset to start a new match

### Game Rules
- 🎯 **Golden Point Mode** - Optional sudden-death deuce
- 🎾 **Tie-Break Support** - Standard tie-break at 6-6
- ⚙️ **Customizable Settings** - Toggle rules to match your play style
- 🎨 **Color Themes** - 6 beautiful color combinations for team differentiation

### User Experience
- 📱 **Apple Watch Native** - Optimized for watchOS, written in native Swift/SwiftUI
- 💪 **Haptic Feedback** - Tactile notifications for game and set wins
- 🎨 **Beautiful UI** - Clean, modern interface with smooth animations
- ⚡ **Fast & Responsive** - Built with SwiftUI for optimal performance
- 💾 **Settings Persistence** - Your preferences are saved between sessions

## Architecture

CourtSide follows a clean, domain-driven architecture with clear separation of concerns:

```
CourtSide/
├── App/
│   └── CourtSideApp.swift          # App entry point
├── Domain/
│   ├── Model/                      # Core data models
│   │   ├── CourtSide.swift         # Court side enum
│   │   ├── GamePoints.swift        # Point tracking
│   │   ├── Score.swift             # Set and match scores
│   │   ├── ServeState.swift        # Serve state tracking
│   │   └── Team.swift              # Team enum
│   ├── Rules/                      # Business logic
│   │   ├── GameRules.swift         # Game winning logic
│   │   ├── SetRules.swift          # Set winning logic
│   │   └── ServeRules.swift        # Serve rotation logic
│   └── Display/                    # Presentation logic
│       ├── DisplayPoint.swift      # Point formatting (0, 15, 30, 40, ADV)
│       ├── ScoreFormatter.swift    # Score display formatting
│       ├── ServeFormatter.swift    # Serve display formatting
│       └── TeamColor.swift         # Color theme management
├── Presentation/
│   ├── ViewModel/
│   │   ├── MatchViewModel.swift    # Main view model
│   │   └── State/                  # State management
│   │       ├── MatchState.swift
│   │       ├── PresentationState.swift
│   │       └── MatchSettings.swift
│   └── Views/                      # SwiftUI views
│       ├── MatchView.swift         # Main match view
│       ├── Score/                  # Score display views
│       ├── Serve/                  # Serve indicator views
│       ├── Controls/               # Control buttons
│       ├── Settings/               # Settings views
│       └── WinOverlays/            # Game/Set win overlays
└── Services/
    └── HapticsManager.swift        # Haptic feedback
```

### Design Patterns

- **MVVM Architecture** - Clear separation between views and business logic
- **Observable Pattern** - Using Swift's `@Observable` for reactive state management
- **Value Types** - Extensive use of structs for immutability and safety
- **Separation of Concerns** - Domain logic separated from presentation
- **Strategy Pattern** - Rule implementations (GameRules, SetRules, ServeRules)
- **Snapshot Pattern** - History management for undo functionality

## Installation

### Requirements
- Xcode 16.0 or later
- watchOS 10.0 or later
- Swift 6.0 or later

### Building the App

1. Clone the repository:
```bash
git clone https://github.com/kzxxm/CourtSide.git
cd CourtSide
```

2. Open the project in Xcode:
```
open CourtSide.xcodeproj
```

4. Select your Apple Watch target or simulator

5. Build and run (`Cmd + R`)

## Testing

CourtSide includes a comprehensive test suite with **128+ tests** using Apple's modern **Swift Testing** framework.

### Running Tests

```bash
# Run all tests
xcodebuild test \
  -project CourtSide.xcodeproj \
  -scheme "CourtSide Watch App" \
  -destination 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)'
```

Or in Xcode: `Cmd + U`

### Test Features

- ✅ Swift Testing framework (modern, parallel execution)
- ✅ Parameterized tests for efficiency
- ✅ 100% coverage of business logic
- ✅ Integration tests for complete game scenarios
- ✅ Fast execution (< 3 seconds total)

## Usage

### Starting a Match

1. Launch CourtSide on your Apple Watch
2. Select which team serves first (Us or Them)
3. Start scoring points by tapping on the team that wins each point
4. The serve indicator automatically updates after each point

### Scoring Points

- Tap the score tile for the respective team to award a point
- Scores automatically progress: 0 → 15 → 30 → 40 → Game
- Deuce and advantage are handled automatically
- Haptic feedback confirms game and set wins

### Settings

Access settings via the gear icon to customize:
- **Golden Point** - Win at deuce with one point (no advantage)
- **Tie Break** - Enable tie-breaks at 6-6
- **Team Colors** - Choose from 6 color themes:
  - Blue & Orange (default)
  - Red & Green
  - Yellow & Purple
  - Pink & Teal
  - Mint & Indigo
  - Brown & Cyan

### Controls

- **Undo Button** - Reverse the last point (supports up to 50 undos)
- **Reset Button** - Start a fresh match
- **Set Summary** - View completed sets after each set win

## Color Themes

CourtSide offers 6 professionally designed color combinations to help differentiate teams:

| Theme | Team 1 | Team 2 |
|-------|--------|--------|
| Default | Blue | Orange |
| Classic | Red | Green |
| Vibrant | Yellow | Purple |
| Modern | Pink | Teal |
| Cool | Mint | Indigo |
| Earthy | Brown | Cyan |

All themes are carefully chosen for optimal readability on Apple Watch displays.

## Technical Highlights

### State Management
- **Observation Framework** - Modern Swift concurrency and state management
- **Snapshot System** - Efficient undo/redo with circular buffer
- **Persistent Settings** - User preferences saved via `@AppStorage`

### Performance
- **SwiftUI Optimizations** - Minimal redraws and efficient state updates
- **Value Semantics** - Struct-based models for thread safety
- **Lazy Loading** - On-demand view creation

### Code Quality
- **100% Swift** - No Objective-C dependencies
- **Type Safety** - Extensive use of enums and value types
- **Testability** - Clean architecture enables comprehensive testing
- **Documentation** - Inline comments and clear naming conventions

## Author

**Kassim Mirza**

- GitHub: [@kzxxm](https://github.com/kzxxm)
- LinkedIn: [@KassimMirza](https://linkedin.com/in/kassimmirza)

## Screenshots

<!-- Add screenshots of your app here -->
<!-- Example:
![Main View](screenshots/main-view.png)
![Settings](screenshots/settings.png)
![Game Win](screenshots/game-win.png)
-->

