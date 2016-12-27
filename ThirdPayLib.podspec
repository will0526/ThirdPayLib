#
# Be sure to run `pod lib lint ThirdPayLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ThirdPayLib'
  s.version          = '1.0.2'
  s.summary          = 'To provide a sdk which used to pay online for other app'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    To provide a sdk which used to pay online for other app.
    easy to pay.
                       DESC

  s.homepage         = 'https://github.com/will0526/ThirdPayLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'willwang' => 'willwyy@163.com' }
  s.source           = { :git => 'https://github.com/will0526/ThirdPayLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files = 'ThirdPayLib/Classes/**/*','Alipay.framework/Headers/*.h'
  s.resource_bundles = {
    'ThirdPayLib' => ['ThirdPayLib/Assets/*.png']
  }

    s.public_header_files = 'ThirdPayLib/Classes/ThirdPay.h'
    s.frameworks = 'UIKit', 'CoreGraphics', 'AVFoundation', 'AudioToolbox','CoreMotion','CFNetwork','CoreText','QuartzCore','CoreTelephony','SystemConfiguration','Foundation'
    s.libraries = 'z','c++','stdc++','sqlite3.0'
    s.dependency 'AFNetworking', '~> 3.0'
    s.vendored_libraries = 'Example/ThirdPayLib/wxSDK/libWeChatSDK.a','Example/ThirdPayLib/Bestpaylib/libH5ContainerStaticLib.a'



end
