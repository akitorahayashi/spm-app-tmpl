# Project Overview

This project is an iOS application template built with SwiftPM (Swift Package Manager). The project uses a `.swiftpm` package structure instead of a traditional `.xcodeproj` file, making it lightweight and easy to version control. All configuration is managed through `Package.swift`.

# Directory Structure

```
.
├── TemplateApp.swiftpm/              # Swift Package (no .xcodeproj)
│   ├── Package.swift                 # Package manifest - all project configuration
│   ├── Sources/
│   │   ├── App/                      # Executable target (app entry point)
│   │   │   ├── TemplateApp.swift     # @main app struct
│   │   │   └── Assets.xcassets/      # App icon and assets
│   │   └── View/                     # Library target (business logic)
│   │       └── ContentView.swift     # SwiftUI views
│   └── Tests/
│       └── AppTests/                 # Test target
│           └── AppModuleTests.swift  # Unit tests
├── fastlane/                         # Automation scripts for building and testing
│   ├── Fastfile                      # Lane definitions orchestrator
│   ├── config.rb                     # Configuration constants
│   ├── Appfile                       # Apple Developer account settings
│   ├── lanes/
│   │   ├── build.rb                  # Build lanes implementation
│   │   └── test.rb                   # Test lanes implementation
│   └── just/                         # Justfile modules for fastlane
│       ├── main.just                 # Module entry point
│       ├── module.just               # Common helpers
│       ├── build.just                # Build recipes
│       └── test.just                 # Test recipes
├── .github/
│   ├── actions/
│   │   └── setup/
│   │       └── action.yml            # Reusable setup action for CI
│   └── workflows/
│       ├── ci-cd-pipeline.yml        # Main pipeline orchestrator
│       ├── run-linters.yml           # Linting workflow
│       └── run-tests.yml             # Testing workflow
├── justfile                          # Command runner configuration
├── Gemfile                           # Ruby dependencies (fastlane)
├── .ruby-version                     # Ruby version (3.3.0)
├── Mintfile                          # Swift CLI tool dependencies (SwiftFormat, SwiftLint)
├── .env.example                      # Environment variables template
├── .swiftformat                      # SwiftFormat configuration
├── .swiftlint.yml                    # SwiftLint configuration
├── README.md                         # User-facing documentation
└── AGENTS.md                         # This file - LLM context
```

# Architecture & Implementation Details

## SwiftPM Package Structure

- **No .xcodeproj file**: This project uses `.swiftpm` which is a Swift Package. Xcode can open it directly.
- **Package.swift**: Declares all targets, dependencies, and build settings
- **Target Types**:
  - `App`: Executable target (`.iOSApplication` product) with `@main` entry point
  - `View`: Library target (`.target`) containing business logic
  - `AppTests`: Test target (`.testTarget`) for unit tests

## Build System

- **xcodebuild**: Fastlane uses `xcodebuild -scheme TemplateApp` (no `-project` or `-workspace` flag needed)
- **Scheme**: Auto-generated from Package.swift, named after the app product
- **Build Configurations**: Debug and Release (standard iOS configurations)
- **Derived Data**: Stored in `fastlane/build/` directory structure

## Fastlane Integration

Fastlane operates via `xcodebuild` commands targeting the TemplateApp scheme:

- **Build**: `build_app` action with scheme and configuration
- **Test**: `scan` action with scheme, destination (simulator), and result bundle path
- **No Code Signing**: Template uses `skip_codesigning: true` for unsigned builds

### Lane Structure

- `lanes/build.rb`: `build_debug`, `build_release`, `build_for_testing`
- `lanes/test.rb`: `test`, `test_without_building`
- `config.rb`: Shared constants (schemes, paths, configurations)

## Justfile Architecture

The justfile follows a modular structure inherited from `reference/tca-tmpl`:

### Root justfile (`justfile`)

- **PROJECT SETTINGS**: Bundle ID and app-specific constants
- **ENV VARIABLES**: `set dotenv-load`, loads `.env` file
- **MODULES**: `mod fastlane "fastlane/just/main.just"` imports fastlane recipes
- **SETUP**: `setup`, `open`, `resolve-pkg` - project initialization
- **SIMULATOR**: `boot`, `boot-test`, `siml` - simulator management
- **LINT & FORMAT**: `fix`, `check` - SwiftFormat and SwiftLint
- **DELEGATIONS**: Delegates build/test commands to `fastlane::` module

### Fastlane Module (`fastlane/just/`)

- **main.just**: Module entry point, defines variables, imports sub-modules
- **module.just**: `_run_fastlane` helper with CI/UDID logic
- **build.just**: `build-debug`, `build-release`, `run-debug`, `run-release`
- **test.just**: `test`, `test-without-building`

Key pattern: `[no-cd]` attribute on module recipes to maintain working directory.

## Testing Strategy

### Unit Tests

- Located in `Tests/AppTests/`
- Test the `View` module logic
- Executed via `just test` → `fastlane test` → `xcodebuild test`

### CI Testing

- GitHub Actions runs tests on every PR and push to main
- Uses `run-tests.yml` workflow
- Uploads `.xcresult` bundle as artifact

## Linting & Formatting

- **SwiftFormat**: Auto-formats Swift code (`.swiftformat` config)
- **SwiftLint**: Lints code for style violations (`.swiftlint.yml` config)
- **Commands**:
  - `just fix`: Auto-format code
  - `just check`: Verify formatting and linting (CI-safe, no modifications)

## Environment Variables

Managed via `.env` file (created from `.env.example`):

- `DEV_SIMULATOR_UDID`: Simulator for `just run-debug`
- `TEST_SIMULATOR_UDID`: Simulator for `just test`
- `TEAM_ID`: Apple Developer Team ID
- `APPLE_ID`: Apple ID email

## GitHub Actions CI

### Setup Action (`.github/actions/setup/action.yml`)

Reusable composite action:
- Caches Mint packages
- Caches SwiftPM dependencies
- Installs Mint and just
- Runs `mint bootstrap`
- Optionally installs Ruby gems (`setup_ruby: true`)

### Workflows

- **ci-cd-pipeline.yml**: Orchestrator, triggers on PR/push to main
- **run-linters.yml**: Runs `just check` on macOS-15
- **run-tests.yml**: Runs `just test` on macOS-15, uploads `.xcresult`

## Development Commands

### Essential Commands

- `just setup`: Install dependencies, create `.env`, bootstrap tools
- `just open`: Open `TemplateApp.swiftpm` in Xcode
- `just check`: Run SwiftFormat and SwiftLint (CI-safe)
- `just test`: Run all tests via fastlane
- `just build-debug`: Build debug archive
- `just run-debug`: Build and launch on simulator

### Simulator Management

- `just boot`: Boot `DEV_SIMULATOR_UDID` simulator
- `just boot-test`: Boot `TEST_SIMULATOR_UDID` simulator
- `just siml`: List available simulators

### Advanced Commands

- `just resolve-pkg`: Clear SwiftPM cache and rebuild
- `just build-release`: Build release archive
- `just run-release`: Build and launch release on simulator

## Development Guidelines

### Workflow

1. Run `just setup` once after cloning
2. Edit `.env` with your simulator UDIDs
3. Use `just open` to launch Xcode
4. Make changes, then `just fix` to format
5. Run `just check` before committing
6. Run `just test` to verify tests pass

### Adding Dependencies

Edit `Package.swift` to add Swift Package dependencies:

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

No need to run XcodeGen or project generation - SwiftPM handles everything.

### Project Customization

To rename the project:

1. Update `Package.swift`: Change `name`, `bundleIdentifier`, product/target names
2. Update `justfile`: Change `APP_BUNDLE_ID`
3. Update `fastlane/config.rb`: Change `SCHEMES[:app]`
4. Rename `TemplateApp.swiftpm` directory

### Testing

- Write tests in `Tests/AppModuleTests/`
- Import modules with `@testable import AppCore`
- Use Swift Testing framework (`import Testing`, `@Test` macro)
- Run locally with `just test`
- CI automatically runs tests on PR

### Build Artifacts

Builds are stored in `fastlane/build/`:
- `debug/archive/`: Debug archives
- `release/archive/`: Release archives
- `test-results/`: Test derived data and `.xcresult` bundles

## Key Differences from Other Templates

### vs. tca-tmpl (XcodeGen-based)

- **No XcodeGen**: No `project.envsubst.yml`, no `just gen-pj`
- **No Packages/ directory**: Dependencies declared in `Package.swift`
- **Simpler structure**: Two modules instead of feature-based packages
- **Direct xcodebuild**: No project file means simpler build commands

### vs. sftui-tmpl (Traditional Xcode)

- **No .xcodeproj**: SwiftPM package structure
- **Package.swift only**: All config in one file
- **No manual project management**: SwiftPM handles everything

## Common Tasks

### Run the app

```bash
just run-debug
```

### Run tests

```bash
just test
```

### Format and lint

```bash
just fix
just check
```

### Clean build artifacts

```bash
just resolve-pkg
```

### Add a new view

1. Create `NewView.swift` in `Sources/View/`
2. Import in `ContentView.swift` or other views
3. No project file changes needed

### Add a new test

1. Create test file in `Tests/AppTests/`
2. Import `@testable import View`
3. Write `@Test` functions
4. Run `just test`

## Documentation Rules

Documentation is written in a **declarative style** describing the current state of the system. Avoid imperative or changelog-style descriptions (e.g., do NOT write "Removed X and added Y" or "v5.1.2 changes..."). Describe what the system **is**, not what was done to it.
