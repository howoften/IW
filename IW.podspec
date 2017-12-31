Pod::Spec.new do |s|
  s.name         = "IW"
  s.version      = "0.1.6"
  s.summary      = "Make Swift faster and use it more smoothly."
  s.description  = "Make Swift faster and use it more smoothly with cocoapod support."

  s.homepage     = "https://github.com/iWECon/IW"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "IWECon" => "i.1214@yahoo.com" }
  # Or just: s.author    = "iWe"
  # s.authors            = { "iWe" => "i.1214@yahoo.com" }
  # s.social_media_url   = "http://twitter.com/iWe"


  # s.platform     = :ios
  s.platforms     = { :ios => "8.0" }

  s.source       = { :git => "https://github.com/iWECon/IW.git", :tag => "#{s.version}" }

  s.source_files  = "IW/**/*.swift"
  s.module_name   = "CommonCrypto"

  s.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS[config=Debug][sdk=*][arch=*]' => 'DEBUG' }

  s.xcconfig         = { 'HEADER_SEARCH_PATHS' =>     '$(SDKROOT)/usr/include/CommonCrypto/CommonCrypto.h'}
  s.preserve_paths = 'CocoaPods/**/*'
  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=macosx*]'           => '$(PODS_ROOT)/IW/CocoaPods/macosx',
    'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(PODS_ROOT)/IW/CocoaPods/iphoneos',
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_ROOT)/IW/CocoaPods/iphonesimulator',
    'SWIFT_INCLUDE_PATHS[sdk=appletvos*]'        => '$(PODS_ROOT)/IW/CocoaPods/appletvos',
    'SWIFT_INCLUDE_PATHS[sdk=appletvsimulator*]' => '$(PODS_ROOT)/IW/CocoaPods/appletvsimulator',
    'SWIFT_INCLUDE_PATHS[sdk=watchos*]'          => '$(PODS_ROOT)/IW/CocoaPods/watchos',
    'SWIFT_INCLUDE_PATHS[sdk=watchsimulator*]'   => '$(PODS_ROOT)/IW/CocoaPods/watchsimulator'
  }

  # s.framework  = "SomeFramework"
  # s.frameworks = "UIKit", "WebKit", "Foundation", "JavaScriptCore", "UserNotifications", "AssetsLibrary", "AddressBook", "Intents"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.prepare_command = <<-CMD
	./CocoaPods/injectXcodePath.sh
  CMD
end
