# ==============================================================================
# Testing (Fastlane)
# ==============================================================================

# Run all tests
[no-cd]
test:
    @just fastlane::_run_fastlane "test"

# Run tests without building
[no-cd]
test-without-building:
    @just fastlane::_run_fastlane "test_without_building"
