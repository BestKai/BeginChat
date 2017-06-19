use_frameworks!
platform :ios, '9.0'
target 'BeginChat' do
    pod 'MOBFoundation_IDFA'
    pod 'SMSSDK'
    pod 'SnapKit'
    pod 'AVOSCloudIM'
    pod 'Alamofire'
    pod 'IQKeyboardManagerSwift'
    pod 'Kingfisher'
    pod 'MBProgressHUD'
#    pod 'SQLite.swift', '~> 0.11.3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end

