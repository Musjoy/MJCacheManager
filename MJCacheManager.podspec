#
# Be sure to run `pod lib lint MJCacheManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJCacheManager'
  s.version          = '0.1.2'
  s.summary          = 'The management of the resource cache.'

  s.homepage         = 'https://github.com/Musjoy/MJCacheManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ray' => 'Ray.musjoy@gmail.com' }
  s.source           = { :git => 'https://github.com/Musjoy/MJCacheManager.git', :tag => "v-#{s.version}" }

  s.ios.deployment_target = '7.0'

  s.source_files = 'MJCacheManager/Classes/**/*'

  s.user_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'MODULE_CACHE_MANAGER'
  }

  s.dependency 'MJWebService', '~> 0.1'
  s.dependency 'ModuleCapability', '~> 0.1'
  s.prefix_header_contents = '#import "ModuleCapability.h"'

end
