//
//  Paddle.swift
//  BrikOut
//
//  Created by VietHung on 6/16/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class Paddle: UIImageView, UIGestureRecognizerDelegate  {
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.setup()
    }
    func setup(){
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("onPan:"))
        self.addGestureRecognizer(panGesture)
        
    }

    func onPan(panGesture: UIPanGestureRecognizer){
        if(panGesture.state == .Began || panGesture.state == .Changed){
            let point = panGesture.locationInView(self.superview)
            self.center = CGPointMake(point.x, self.center.y)
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
