 platform :ios, '15.0'

target 'Favourite Map' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Favourite Map
  pod 'SwiftLint'
  
  target 'Favourite MapTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Favourite MapUITests' do
    # Pods for testing
  end

end

plugin 'cocoapods-keys', {
  :project => "FavouriteMap",
  :keys => [
    "WeatherApiKey"
  ]}

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
