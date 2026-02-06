# Project Overview

iOS app template using SwiftPM (.swiftpm package, no .xcodeproj). Config in Package.swift.

# Directory Structure

```
App.swiftpm/
├── Package.swift          # All config
├── Sources/App/           # @main app
├── Sources/View/          # SwiftUI views
└── Tests/Snapshots/       # UI snapshot tests
fastlane/                  # Build/test automation
.github/workflows/         # CI pipelines
justfile                   # Commands
.env.example               # Environment vars
```

# Architecture

- **Targets**: App (executable), View (library), TemplateAppSnapshotTests (tests)
- **Build**: xcodebuild with scheme TemplateApp
- **Tests**: Unit and snapshot tests via `just test`/`just unit-test`/`just snapshot`
- **Lint**: SwiftFormat/SwiftLint via `just check`/`just fix`

# Environment Variables

- DEV_SIMULATOR_UDID: For `just run-debug`
- TEST_SIMULATOR_UDID: For `just snapshot`

# Development Commands

- `just setup`: Init project
- `just open`: Open in Xcode
- `just check`: Lint/format check
- `just fix`: Auto-fix formatting
- `just test`: Run all tests
- `just unit-test`: Run unit tests
- `just snapshot`: Run snapshot tests
- `just run-debug`: Build and run app
- `just siml`: List simulators

# CI

GitHub Actions: lint and test on PR/push.

# Guidelines

1. Setup: `just setup`, edit .env
2. Develop: `just open`, make changes, `just fix`
3. Test: `just test`
4. Commit: `just check`

## Adding Dependencies

Edit Package.swift dependencies.

## Project Customization

Rename: Update Package.swift name/bundle, justfile APP_BUNDLE_ID, fastlane/config.rb SCHEMES.

## Snapshot Testing

Write tests in Tests/Snapshots/, run with `just snapshot`.

# Common Tasks

- Run app: `just run-debug`
- Run tests: `just test`
- Run snapshot tests: `just snapshot`
- Format: `just fix`
- Clean: `just resolve-pkg`

# Documentation Rules

Declarative style: describe current state, not changes.
