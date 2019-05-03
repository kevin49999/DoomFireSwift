//
//  ViewController.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 3/2/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit
import CoreGraphics

// http://fabiensanglard.net/doom_fire_psx/index.html 🔥

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let fireWidth = 40
    let fireHeight = 80
    
    var firePixels = [Int: Int]()
    var frameBuffer = [Int: [UInt8]]()
    var rgbs: [UInt8] = [
        0, 7, 7, 7,
        0, 31, 7, 7,
        0, 47, 15,  7,
        0, 71, 15,  7,
        0, 87, 23,  7,
        0, 103, 31, 7,
        0, 119, 31, 7,
        0, 143, 39, 7,
        0, 159, 47, 7,
        0, 175, 63, 7,
        0, 191, 71, 7,
        0, 199, 71, 7,
        0, 223, 79, 7,
        0, 223, 87, 7,
        0, 223, 87, 7,
        0, 215, 95, 7,
        0, 215, 95, 7,
        0, 215, 103, 15,
        0, 207, 111, 15,
        0, 207, 119, 15,
        0, 207, 127, 15,
        0 ,207, 135, 23,
        0, 199, 135, 23,
        0, 199, 143, 23,
        0, 199, 151, 31,
        0, 191, 159, 31,
        0, 191, 159, 31,
        0, 191, 167, 39,
        0, 191, 167, 39,
        0, 191, 175, 47,
        0, 183, 175, 47,
        0, 183, 183, 47,
        0, 183, 183, 55,
        0, 207, 207, 111,
        0, 223, 223, 159,
        0, 239, 239, 199,
        0, 255, 255, 255
    ]
    
    @IBOutlet weak var fireImageView: UIImageView! {
        didSet {
            fireImageView.layer.magnificationFilter = CALayerContentsFilter(rawValue: kCISamplerFilterNearest)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFirePixels()
        renderFrame()
        
        // 60 fps
        let _ = Timer.scheduledTimer(withTimeInterval: 0.01666667, repeats: true, block: { _ in
            self.doFire()
            self.renderFrame()
        })
    }
    
    // MARK: - Setup
    
    func setupFirePixels() {
        /// "Set whole screen to 0 (color: 0x070707)"
        for i in 0..<fireWidth * fireHeight {
            firePixels[i] = 0
        }
        
        // "Set bottom line to 37 (color white: 0xFFFFFF)"
        for i in 0..<fireWidth {
            firePixels[(fireHeight - 1) * fireWidth + i] = 36
        }
    }
    
    // MARK: - Frame Handling
    
    func renderFrame() {
        writeToFrameBuffer()
        let data = frameBuffer.values.reduce([UInt8](), +)
        fireImageView.image = makeImage(width: 40, height: 80, data: data)
    }
    
    func writeToFrameBuffer() {
        for x in 0..<fireWidth {
            for y in 0..<fireHeight {
                guard let colorIndex = firePixels[y * fireWidth + x] else {
                    assertionFailure("Offset out of bounds")
                    break
                }
                
                let adjustedIndex = colorIndex * 4
                let colorStart = rgbs[adjustedIndex]
                let a = rgbs[adjustedIndex + 1]
                let b = rgbs[adjustedIndex + 2]
                let c = rgbs[adjustedIndex + 3]
                frameBuffer[y * fireWidth + x] = [colorStart, a, b, c]
            }
        }
    }
    
    // MARK: - Fire Spreading 🔥🚒🚒🚒
    
    func doFire() {
        for x in 0..<fireWidth {
            for y in 0..<fireHeight {
                spreadFire(src: y * fireWidth + x)
            }
        }
    }
    
    func spreadFire(src: Int) {
        guard let pixel = firePixels[src] else {
            assertionFailure("Missing pixel at: \(src)")
            return
        }
        
        if pixel == 0 {
            firePixels[src - fireWidth] = 0
            return
        }
        let rand = Int(round(Double.random(in: 0..<1) * 3.0)) & 3
        let dst = src - rand + 1
        firePixels[dst - fireWidth] = pixel - (rand & 1)
    }
    
    // MARK: - Make Image: http://gabrieloc.com/2017/03/21/GIOVANNI.html
    
    func makeImage(width: Int, height: Int, data: [UInt8]) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        guard let bitmapContext = CGContext(
            data: UnsafeMutablePointer(mutating: data),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageByteOrderInfo.order32Big.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue
            ),
            let cgImage = bitmapContext.makeImage()
            else {
                return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
