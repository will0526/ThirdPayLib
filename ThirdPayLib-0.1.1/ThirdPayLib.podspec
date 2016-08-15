Pod::Spec.new do |s|
  s.name = 'ThirdPayLib'
  s.version = '0.1.1'
  s.summary = 'A short description of ThirdPayLib.'
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"willwang"=>"willwyy@163.com"}
  s.homepage = 'https://github.com/will0526/ThirdPayLib'
  s.description = 'TODO: Add long description of the pod here.'
  s.frameworks = ["UIKit", "MapKit"]
  s.source = .a

  s.ios.deployment_target    = '7.0'
  s.ios.preserve_paths       = 'ios/ThirdPayLib.framework'
  s.ios.public_header_files  = 'ios/ThirdPayLib.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/ThirdPayLib.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/ThirdPayLib.framework'
end
