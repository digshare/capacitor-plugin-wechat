require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'MufanCapacitorPluginWechat'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC -all_load' }
  s.vendored_libraries = "ios/Plugin/OpenSDK/libWechatSDK.a"
  s.static_framework = true
  s.libraries = 'c++'
  
  s.ios.deployment_target  = '12.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
end
