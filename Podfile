use_frameworks!
platform :ios, '9.0'
target 'BeginChat' do
#    pod 'MOBFoundation_IDFA'
    pod 'SMSSDK'
    pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git', :branch => 'swift-4'
    pod 'AVOSCloudIM'
    pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'swift4'
    # IQKeyboardManager.swift 不支持swift4 ，暂时用OC版本替换
    pod 'IQKeyboardManager'
    pod 'Kingfisher', :git => 'https://github.com/onevcat/Kingfisher.git', :branch => 'swift4'
    pod 'MBProgressHUD'
    pod 'SQLite.swift', :git => 'https://github.com/stephencelis/SQLite.swift.git', :branch => 'swift-4'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end

