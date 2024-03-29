require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "react-native-gif-player"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "12.0" }
  s.source       = { :git => "https://github.com/ysfzrn/react-native-gif-player.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # Don't install the dependencies when we run `pod install` in the old architecture.
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
    s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
    s.pod_target_xcconfig    = {
        "DEFINES_MODULE" => "YES",
        #"HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
        #"OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        #"CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
        "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "react-native-gif-manager-Swift.h",
        "OTHER_SWIFT_FLAGS" => "-DNATIVE_LIST_PACKAGE_NEW_ARCH_ENABLED"
    }
    else
      s.pod_target_xcconfig = {
        "DEFINES_MODULE" => "YES",
        "SWIFT_OBJC_INTERFACE_HEADER_NAME" => "react-native-gif-manager-Swift.h"
    }
  end
  install_modules_dependencies(s)
end
