//
//  Ball.swift
//  BrikOut
//
//  Created by VietHung on 6/3/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class Ball: UIImageView {
    
    var ballRadius = CGFloat()
    var ballDir = String()
    
    init()
    {
        ballDir = "upleft"
        super.init(frame: CGRectZero)
    }
    
    override init(image: UIImage?){
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
