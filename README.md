# TemplateApp

A minimal iOS app template built with SwiftPM (Swift Package Manager). This template provides a clean, `.swiftpm`-based project structure with fastlane automation, justfile commands, and CI/CD integration.

## Overview

This template uses a `.swiftpm` package structure instead of a traditional `.xcodeproj` file. All project configuration is managed through `Package.swift`, making it lightweight and easy to version control.

### Key Features

- **SwiftPM-native**: No Xcode project file, everything defined in `Package.swift`
- **Fastlane integration**: Automated build and test lanes
- **Modular justfile**: Developer-friendly command runner with organized recipes
- **GitHub Actions CI**: Automated linting and testing on PR/push
- **Minimal setup**: Simple two-module structure (App + View)

## Architecture

```
App.swiftpm/
├── Package.swift              # Project configuration
├── Sources/
│   ├── App/                   # App entry point and resources
│   │   ├── TemplateApp.swift  # @main app
│   │   └── Assets.xcassets/   # App icon and assets
│   └── View/                  # Core views and business logic
│       └── ContentView.swift  # Main view
└── Tests/
    └── AppTests/              # Unit tests
        └── AppModuleTests.swift
```

### Module Structure

- **App**: Executable target containing the app entry point (`@main`) and resources
- **View**: Library target containing views and business logic
- **AppTests**: Test target for unit tests

## Quick Start

### Prerequisites

- Xcode 16+ (Swift 6.0)
- Ruby 3.3+ (for fastlane)
- [Mint](https://github.com/yonaskolb/Mint) (for SwiftFormat/SwiftLint)
- [just](https://github.com/casey/just) (command runner)

### Setup

1. Clone the repository
2. Run the setup command:

```bash
just setup
```

This will:
- Install Ruby gems (fastlane)
- Create `.env` from `.env.example`
- Bootstrap Mint packages (SwiftFormat, SwiftLint)

3. Configure your environment:

Edit `.env` and set your simulator UDIDs:

```bash
# Find available simulators
just siml

# Copy UDID and update .env
DEV_SIMULATOR_UDID=YOUR-UDID-HERE
TEST_SIMULATOR_UDID=YOUR-UDID-HERE
```

4. Open the project:

```bash
just open
```

## Development Commands

| Command | Description |
|---------|-------------|
| `just setup` | Install dependencies and bootstrap tools |
| `just open` | Open project in Xcode |
| `just boot` | Boot development simulator |
| `just check` | Run SwiftFormat and SwiftLint |
| `just fix` | Auto-fix formatting issues |
| `just build-debug` | Build debug archive |
| `just run-debug` | Build and run on simulator |
| `just test` | Run all tests |
| `just siml` | List available simulators |

For a complete list of commands:

```bash
just --list
```

## Testing

Run tests using:

```bash
just test
```

This will:
1. Build the app for testing
2. Execute all test targets
3. Generate a test result bundle

Tests are automatically run in CI on every PR and push to `main`.

## Customization

### 1. Rename Project

Update these files with your new project name:

**Package.swift**:
- `name: "TemplateApp"` → `name: "YourApp"`
- `bundleIdentifier: "com.akitorahayashi.TemplateApp"` → your bundle ID
- Product name and target names

**justfile**:
- `APP_BUNDLE_ID := "com.akitorahayashi.TemplateApp"`

**fastlane/config.rb**:
- `SCHEMES[:app]` value

### 2. Update Team ID

Set your Apple Developer Team ID in `.env`:

```dotenv
TEAM_ID=YOUR_TEAM_ID
```

### 3. Add Dependencies

Add Swift Package dependencies in `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/example/Package.git", from: "1.0.0")
],
targets: [
  .target(
    name: "View",
    dependencies: [
      .product(name: "PackageName", package: "Package")
    ]
  )
]
```

## CI/CD

The project includes GitHub Actions workflows:

- **Linters**: Runs SwiftFormat and SwiftLint on every PR
- **Tests**: Runs all tests on every PR and push to main

### Workflow Files

- `.github/workflows/ci-cd-pipeline.yml`: Main pipeline orchestrator
- `.github/workflows/run-linters.yml`: Linting job
- `.github/workflows/run-tests.yml`: Testing job
- `.github/actions/setup/action.yml`: Common setup action

## Project Structure

```
.
├── App.swiftpm/               # Swift Package
│   ├── Package.swift          # Package manifest
│   ├── Sources/               # Source code
│   └── Tests/                 # Test code
├── fastlane/                  # Fastlane automation
│   ├── Fastfile               # Lane definitions
│   ├── config.rb              # Configuration
│   ├── lanes/                 # Lane implementations
│   └── just/                  # Justfile modules
├── .github/                   # GitHub Actions
│   ├── actions/setup/         # Reusable setup action
│   └── workflows/             # CI/CD workflows
├── justfile                   # Command runner
├── Gemfile                    # Ruby dependencies
├── Mintfile                   # Swift tool dependencies
├── .env.example               # Environment variables template
├── .swiftformat               # SwiftFormat configuration
├── .swiftlint.yml             # SwiftLint configuration
└── README.md                  # This file
```

## Development Guidelines

### Code Style

- Use `just fix` to auto-format code before committing
- Run `just check` to verify formatting and linting
- CI will fail if code style checks don't pass

### Testing

- Write tests in `Tests/AppTests/`
- Tests run automatically in CI
- Use `just test` to run tests locally

### Building

- Use `just build-debug` for debug builds
- Use `just run-debug` to build and launch on simulator
- SwiftPM handles incremental builds efficiently

## Troubleshooting

### Reset Swift Package Cache

If you encounter build issues:

```bash
just resolve-pkg
```

### Simulator Issues

List available simulators:

```bash
just siml
```

Boot a specific simulator:

```bash
just boot
```

### Fastlane Issues

Reinstall Ruby gems:

```bash
bundle install
```

## License

This is a template project. Use it as a starting point for your own apps.

## Resources

- [Swift Package Manager](https://swift.org/package-manager/)
- [fastlane](https://fastlane.tools/)
- [just](https://github.com/casey/just)
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
- [SwiftLint](https://github.com/realm/SwiftLint)
