# fastlane/config.rb
# Fastlane configuration values

# === Scheme Constants ===
SCHEMES = {
  app: "TemplateApp"
}.freeze

# === Test Paths ===
BUILD_PATH = "build"
LOGS_PATH = "fastlane/logs"
TEST_LOGS_PATH = "#{LOGS_PATH}/test"
BUILD_LOGS_PATH = "#{LOGS_PATH}/build"

TEST_RESULTS_PATH = "#{BUILD_PATH}/test-results"
TEST_RESULT_PATH = "#{TEST_RESULTS_PATH}/TestResults.xcresult"

# === Archive Paths ===
DEBUG_EXPORT_BASE = "fastlane/build/debug"
RELEASE_EXPORT_BASE = "fastlane/build/release"
DEBUG_ARCHIVE_PATH = "#{DEBUG_EXPORT_BASE}/archive/TemplateApp.xcarchive"
RELEASE_ARCHIVE_PATH = "#{RELEASE_EXPORT_BASE}/archive/TemplateApp.xcarchive"

# === Build DerivedData Paths ===
TEST_DERIVED_DATA_PATH = "fastlane/build/test-results/DerivedData"
DEBUG_BUILD_DERIVED_DATA_PATH = "fastlane/build/debug/archive/DerivedData"
RELEASE_BUILD_DERIVED_DATA_PATH = "fastlane/build/release/archive/DerivedData"

# === Configurations ===
CONFIGURATIONS = {
  debug: "Debug",
  release: "Release",
}.freeze
