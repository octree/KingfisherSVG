import XCTest
@testable import KingfisherSVG

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class KingfisherSVGTests: XCTestCase {
    private let svgData = """
    <svg xmlns="http://www.w3.org/2000/svg" width="10" height="10">
        <rect width="10" height="10" fill="red"/>
    </svg>
    """.data(using: .utf8)!

    func testCanDecodeSVGFormat() {
        XCTAssertTrue(SVGCoder.shared.canDecode(data: svgData))
        XCTAssertFalse(SVGCoder.shared.canDecode(data: Data("not svg".utf8)))
    }

    func testDecodeAndRenderSVGData() {
        guard let image = SVGCoder.shared.decode(data: svgData) else {
            XCTFail("Expected SVG data to decode into an image.")
            return
        }

        XCTAssertEqual(image.size.width, 10)
        XCTAssertEqual(image.size.height, 10)
        XCTAssertTrue(image.rendersRedPixel)
    }
}

#if os(macOS)
private extension NSImage {
    var rendersRedPixel: Bool {
        guard let pixel = renderedPixel else { return false }
        return pixel[0] > 200 && pixel[1] < 50 && pixel[2] < 50 && pixel[3] > 200
    }

    var renderedPixel: [UInt8]? {
        guard let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: 1,
            pixelsHigh: 1,
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 4,
            bitsPerPixel: 32
        ) else {
            return nil
        }

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        draw(in: NSRect(x: 0, y: 0, width: 1, height: 1))
        NSGraphicsContext.current?.flushGraphics()
        NSGraphicsContext.restoreGraphicsState()

        guard let data = bitmap.bitmapData else { return nil }
        return [data[0], data[1], data[2], data[3]]
    }
}
#elseif canImport(UIKit)
private extension UIImage {
    var rendersRedPixel: Bool {
        guard let pixel = renderedPixel else { return false }
        return pixel[0] > 200 && pixel[1] < 50 && pixel[2] < 50 && pixel[3] > 200
    }

    var renderedPixel: [UInt8]? {
        var pixel = [UInt8](repeating: 0, count: 4)
        guard let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }

        UIGraphicsPushContext(context)
        draw(in: CGRect(x: 0, y: 0, width: 1, height: 1))
        UIGraphicsPopContext()

        return pixel
    }
}
#endif
