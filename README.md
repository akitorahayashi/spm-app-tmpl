# TemplateApp

A minimal iOS app template built with SwiftPM (Swift Package Manager). This template provides a clean, `.swiftpm`-based project structure with fastlane automation, justfile commands, and CI/CD integration.

## Overview

This template uses a `.swiftpm` package structure instead of a traditional `.xcodeproj` file. All project configuration is managed through `Package.swift`, making it lightweight and easy to version control.

### Key Features

- **SwiftPM-native**: No Xcode project file, everything defined in `Package.swift`
- **Fastlane integration**: Automated build and test lanes
- **Modular justfile**: Developer-friendly command runner with organized recipes
- **GitHub Actions CI**: Automated linting and testing on PR/push
- **Snapshot testing**: UI snapshot tests for visual regression
- **Minimal setup**: Simple two-module structure (App + View)

## Quick Start

### Prerequisites

- Xcode 16+ (Swift 6.0)
- Ruby 3.3+ (for fastlane)
- [Mint](https://github.com/yonaskolb/Mint) (for SwiftFormat/SwiftLint)
- [just](https://github.com/casey/just) (command runner)

### Setup

1. Clone the repository
2. Run `just setup`
3. Edit `.env` with simulator UDIDs (`just siml` to list)
4. Run `just open`

## Development Commands

| Command | Description |
|---------|-------------|
| `just setup` | Install dependencies and bootstrap tools |
| `just open` | Open project in Xcode |
| `just check` | Run SwiftFormat and SwiftLint |
| `just fix` | Auto-fix formatting issues |
| `just test` | Run all tests |
| `just snapshot` | Run snapshot tests |
| `just run-debug` | Build and run on simulator |
| `just siml` | List available simulators |

## Testing

Run `just test` to execute all tests (unit and build tests), or `just snapshot` for snapshot tests only. Tests run automatically in CI on PR/push.

## Customization

### Rename Project

Update `Package.swift` name/bundle, `justfile` APP_BUNDLE_ID, `fastlane/config.rb` SCHEMES.

### Add Dependencies

Edit `Package.swift` dependencies.

## CI/CD

GitHub Actions workflows for linting and testing.

## Development Guidelines

1. Setup: `just setup`, edit .env
2. Develop: `just open`, make changes, `just fix`
3. Test: `just test`
4. Commit: `just check`
