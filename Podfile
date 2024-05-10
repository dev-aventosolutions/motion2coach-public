# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  #For Textfields
  pod 'DTTextField'
  pod 'IQKeyboardManagerSwift'
  pod 'Fastis', '~> 1.0.0'
  pod 'SideMenu'
  pod 'Starscream'
  pod 'StepSlider', '~> 1.3.0'
  pod 'TensorFlowLiteSwift', "~> 2.3.0"
  
  # If you want to use the base implementation:
  pod 'GoogleMLKit/PoseDetection', '3.1.0'
  
  # If you want to use the accurate implementation:
  pod 'GoogleMLKit/PoseDetectionAccurate', '3.1.0'
  
  # Pods for M2C
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
    end
  end
end


target 'M2C' do
  shared_pods
end

target 'M2C External' do
  shared_pods
end

target 'M2C Internal' do
  shared_pods
end

target 'M2C Dev' do
  shared_pods
end
