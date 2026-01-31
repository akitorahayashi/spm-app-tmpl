# fastlane/lanes/build.rb
# Build-related lanes and helpers

# === Build-only Lanes ===
desc "Build unsigned debug archive"
lane :build_debug do |options|
  build_for_configuration(
    configuration: CONFIGURATIONS[:debug],
    xcargs: options[:xcargs] || ""
  )
end

desc "Build unsigned release archive"
lane :build_release do |options|
  build_for_configuration(
    configuration: CONFIGURATIONS[:release],
    xcargs: options[:xcargs] || ""
  )
end

desc "Build for testing"
lane :build_for_testing do |options|
  configuration = options[:configuration] || CONFIGURATIONS[:debug]
  derived_data_path = test_derived_data_dir(configuration)
  
  passed_xcargs = options[:xcargs] || ""
  
  xcargs_items = []
  if configuration == CONFIGURATIONS[:release]
    xcargs_items << "ENABLE_TESTABILITY=YES"
  end
  
  xcargs_items << passed_xcargs unless passed_xcargs.empty?
  xcargs = xcargs_items.join(' ')
  
  get_simulator_info(options)
  destination = Actions.lane_context[:SIMULATOR_DESTINATION]
  
  Dir.chdir(APP_PACKAGE_DIR) do
    cmd = [
      "xcodebuild build-for-testing",
      "-scheme #{SCHEMES[:app]}",
      "-destination '#{destination}'",
      "-derivedDataPath '#{derived_data_path}'",
      "-configuration #{configuration}",
      "-quiet"
    ]
    
    cmd << xcargs unless xcargs.empty?
    
    sh(cmd.join(' '))
  end
end

# === Private Lanes ===

def config_paths(configuration)
  case configuration
  when CONFIGURATIONS[:release]
    {
      archive_path: RELEASE_ARCHIVE_PATH,
      derived_data_path: RELEASE_DERIVED_DATA_DIR
    }
  when CONFIGURATIONS[:debug]
    {
      archive_path: DEBUG_ARCHIVE_PATH,
      derived_data_path: DEBUG_DERIVED_DATA_DIR
    }
  else
    UI.user_error!("Unknown configuration: #{configuration}. Must be one of #{CONFIGURATIONS.values.join(', ')}")
  end
end

private_lane :build_for_configuration do |options|
  configuration = options[:configuration]
  passed_xcargs = options[:xcargs] || ""
  paths = config_paths(configuration)
 
  Dir.chdir(APP_PACKAGE_DIR) do
    cmd = [
      "xcodebuild",
      "-scheme #{SCHEMES[:app]}",
      "-configuration #{configuration}",
      "-derivedDataPath '#{paths[:derived_data_path]}'",
      "-quiet"
    ]
    
    cmd << passed_xcargs unless passed_xcargs.empty?
    
    sh(cmd.join(' '))
  end
end

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
