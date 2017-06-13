Pod::Spec.new do |s|

  s.name         = "WristBand"
  s.version      = "0.0.1"
  s.summary      = "A module of WristBand."
  s.description  = <<-DESC
        A module of WristBand use MJRouter
                   DESC

  s.homepage     = "https://github.com/obally/WristbandModule.git"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "liujiao" => "2603729194@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/obally/WristbandModule.git", :tag => "#{s.version}" }
  s.source_files  =  "SYWristband/WristbandComponent/WristbandModule/**/*.{h,m}"

 s.public_header_files = "Classes/**/*.h"
s.prefix_header_file = 'SYWristband/PrefixHeader.pch'
s.framework = 'MobileCoreServices', 'CoreGraphics','CoreBluetooth'
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
s.vendored_libraries = "SYWristband/WristbandComponent/libs/libSharkeySDKWithiOS.a"
s.resource  = "SYWristband/WristbandComponent/Source/Model.xcdatamodeld"
s.resources  = "SYWristband/WristbandComponent/Source/wristBandImage.xcassets/**/.png"
    s.dependency 'MagicalRecord'
    s.dependency 'OBBase'
end
