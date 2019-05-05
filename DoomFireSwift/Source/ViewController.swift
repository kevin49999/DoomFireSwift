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
    var frameBuffer = [UInt8]()
    var colorPallete: [Color] = [
        Color(r: 7, g: 7, b: 7),
        Color(r: 31, g: 7, b:7),
        Color(r: 47, g:15, b: 7),
        Color(r: 71, g: 15, b: 7),
        Color(r: 87, g: 23, b: 7),
        Color(r: 103, g: 31, b: 7),
        Color(r: 119, g: 31, b: 7),
        Color(r: 143, g: 39, b: 7),
        Color(r: 159, g: 47, b: 7),
        Color(r: 175, g: 63, b: 7),
        Color(r: 191, g: 71, b: 7),
        Color(r: 199, g: 71, b: 7),
        Color(r: 223, g: 79, b: 7),
        Color(r: 223, g: 87, b: 7),
        Color(r: 223, g: 87, b: 7),
        Color(r: 215, g: 95, b: 7),
        Color(r: 215, g: 95, b: 7),
        Color(r: 215, g: 103, b: 15),
        Color(r: 207, g: 111, b: 15),
        Color(r: 207, g: 119, b: 15),
        Color(r: 207, g: 127, b: 15),
        Color(r: 207, g: 135, b: 23),
        Color(r: 199, g: 135, b: 23),
        Color(r: 199, g: 143, b: 23),
        Color(r: 199, g: 151, b: 31),
        Color(r: 191, g: 159, b: 31),
        Color(r: 191, g: 159, b: 31),
        Color(r: 191, g: 167, b: 39),
        Color(r: 191, g: 167, b: 39),
        Color(r: 191, g: 175, b: 47),
        Color(r: 183, g: 175, b: 47),
        Color(r: 183, g: 183, b: 47),
        Color(r: 183, g: 183, b: 55),
        Color(r: 207, g: 207, b: 111),
        Color(r: 223, g: 223, b: 159),
        Color(r: 239, g: 239, b: 199),
        Color(r: 255, g: 255, b: 255)
    ]
    lazy var fireWidth: Int = {
        return Int(fireImageView.bounds.width) / 4
    }()
    lazy var fireHeight: Int = {
        return Int(fireImageView.bounds.height) / 4
    }()
    @IBOutlet weak var fireImageView: FrameImageView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireImageView.layer.magnificationFilter = CALayerContentsFilter(rawValue: kCISamplerFilterNearest)
        fireImageView.delegate = self
        
        setupFirePixels()
        writeToFrameBuffer()
        renderFrame()
        
        // 60 fps
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true, block: { _ in
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
    
    func writeToFrameBuffer() {
        frameBuffer = []
        for i in 0..<fireWidth * fireHeight {
            guard let colorIndex = firePixels[i] else {
                assertionFailure("Index out of bounds")
                continue
            }
            let color = colorPallete[colorIndex]
            frameBuffer.append(contentsOf: [color.a, color.r, color.g, color.b])
        }
    }
    
    func renderFrame() {
        let bitmap = Bitmap(width: fireWidth, height: fireHeight, colorData: frameBuffer)
        fireImageView.image = UIImage(bitmap: bitmap)
    }
    
    // MARK: - Fire Spreading 🔥🚒
    
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
}

// MARK: - FrameImageViewDelegate

extension ViewController: FrameImageViewDelegate {
    func frameDidSet() {
        doFire()
        writeToFrameBuffer()
    }
}
