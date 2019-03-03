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
    
    let FIRE_WIDTH = 40
    let FIRE_HEIGHT = 40 // magic..
    
    @IBOutlet weak private var fireView: UIView!
    
    var pixelViews = [Int: UIView]()
    var palette = [Int: [String: Int]]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePallete()
        setup()
        drawView()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.doFire()
            self.drawView()
        })
    }
    
    // MARK: - Setup
    
    func populatePallete() {
        for i in 0..<rgbs.count / 3 {
            palette[i] = ["r" : rgbs[i * 3 + 0],
                          "g" : rgbs[i * 3 + 1],
                          "b" : rgbs[i * 3 + 2]]
        }
    }
    
    func setup() {
        /// "Set whole screen to 0" (color: 0x07,0x07,0x07)
        for i in 0..<FIRE_WIDTH * FIRE_HEIGHT {
            firePixels[i] = 0
        }
        
        // "Set bottom line to 37 (color white: 0xFF,0xFF,0xFF)
        for i in 0..<FIRE_WIDTH {
            firePixels[(FIRE_HEIGHT - 1)*FIRE_WIDTH + i] = 36
        }
    }
    
    // MARK: - 🔥🚒🔥🚒
    
    func doFire() {
        for x in 0..<FIRE_WIDTH {
            for y in 0..<FIRE_HEIGHT {
                spreadFire(src: y * FIRE_WIDTH + x)
            }
        }
    }
    
    func spreadFire(src: Int) {
        guard let pixel = firePixels[src] else {
            assertionFailure("Missing pixel at: \(src)")
            return
        }
        
        if pixel == 0 {
            firePixels[src - FIRE_WIDTH] = 0
            return
        }
        
        guard let srcPixel = firePixels[src] else {
            assertionFailure("Missing src pixel: \(src)")
            return
        }
        
        firePixels[src - FIRE_WIDTH] = srcPixel - 1
    }
    
    // MARK: - Draw View
    
    func drawView() {
        for x in 0..<FIRE_WIDTH {
            for y in 0..<FIRE_HEIGHT {
                guard let colorIndex = firePixels[y * FIRE_WIDTH + x] else {
                    break
                }
                var pixel = palette[colorIndex]
                
                let r = Double(pixel!["r"]!)
                let g = Double(pixel!["g"]!)
                let b = Double(pixel!["b"]!)
                let color = UIColor(red: CGFloat(r / 255), green: CGFloat(g / 255), blue: CGFloat(b / 255), alpha: 1.0)
                
                ////
                /*"The fastest App Store approved way to do CPU-only 2D graphics is to create a CGImage backed by a buffer using CGDataProviderCreateDirect and assign that to a CALayer's contents property.
                 
                 For best results use the kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little or kCGImageAlphaNone | kCGBitmapByteOrder32Little bitmap types and double buffer so that the display is never in an inconsistent state.
                 
                 edit: this should be faster than drawing to an OpenGL texture in theory, but as always, profile to be sure.
                 
                 edit2: CADisplayLink is a useful class no matter which compositing method you use."
                 */

                /// too slow
//                let dotPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: 1, height: 1))
//                let layer = CAShapeLayer()
//                layer.path = dotPath.cgPath
//                layer.strokeColor = color.cgColor
//                fireView.layer.addSublayer(layer)
                
                /// : - )
                print(y * FIRE_WIDTH + x)
                if let pixelView = pixelViews[y * FIRE_WIDTH + x] {
                    pixelView.backgroundColor = color
                } else {
                    let pixelView = UIView(frame: CGRect(x: x, y: y, width: 1, height: 1))
                    pixelView.backgroundColor = color
                    fireView.addSubview(pixelView)
                    pixelViews[y * FIRE_WIDTH + x] = pixelView
                }
            }
        }
    }
}

