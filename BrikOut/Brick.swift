//
//  Brick.swift
//  BrikOut
//
//  Created by VietHung on 6/3/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class Brick: UIImageView {
    var BrickState = 0{
        didSet{
            switch(BrickState){
            case 4: self.image = UIImage(named: "brick-red.png")
            case 3: self.image = UIImage(named: "brick-blue.png")
            case 2: self.image = UIImage(named: "brick-green.png")
            case 1: self.image = UIImage(named: "brick-yellow.png")
            case 0: self.removeFromSuperview()
            default: break
            }
        }
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    override init(frame: CGRect){
        BrickState = 0
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
}
