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
    
    cmd << "-xcargs #{xcargs}" unless xcargs.empty?
    
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
    
    cmd << "-xcargs #{passed_xcargs}" unless passed_xcargs.empty?
    
    sh(cmd.join(' '))
  end
end
