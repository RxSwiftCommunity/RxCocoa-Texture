Pod::Spec.new do |s|
  s.name             = 'RxCocoa-Texture'
  s.version          = '2.2.0'
  s.summary          = 'RxCocoa Extension Library for Texture'

  s.description      = 'This library is built on Texture with RxCocoa, RxCocoa is a framework that helps make Cocoa APIs used in iOS and OS X easier to use with reactive techniques.'

  s.homepage         = 'https://github.com/Geektree0101/RxCocoa-Texture'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
  s.source           = { :git => 'https://github.com/GeekTree0101/RxCocoa-Texture.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'RxCocoa-Texture/Classes/**/*'

  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'
  s.dependency 'Texture', '2.6'
end
