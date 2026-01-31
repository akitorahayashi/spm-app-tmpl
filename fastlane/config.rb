# fastlane/config.rb
# Fastlane configuration values

# === App Constants ===
APP_NAME = "TemplateApp"

# === Project Structure ===
# This file is at <project>/fastlane/config.rb
FASTLANE_DIR = __dir__
PROJECT_ROOT = File.expand_path('..', FASTLANE_DIR)
APP_PACKAGE_DIR = File.join(PROJECT_ROOT, "App.swiftpm")

# === Scheme Constants ===
SCHEMES = {
  app: "TemplateApp"
}.freeze

# === Configurations ===
CONFIGURATIONS = {
  debug: "Debug",
  release: "Release",
}.freeze

# === Output Directories ===
# All build outputs are organized under fastlane/build/
BUILD_ROOT = File.join(FASTLANE_DIR, "build")
LOGS_ROOT = File.join(FASTLANE_DIR, "logs")

# Test outputs
TEST_RESULTS_DIR = File.join(BUILD_ROOT, "test-results")
TEST_RESULT_BUNDLE = File.join(TEST_RESULTS_DIR, "TestResults.xcresult")

# DerivedData paths (per configuration)
def test_derived_data_dir(configuration)
  File.join(TEST_RESULTS_DIR, "DerivedData", configuration)
end

# Archive outputs
DEBUG_BUILD_DIR = File.join(BUILD_ROOT, "debug")
RELEASE_BUILD_DIR = File.join(BUILD_ROOT, "release")

DEBUG_ARCHIVE_PATH = File.join(DEBUG_BUILD_DIR, "archive", "#{APP_NAME}.xcarchive")
RELEASE_ARCHIVE_PATH = File.join(RELEASE_BUILD_DIR, "archive", "#{APP_NAME}.xcarchive")

DEBUG_DERIVED_DATA_DIR = File.join(DEBUG_BUILD_DIR, "archive", "DerivedData")
RELEASE_DERIVED_DATA_DIR = File.join(RELEASE_BUILD_DIR, "archive", "DerivedData")

# Logs
TEST_LOGS_DIR = File.join(LOGS_ROOT, "test")
BUILD_LOGS_DIR = File.join(LOGS_ROOT, "build")
