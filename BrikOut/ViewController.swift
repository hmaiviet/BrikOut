//
//  ViewController.swift
//  BrikOut
//
//  Created by VietHung on 6/3/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ball = UIImageView()
    var ballRadius = CGFloat()
    var flag = "downleft"
    var margin: CGFloat = 50
    var n = 5
    
    var BrickArray: [Brick] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBall()
        DrawBricks()
        let time = NSTimer.scheduledTimerWithTimeInterval(0.005, target: self, selector: Selector("bounceBall"), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var paddle: Paddle!
    
    func addBall(){
//        let mainViewSize = self.view.bounds.size
        ball = Ball(image: UIImage(named: "rsz_ball.png"))
        ballRadius = 8
        ball.center = CGPointMake(paddle.center.x, paddle.center.y)
        self.view.addSubview(ball)
    }
    
    func bounceBall(){
        if(flag == "downright"){
            ball.center = CGPointMake(ball.center.x+1, ball.center.y+1)
        }
        else if(flag == "downleft"){
            ball.center = CGPointMake(ball.center.x-1, ball.center.y+1)
        }
        else if(flag == "upleft"){
            ball.center = CGPointMake(ball.center.x-1, ball.center.y-1)
        }
        else if(flag == "upright"){
            ball.center = CGPointMake(ball.center.x+1, ball.center.y-1)
        }
        
        
        
        
        for brick in BrickArray{
            if(CGRectIntersectsRect(ball.frame, brick.frame)){
                brick.BrickState = brick.BrickState - 1
                if(brick.BrickState == 0){
                    BrickArray.removeAtIndex(BrickArray.indexOf(brick)!)
                }
                    switch(flag){
                        case "upleft": flag = "downleft"; break
                        case "upright": flag = "downright"; break
                        case "downright": flag = "upright"; break
                        case "downleft": flag = "upleft"; break
                        default: break
                    }
                
            }
        }
        
        
        
        
        
        if(CGRectIntersectsRect(ball.frame, paddle.frame)){
            if(flag == "downright"){
                flag = "upright"
            }
            if(flag == "downleft"){
                flag = "upleft"
            }
        }
//        print(flag)
        
        if(ball.center.x >= self.view.bounds.size.width - ballRadius && flag == "downright"){
            flag = "downleft"
        }
        if(ball.center.x >= self.view.bounds.size.width - ballRadius && flag == "upright"){
            flag = "upleft"
        }
        if(ball.center.x <= ballRadius && flag == "downleft"){
            flag = "downright"
        }
        if(ball.center.x <= ballRadius && flag == "upleft"){
            flag = "upright"
        }
        if(ball.center.y >= self.view.bounds.size.height - ballRadius && flag == "downleft"){
            flag = "upleft"
        }
        if(ball.center.y >= self.view.bounds.size.height - ballRadius && flag == "downright"){
            flag = "upright"
        }
        if(ball.center.y <= ballRadius && flag == "upleft"){
            flag = "downleft"
        }
        if(ball.center.y <= ballRadius && flag == "upright"){
            flag = "downright"
        }
    }

    
    func DrawBricks(){
        for indexRow in 0..<n{
            for indexCol in 0..<n{
                let image = UIImage(named: "rsz_brick.jpg")
                let brick = Brick(image: image)
                brick.BrickState = Int(arc4random_uniform(4)+1)
                
                brick.center = CGPointMake(margin + CGFloat(indexRow)*BrickSpace() , margin + CGFloat(indexCol)*50)
                brick.tag = indexRow + 100
                self.view.addSubview(brick)
                BrickArray.append(brick)
            }
        }
        
    }

    func BrickSpace() -> CGFloat{
        let space = (self.view.bounds.size.width - 2*margin)/CGFloat(n-1)
        return space
    }
    

}

