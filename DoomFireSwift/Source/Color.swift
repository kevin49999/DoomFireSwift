//
//  Color.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 5/4/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import Foundation

struct Color {
    let a: UInt8
    let r: UInt8
    let g: UInt8
    let b: UInt8
    
    init(a: UInt8 = 0, r: UInt8, g: UInt8, b: UInt8) {
        self.a = a
        self.r = r
        self.g = g
        self.b = b
    }
}
