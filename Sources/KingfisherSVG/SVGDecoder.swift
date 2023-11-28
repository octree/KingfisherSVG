//
//  SVGDecoder.swift
//  KingfisherSVG
//
//  Created by Octree on 2023/11/28.
//
//  Copyright (c) 2023 Octree <fouljz@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import CoreGraphics
import Kingfisher
import UIKit

@inline(__always)
private func base64DecodedString(from text: String) -> String {
    let data = Data(base64Encoded: text, options: .ignoreUnknownCharacters)!
    return String(data: data, encoding: .utf8)!
}

private extension UnsafeMutableRawPointer {
    func convert<T>(to type: T.Type) -> T {
        unsafeBitCast(self, to: type)
    }
}

public class SVGCoder {
    public static let shared: SVGCoder = .init()
    private let release: @convention(c) (UnsafeMutableRawPointer) -> Void
    private let createDocument: @convention(c) (CFData, CFDictionary?) -> UnsafeMutableRawPointer?
    private let createImage: Selector
    private let svgTag = "</svg>".data(using: .utf8)!
    private init() {
        var name = base64DecodedString(from: "Q0dTVkdEb2N1bWVudFJldGFpbg==")
        name = base64DecodedString(from: "Q0dTVkdEb2N1bWVudFJlbGVhc2U=")
        release = name.withCString {
            dlsym(UnsafeMutableRawPointer(bitPattern: -2), $0)
        }!.convert(to: (@convention(c) (UnsafeMutableRawPointer) -> Void).self)

        name = base64DecodedString(from: "Q0dTVkdEb2N1bWVudENyZWF0ZUZyb21EYXRh")
        createDocument = name.withCString {
            dlsym(UnsafeMutableRawPointer(bitPattern: -2), $0)
        }!.convert(to: (@convention(c) (CFData, CFDictionary?) -> UnsafeMutableRawPointer?).self)

        createImage = NSSelectorFromString(base64DecodedString(from: "X2ltYWdlV2l0aENHU1ZHRG9jdW1lbnQ6"))
    }

    public func createVectorSVG(data: Data) -> KFCrossPlatformImage? {
        guard let pointer = createDocument(data as CFData, nil) else { return nil }
        let document = Unmanaged<NSObject>.fromOpaque(pointer).takeUnretainedValue()
        let image = UIImage.perform(createImage, with: document).takeUnretainedValue() as? UIImage
        release(pointer)
        return image
    }

    public func canDecode(data: Data) -> Bool {
        data.range(of: svgTag,
                   options: .backwards,
                   in: (data.count - min(100, data.count)) ..< data.count) != nil
    }
}
