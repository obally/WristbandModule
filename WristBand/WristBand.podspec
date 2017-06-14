Pod::Spec.new do |s|

  s.name         = "WristBand"
  s.version      = "0.0.5"
  s.summary      = "A module of WristBand."
  s.description  = <<-DESC
        A module of WristBand use MJRouter
                   DESC

  s.homepage     = "https://github.com/obally/WristbandModule.git"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "liujiao" => "2603729194@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/obally/WristbandModule.git", :tag => "#{s.version}" }
  s.source_files  =  "WristBand/SYWristband/WristbandComponent/**/*.{h,m}","WristBand/SYWristband/BaseComponent/**/*.{h,m}"
  s.prefix_header_file = 'WristBand/SYWristband/PrefixHeader.pch'
  s.framework = 'MobileCoreServices', 'CoreGraphics','CoreBluetooth'
  s.vendored_libraries = "WristBand/SYWristband/WristbandComponent/libs/libSharkeySDKWithiOS.a"
  s.public_header_files = 'WristBand/SYWristband/WristbandComponent/WristbandModule/*.h'
# s.resource  = "WristBand/SYWristband/WristbandComponent/Source/Model.xcdatamodeld"
  s.resources  = "WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/**/*.png","WristBand/SYWristband/WristbandComponent/Source/Model.xcdatamodeld"
  s.xcconfig = { "OTHER_LDFLAGS" => "-lz" }
  s.dependency 'MagicalRecord'
  s.dependency 'OBBase'
end
