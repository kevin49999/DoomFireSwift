//
//  UIImage+Framebuffer.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 5/4/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit

// https://github.com/nicklockwood/Swiftenstein
// http://gabrieloc.com/2017/03/21/GIOVANNI.html

extension UIImage {
    convenience init?(bitmap: Bitmap) {
        guard let providerRef = CGDataProvider(data: NSData(
            bytes: bitmap.pixels, length: bitmap.pixels.count * MemoryLayout<Color>.size
        )) else {
            return nil
        }
        
        guard let cgImage = CGImage(
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: bitmap.width * MemoryLayout<Color>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
            ) else {
                return nil
        }
        
        self.init(cgImage: cgImage)
    }
}
