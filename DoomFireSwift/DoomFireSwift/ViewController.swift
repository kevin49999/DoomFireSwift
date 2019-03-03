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
    
    let fireWidth = 40
    let fireHeight = 40
    let multiplier = 8 // fireWidth * multipler = fireView.bounds.width
    
    @IBOutlet weak private var fireView: UIView!
    
    var pixelViews = [Int: UIView]()
    var colorPalette = [Int: [String: Int]]()
    var firePixels = [Int: Int]()
    
    var rgbs: [Int] = [
        0x07,0x07,0x07,
        0x1F,0x07,0x07,
        0x2F,0x0F,0x07,
        0x47,0x0F,0x07,
        0x57,0x17,0x07,
        0x67,0x1F,0x07,
        0x77,0x1F,0x07,
        0x8F,0x27,0x07,
        0x9F,0x2F,0x07,
        0xAF,0x3F,0x07,
        0xBF,0x47,0x07,
        0xC7,0x47,0x07,
        0xDF,0x4F,0x07,
        0xDF,0x57,0x07,
        0xDF,0x57,0x07,
        0xD7,0x5F,0x07,
        0xD7,0x5F,0x07,
        0xD7,0x67,0x0F,
        0xCF,0x6F,0x0F,
        0xCF,0x77,0x0F,
        0xCF,0x7F,0x0F,
        0xCF,0x87,0x17,
        0xC7,0x87,0x17,
        0xC7,0x8F,0x17,
        0xC7,0x97,0x1F,
        0xBF,0x9F,0x1F,
        0xBF,0x9F,0x1F,
        0xBF,0xA7,0x27,
        0xBF,0xA7,0x27,
        0xBF,0xAF,0x2F,
        0xB7,0xAF,0x2F,
        0xB7,0xB7,0x2F,
        0xB7,0xB7,0x37,
        0xCF,0xCF,0x6F,
        0xDF,0xDF,0x9F,
        0xEF,0xEF,0xC7,
        0xFF,0xFF,0xFF
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateColorPallete()
        setupFirePixels()
        drawScreen()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
            self.doFire()
            self.drawScreen()
        })
    }
    
    // MARK: - Setup
    
    func populateColorPallete() {
        for i in 0..<rgbs.count / 3 {
            colorPalette[i] = ["r" : rgbs[i * 3 + 0],
                               "g" : rgbs[i * 3 + 1],
                               "b" : rgbs[i * 3 + 2]]
        }
    }
    
    func setupFirePixels() {
        /// "Set whole screen to 0 (color: 0x07,0x07,0x07)"
        for i in 0..<fireWidth * fireHeight {
            firePixels[i] = 0
        }
        
        // "Set bottom line to 37 (color white: 0xFF,0xFF,0xFF)"
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
        for x in 0..<fireWidth {
            for y in 0..<fireHeight {
                guard let colorIndex = firePixels[y * fireWidth + x],
                    let pixel = colorPalette[colorIndex],
                    let r = pixel["r"],
                    let g = pixel["g"],
                    let b = pixel["b"] else {
                        break
                }
                
                let color = UIColor(red: CGFloat(Double(r) / 255),
                                    green: CGFloat(Double(g) / 255),
                                    blue: CGFloat(Double(b) / 255),
                                    alpha: 1.0)
                
                ///https://stackoverflow.com/questions/2395650/fastest-way-to-draw-a-screen-buffer-on-the-iphone
                /*"The fastest App Store approved way to do CPU-only 2D graphics is to create a CGImage backed by a buffer using CGDataProviderCreateDirect and assign that to a CALayer's contents property.
                 
                 For best results use the kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little or kCGImageAlphaNone | kCGBitmapByteOrder32Little bitmap types and double buffer so that the display is never in an inconsistent state.
                 
                 edit: this should be faster than drawing to an OpenGL texture in theory, but as always, profile to be sure.
                 
                 edit2: CADisplayLink is a useful class no matter which compositing method you use."
                 */
                
                /// too slow for full screen,, too slow to in general need to do above method
                if let pixelView = pixelViews[y * fireWidth + x] {
                    pixelView.backgroundColor = color
                } else {
                    let pixelView = UIView(frame: CGRect(x: x * multiplier,
                                                         y: y * multiplier,
                                                         width: multiplier,
                                                         height: multiplier))
                    pixelView.backgroundColor = color
                    fireView.addSubview(pixelView)
                    pixelViews[y * fireWidth + x] = pixelView
                }
            }
        }
    }
}
