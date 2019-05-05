//
//  UIImage+Framebuffer.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 5/4/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit

// https://github.com/nicklockwood/Swiftenstein
struct Bitmap {
    let width: Int
    let height: Int
    let colorData: [UInt8]
}

// http://gabrieloc.com/2017/03/21/GIOVANNI.html
extension UIImage {
    convenience init?(bitmap: Bitmap) {
        UIGraphicsBeginImageContext(CGSize(width: bitmap.width, height: bitmap.height))
        guard let bitmapContext = CGContext(
            data: UnsafeMutablePointer(mutating: bitmap.colorData),
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bytesPerRow: bitmap.width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageByteOrderInfo.order32Big.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue
            ),
            let cgImage = bitmapContext.makeImage()
            else {
                return nil
        }
        self.init(cgImage: cgImage)
    }
}
