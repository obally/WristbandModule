Pod::Spec.new do |s|
  s.name = "WristBand"
  s.version = "0.0.4"
  s.summary = "A module of WristBand."
  s.license = {"type"=>"MIT", "file"=>"FILE_LICENSE"}
  s.authors = {"liujiao"=>"2603729194@qq.com"}
  s.homepage = "https://github.com/obally/WristbandModule.git"
  s.description = "A module of WristBand use MJRouter"
  s.frameworks = ["MobileCoreServices", "CoreGraphics", "CoreBluetooth"]
  s.xcconfig = {"OTHER_LDFLAGS"=>"-lz"}
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/WristBand.framework'
end
