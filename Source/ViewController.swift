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
    
    let colorPallete: ColorPalette = ColorPalletes.default
    var firePixels = [Int: Int]()
    var frameBuffer = [Color]()
    var runningTime: Double = 0
    lazy var fireWidth: Int = {
        return Int(fireImageView.bounds.width) / 4
    }()
    lazy var fireHeight: Int = {
        return Int(fireImageView.bounds.height) / 4
    }()
    @IBOutlet weak var fireImageView: UIImageView! {
        didSet {
            fireImageView.layer.magnificationFilter = .nearest
        }
    }
    @IBOutlet weak var fpsLabel: UILabel!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(colorPallete.count == 37)
        
        setupFirePixels()
        writeToFrameBuffer()
        renderFrame()
        
        // 60 fps
        var lastFrameTime = CFAbsoluteTimeGetCurrent()
        let _ = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true, block: { _ in
            let dt = CFAbsoluteTimeGetCurrent() - lastFrameTime
            lastFrameTime += dt
            self.runningTime += min(1, dt)
            self.doFire()
            self.writeToFrameBuffer()
            self.renderFrame()
            self.fpsLabel.text = ("\(Int(1 / dt))")
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
            frameBuffer.append(colorPallete[colorIndex])
        }
    }
    
    func renderFrame() {
        fireImageView.image = UIImage(bitmap: Bitmap(
            width: fireWidth,
            height: fireHeight,
            pixels: frameBuffer
        ))
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
        let rand = Int.random(in: 0...3)
        let dst = src - rand + 1
        firePixels[dst - fireWidth] = pixel - (rand & 1)
    }
}
