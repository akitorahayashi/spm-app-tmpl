# ==============================================================================
# justfile for TemplateApp automation
# ==============================================================================

set dotenv-load := true

# --- PROJECT SETTINGS ---

APP_BUNDLE_ID := "com.akitorahayashi.TemplateApp"

# --- PROJECT SPECIFIC PATHS ---

HOME_DIR := env("HOME")

# --- ENVIRONMENT VARIABLES ---

TEAM_ID := env("TEAM_ID", "")
DEV_SIMULATOR_UDID := env("DEV_SIMULATOR_UDID", "")
TEST_SIMULATOR_UDID := env("TEST_SIMULATOR_UDID", "")

# ==============================================================================
# Modules
# ==============================================================================

# Load implementations under the fastlane directory as a module named 'fastlane'
mod fastlane "fastlane/just/main.just"

# ==============================================================================
# Main
# ==============================================================================

# default recipe
default: help

# Show available recipes
help:
    @echo "Usage: just [recipe]"
    @echo "Available recipes:"
    @just --list | tail -n +2 | awk '{printf "  \033[36m%-30s\033[0m %s\n", $1, substr($0, index($0, $2))}'

# ==============================================================================
# Environment Setup
# ==============================================================================

# Initialize project: install dependencies and bootstrap tools
setup:
    @echo "Installing Ruby gems..."
    @bundle install
    @if [ ! -f .env ]; then \
        cp .env.example .env && \
        echo "📝 Created .env file from .env.example."; \
    else \
        echo "📝 .env file already exists."; \
    fi
    @echo "Bootstrapping Mint packages..."
    @mint bootstrap
    @echo "✅ Setup complete! You can now open the project with: just open"

# Open project in Xcode
open:
    @xed App.swiftpm

# Reset SwiftPM cache and dependencies
resolve-pkg:
    @echo "Removing SwiftPM build and cache..."
    @rm -rf .build
    @rm -rf App.swiftpm/.build
    @echo "✅ SwiftPM build and cache removed."

# ==============================================================================
# Local Simulator
# ==============================================================================

# Boot local simulator
boot:
    @if [ -z "{{ DEV_SIMULATOR_UDID }}" ]; then \
        echo "DEV_SIMULATOR_UDID is not set. Please set it in your .env"; \
        exit 1; \
    fi
    @echo "Booting development simulator: UDID: {{ DEV_SIMULATOR_UDID }}"
    @if xcrun simctl list devices | grep -q "{{ DEV_SIMULATOR_UDID }} (Booted)"; then \
        echo "⚡️ Simulator is already booted."; \
    else \
        xcrun simctl boot {{ DEV_SIMULATOR_UDID }}; \
        echo "✅ Simulator booted."; \
    fi
    @open -a Simulator

# Boot test simulator
boot-test:
    @if [ -z "{{ TEST_SIMULATOR_UDID }}" ]; then \
        echo "TEST_SIMULATOR_UDID is not set. Please set it in your .env"; \
        exit 1; \
    fi
    @echo "Booting test simulator: UDID: {{ TEST_SIMULATOR_UDID }}"
    @if xcrun simctl list devices | grep -q "{{ TEST_SIMULATOR_UDID }} (Booted)"; then \
        echo "⚡️ Simulator is already booted."; \
    else \
        xcrun simctl boot {{ TEST_SIMULATOR_UDID }}; \
        echo "✅ Simulator booted."; \
    fi
    @open -a Simulator

# List available simulators
siml:
    @xcrun simctl list devices available

# ==============================================================================
# Lint & Format
# ==============================================================================

# Fix formatting and linting issues
fix:
    @just --fmt --unstable
    @find fastlane/just -name "*.just" -exec just --fmt --unstable --justfile {} \;
    @echo "Running SwiftFormat..."
    @mint run swiftformat App.swiftpm/Sources
    @echo "Running SwiftLint..."
    @mint run swiftlint --fix App.swiftpm/Sources
    @echo "✅ Formatting complete."

# Check formatting and linting (CI-safe)
check: fix
    @just --fmt --check --unstable
    @find fastlane/just -name "*.just" -exec just --fmt --check --unstable --justfile {} \;
    @echo "Checking code style with SwiftFormat..."
    @mint run swiftformat --lint App.swiftpm/Sources
    @echo "Running SwiftLint..."
    @mint run swiftlint lint App.swiftpm/Sources
    @echo "✅ Linting complete."

# ==============================================================================
# Delegations to Fastlane Module
# ==============================================================================

# Build debug archive (unsigned)
build-debug:
    @just fastlane::build-debug

# Build release archive (unsigned)
build-release:
    @just fastlane::build-release

# Build debug, install, and launch on local simulator
run-debug:
    @just fastlane::run-debug

# Build release, install, and launch on local simulator
run-release:
    @just fastlane::run-release

# Run all tests
test:
    @just fastlane::test

# Build for testing
build-test:
    @just fastlane::build-test
