//
//  ViewController.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 3/2/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit

// http://fabiensanglard.net/doom_fire_psx/index.html
// http://fabiensanglard.net/doom_fire_psx/index.html
// http://fabiensanglard.net/doom_fire_psx/index.html

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var fireWidth = fireImageView.image!.cgImage!.width
    lazy var fireHeight = fireImageView.image!.cgImage!.height
    
    var firePixels = [Int: Int]()
    var rgbs: [RGBA32] = [
        RGBA32(red: 7, green: 7, blue: 7, alpha: 255),
        RGBA32(red: 31, green: 7, blue: 7, alpha: 255),
        RGBA32(red: 37, green: 15, blue: 7, alpha: 255),
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0x57,0x17,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0x67,0x1F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0x77,0x1F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0x8F,0x27,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0x9F,0x2F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xAF,0x3F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xBF,0x47,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xC7,0x47,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xDF,0x4F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xDF,0x57,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xDF,0x57,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xD7,0x5F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xD7,0x5F,0x07,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xD7,0x67,0x0F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xCF,0x6F,0x0F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xCF,0x77,0x0F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xCF,0x7F,0x0F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xCF,0x87,0x17,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xC7,0x87,0x17,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xC7,0x8F,0x17,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xC7,0x97,0x1F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xBF,0x9F,0x1F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xBF,0x9F,0x1F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xBF,0xA7,0x27,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xBF,0xA7,0x27,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xBF,0xAF,0x2F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xB7,0xAF,0x2F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xB7,0xB7,0x2F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xB7,0xB7,0x37,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xCF,0xCF,0x6F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xDF,0xDF,0x9F,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
//        0xEF,0xEF,0xC7,
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255)
//        0xFF,0xFF,0xFF
    ]
    
    @IBOutlet weak var fireImageView: UIImageView!
    @IBOutlet weak var fireView: UIView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirePixels()
        drawScreen()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
            self.doFire()
            self.drawScreen()
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
    
    // MARK: - 🔥🔥🔥
    
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
    
    // MARK: - Draw
    
    func drawScreen() {
        //https://stackoverflow.com/questions/31661023/change-color-of-certain-pixels-in-a-uiimage
        guard let image = fireImageView.image, let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return
        }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for x in 0..<fireWidth {
            for y in 0..<fireHeight {
                guard let colorIndex = firePixels[y * fireWidth + x] else {
                    assertionFailure()
                    break
                }
                let color = rgbs[colorIndex]
                pixelBuffer[y * fireWidth + x] = color
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        fireImageView.image = outputImage
    }
}
