//
//  FrameImageView.swift
//  DoomFireSwift
//
//  Created by Kevin Johnson on 5/4/19.
//  Copyright © 2019 Kevin Johnson. All rights reserved.
//

import UIKit

protocol FrameImageViewDelegate: class {
    func frameDidSet()
}

class FrameImageView: UIImageView {
    
    weak var delegate: FrameImageViewDelegate?
    
    override var image: UIImage? {
        didSet {
            delegate?.frameDidSet()
        }
    }
}
