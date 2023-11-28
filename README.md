# KingfisherSVG

**KingfisherSVG** is an extension of the  [Kingfisher](https://github.com/onevcat/Kingfisher), providing an ImageProcessor and CacheSerializer for you to conveniently handle the **SVG Format**

## Installation

### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add https://github.com/octree/KingfisherSVG.git
- Select "Up to Next Major" with "1.0.0"

## Usage

```swift
// After your application launches
KingfisherManager.shared.defaultOptions += [
    .processor(SVGProcessor.default),
    .cacheSerializer(SVGCacheSerializer.default)
]

imageView.kf.setImage(with: url)
```

## License

**KingfisherSVG** is available under the MIT license. See the LICENSE file for more info.