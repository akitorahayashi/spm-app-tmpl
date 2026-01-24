# fastlane/lanes/test.rb
# Test-related lanes and helpers

require 'json'

# === Test Lanes ===

desc "Run all tests"
lane :test do |options|
  get_simulator_info(options)
  destination = Actions.lane_context[:SIMULATOR_DESTINATION]

  sh("rm -rf \"#{TEST_RESULT_BUNDLE}\"")
  
  configuration = options[:configuration] || CONFIGURATIONS[:debug]
  passed_xcargs = options[:xcargs] || ""
  
  xcargs_items = []
  if configuration == CONFIGURATIONS[:release]
    xcargs_items << "ENABLE_TESTABILITY=YES"
  end
  
  xcargs_items << passed_xcargs unless passed_xcargs.empty?
  xcargs = xcargs_items.join(' ')
  
  derived_data = test_derived_data_dir(configuration)

  Dir.chdir(APP_PACKAGE_DIR) do
    cmd = [
      "xcodebuild test",
      "-scheme #{SCHEMES[:app]}",
      "-destination '#{destination}'",
      "-derivedDataPath '#{derived_data}'",
      "-configuration #{configuration}",
      "-resultBundlePath '#{TEST_RESULT_BUNDLE}'",
      "-enableCodeCoverage YES",
      "-quiet"
    ]

    cmd << xcargs unless xcargs.empty?

    sh(cmd.join(' '))
  end
end

desc "Run tests without building"
lane :test_without_building do |options|
  get_simulator_info(options)
  destination = Actions.lane_context[:SIMULATOR_DESTINATION]

  sh("rm -rf \"#{TEST_RESULT_BUNDLE}\"")
  
  configuration = options[:configuration] || CONFIGURATIONS[:debug]
  derived_data = test_derived_data_dir(configuration)
 
  Dir.chdir(APP_PACKAGE_DIR) do
    cmd = [
      "xcodebuild test-without-building",
      "-scheme #{SCHEMES[:app]}",
      "-destination '#{destination}'",
      "-derivedDataPath '#{derived_data}'",
      "-configuration #{configuration}",
      "-resultBundlePath '#{TEST_RESULT_BUNDLE}'",
      "-quiet"
    ]

    sh(cmd.join(' '))
  end
end

# === Private Lanes ===

desc "Get simulator information based on environment"
private_lane :get_simulator_info do |options|
  udid = options[:udid]
  if udid.nil? || udid.empty?
    if is_ci?
      udid = find_available_iphone_simulator_udid
      if udid.nil? || udid.empty?
        UI.message("No available simulator UDID found in CI. Falling back to simulator name.")
      end
    else
      UI.user_error!("UDID is not specified. Please pass the udid option from the justfile.")
    end
  end

  if udid.nil? || udid.empty?
    Actions.lane_context[:SIMULATOR_DESTINATION] = "platform=iOS Simulator,name=iPhone 17 Pro"
  else
    Actions.lane_context[:SIMULATOR_DESTINATION] = "platform=iOS Simulator,id=#{udid}"
  end
  Actions.lane_context[:SIMULATOR_UDID] = udid
end

desc "Find an available iPhone simulator UDID (CI helper)"
private_lane :find_available_iphone_simulator_udid do
  devices_output = sh("xcrun simctl list devices available -j 2>/dev/null", log: false)
  json_start = devices_output.index('{')
  json_end = devices_output.rindex('}')
  next nil if json_start.nil? || json_end.nil?

  devices = JSON.parse(devices_output[json_start..json_end])

  fallback_udid = nil
  found_udid = nil
  devices['devices'].each do |runtime, device_list|
    next unless runtime.include?('iOS')
    device_list.each do |device|
      next unless device['isAvailable']
      if device['name'].include?('iPhone')
        found_udid = device['udid']
        break
      end
      fallback_udid ||= device['udid']
    end
    break if found_udid
  end

  found_udid || fallback_udid
end
