//
//  UIImage+Framebuffer.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 5/4/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit

// http://gabrieloc.com/2017/03/21/GIOVANNI.html
extension UIImage {
    convenience init?(width: Int, height: Int, data: [UInt8]) {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        guard let bitmapContext = CGContext(
            data: UnsafeMutablePointer(mutating: data),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
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
