//
//  ViewController.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 3/2/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit

// http://fabiensanglard.net/doom_fire_psx/index.html 🔥

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var firePixels = [Int: Int]()
    var rgbs: [RGBA32] = [
        RGBA32(red: 7, green: 7, blue: 7, alpha: 255),
        RGBA32(red: 31, green: 7, blue: 7, alpha: 255),
        RGBA32(red: 37, green: 15, blue: 7, alpha: 255),
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
        RGBA32(red: 113, green: 23, blue: 7, alpha: 255),
        RGBA32(red: 103, green: 31, blue: 7, alpha: 255),
        RGBA32(red: 119, green: 31, blue: 7, alpha: 255),
        RGBA32(red: 143, green: 39, blue: 7, alpha: 255),
        RGBA32(red: 159, green: 47, blue: 7, alpha: 255),
        RGBA32(red: 175, green: 63, blue: 7, alpha: 255),
        RGBA32(red: 71, green: 15, blue: 7, alpha: 255),
        RGBA32(red: 191, green: 71, blue: 7, alpha: 255),
        RGBA32(red: 199, green: 71, blue: 7, alpha: 255),
        RGBA32(red: 223, green: 79, blue: 7, alpha: 255),
        RGBA32(red: 223, green: 88, blue: 7, alpha: 255),
        RGBA32(red: 223, green: 87, blue: 7, alpha: 255),
        RGBA32(red: 215, green: 95, blue: 7, alpha: 255),
        RGBA32(red: 215, green: 95, blue: 7, alpha: 255),
        RGBA32(red: 215, green: 103, blue: 7, alpha: 255),
        RGBA32(red: 207, green: 111, blue: 15, alpha: 255),
        RGBA32(red: 207, green: 119, blue: 15, alpha: 255),
        RGBA32(red: 207, green: 127, blue: 15, alpha: 255),
        RGBA32(red: 207, green: 135, blue: 23, alpha: 255),
        RGBA32(red: 199, green: 135, blue: 23, alpha: 255),
        RGBA32(red: 199, green: 143, blue: 23, alpha: 255),
        RGBA32(red: 199, green: 151, blue: 31, alpha: 255),
        RGBA32(red: 191, green: 159, blue: 31, alpha: 255), /// log old and compare.. got off somewhere
        RGBA32(red: 191, green: 167, blue: 39, alpha: 255),
        RGBA32(red: 191, green: 167, blue: 39, alpha: 255),
        RGBA32(red: 191, green: 175, blue: 45, alpha: 255),
        RGBA32(red: 183, green: 175, blue: 45, alpha: 255),
        RGBA32(red: 183, green: 183, blue: 47, alpha: 255),
        RGBA32(red: 183, green: 183, blue: 55, alpha: 255),
        RGBA32(red: 207, green: 207, blue: 111, alpha: 255),
        RGBA32(red: 223, green: 223, blue: 159, alpha: 255),
        RGBA32(red: 239, green: 239, blue: 199, alpha: 255),
        RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    ]
    
    lazy var fireWidth = fireImageView.image!.cgImage!.width
    lazy var fireHeight = fireImageView.image!.cgImage!.height
    @IBOutlet weak var fireImageView: UIImageView!
    
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
        // https://stackoverflow.com/questions/31661023/change-color-of-certain-pixels-in-a-uiimage
        guard let image = fireImageView.image, let inputCGImage = image.cgImage else {
            assertionFailure("Unable to get cgImage")
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
            assertionFailure("Unable to create context")
            return
        }
        
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            assertionFailure("Unable to get context data")
            return
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for x in 0..<fireWidth {
            for y in 0..<fireHeight {
                guard let colorIndex = firePixels[y * fireWidth + x] else {
                    assertionFailure("Offset out of bounds")
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
