Pod::Spec.new do |s|
  s.name             = 'KingfisherSVG'
  s.version          = '1.0.0'
  s.swift_version    = '5.9'
  s.summary          = 'A Kingfisher extension helping you process svg format'

  s.description      = <<-DESC
KingfisherWebP is an extension of the [Kingfisher](https://github.com/onevcat/Kingfisher), providing a ImageProcessor and CacheSerializer for you to conveniently handle the svg format.
                       DESC

  s.homepage         = 'https://github.com/octree/KingfisherSVG'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Octree' => 'fouljz@gmail.com' }
  s.source           = { :git => 'https://github.com/octree/KingfisherSVG.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_octree'

  s.ios.deployment_target = "13.0"
  s.watchos.deployment_target = "6.0"
  s.tvos.deployment_target = "13.0"
  s.source_files = 'Sources/**/*.{swift}'
  s.dependency 'Kingfisher', '~> 7.8.1'
end