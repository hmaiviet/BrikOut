//
//  ViewController.swift
//  BrikOut
//
//  Created by VietHung on 6/3/16.
//  Copyright © 2016 VietHung. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var ball2 = Ball()
    var brickde_stroyed = AVAudioPlayer()
    var brickTouch = AVAudioPlayer()
    var ball = Ball()
    var special = UIImageView()
    var ballRadius = CGFloat()
    var margin: CGFloat = 50
    var n = 5
    var vx: CGFloat = 1
    var vy: CGFloat = 2
    var speed = 0.005
    var levelnumber = 1
    var time = NSTimer()
    var time2 = NSTimer()
    var NextLevelAlert = UIAlertController(title: "Alert", message: "Are You Ready For The Next Level?", preferredStyle: UIAlertControllerStyle.Alert)
    var ballArray: [Ball] = []
    var music = AVAudioPlayer()
    var BrickArray: [Brick] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBall()
        DrawBricks()
        time = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("bounceBall"), userInfo: nil, repeats: true)
//        brickde_stroyed = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("crash", ofType: ".mp3")!))
        brickTouch = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dink", ofType: ".mp3")!))
        music = try! AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("35-lost-woods", ofType: ".mp3")!))
        music.play()
        music.numberOfLoops = -1
        NextLevelAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.DrawBricks()
            self.addBall()
            self.time = NSTimer.scheduledTimerWithTimeInterval(self.speed, target: self, selector: Selector("bounceBall"), userInfo: nil, repeats: true)
        }))
    
    }
    
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var paddle: Paddle!
    
    func addBall(){
        ball = Ball(image: UIImage(named: "rsz_ball.png"))
        ball.ballDir = "upleft"
        ballArray.append(ball)
        ballRadius = 8
        ball.center = CGPointMake(paddle.center.x, paddle.center.y)
        self.view.addSubview(ball)
    }
    
    
    func addBall2(){
        if  (ballArray.contains(ball2))
        {
            return
        }
        ball2 = Ball(image: UIImage(named: "rsz_ball.png"))
        ball2.ballDir = "upleft"
        ballArray.append(ball2)
        ballRadius = 8
        ball2.center = CGPointMake(paddle.center.x, paddle.center.y)
        self.view.addSubview(ball2)
    }
    
    func addSpecial(brick: Brick){
        special = UIImageView(image: UIImage(named: "ballx2.png"))
        special.center = CGPointMake(brick.center.x, brick.center.y)
        self.view.addSubview(special)
    }
    
    func moveSpecial(){
        special.center = CGPointMake(special.center.x, special.center.y + 1)
        if(special.center.y >= self.view.bounds.size.height){
            special.removeFromSuperview()
        }
        if(CGRectIntersectsRect(special.frame, paddle.frame)){
            special.removeFromSuperview()
            addBall2()
        }
    }
    
    
    func bounceBall(){
        if BrickArray.count == 0 {
            for ball in ballArray{
                ball.removeFromSuperview()
                special.removeFromSuperview()
                ballArray.removeAtIndex(ballArray.indexOf(ball)!)
            }
           
            time.invalidate()
            presentViewController(NextLevelAlert, animated: true, completion: nil)
            if(speed > 0.001){
                speed -= 0.001
                levelnumber++
                level.text = String(levelnumber)
            }
        }
        

        
        for ball in ballArray{
            
        if(ball.ballDir == "downright"){
            ball.center = CGPointMake(ball.center.x + vx, ball.center.y + vy)
        }
        else if(ball.ballDir == "downleft"){
            ball.center = CGPointMake(ball.center.x - vx, ball.center.y + vy)
        }
        else if(ball.ballDir == "upleft"){
            ball.center = CGPointMake(ball.center.x - vx, ball.center.y - vy)
        }
        else if(ball.ballDir == "upright"){
            ball.center = CGPointMake(ball.center.x + vx, ball.center.y - vy)
        }
        
        
        
        
        for brick in BrickArray{
            let leftRect = CGRectMake(brick.frame.origin.x, brick.frame.origin.y + 2, 1, brick.bounds.size.height - 4)
            let rightRect = CGRectMake(brick.frame.origin.x + brick.bounds.size.width - 1, brick.frame.origin.y + 2, 1, brick.bounds.size.height - 4)
            if (CGRectIntersectsRect(leftRect, ball.frame))
            {
                brickTouch.play()
                brick.BrickState = brick.BrickState - 1
                if(brick.BrickState == 0){
                    if(brick.special == 1){
                        addSpecial(brick)
                        time2 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("moveSpecial"), userInfo: nil, repeats: true)
                    }
                    BrickArray.removeAtIndex(BrickArray.indexOf(brick)!)
                }
                switch(ball.ballDir){
                case "upright": ball.ballDir = "upleft"; break
                case "downright": ball.ballDir = "downleft"; break
                default: break
                }
            }
            else if (CGRectIntersectsRect(ball.frame, rightRect))
            {
                brickTouch.play()
                brick.BrickState = brick.BrickState - 1
                if(brick.BrickState == 0){
                    BrickArray.removeAtIndex(BrickArray.indexOf(brick)!)
                    if(brick.special == 1){
                        addSpecial(brick)
                        time2 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("moveSpecial"), userInfo: nil, repeats: true)
                    }
                }
                switch(ball.ballDir){
                case "upleft": ball.ballDir = "upright"; break
                case "downleft": ball.ballDir = "downright"; break
                default: break
                }
            }
            else if(CGRectIntersectsRect(ball.frame, brick.frame)){
                brickTouch.play()
                brick.BrickState = brick.BrickState - 1
                if(brick.BrickState == 0){
                    if(brick.special == 1){
                        addSpecial(brick)
                        time2 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("moveSpecial"), userInfo: nil, repeats: true)
                    }
                    BrickArray.removeAtIndex(BrickArray.indexOf(brick)!)
                }


                    switch(ball.ballDir){
                        case "upleft": ball.ballDir = "downleft"; break
                        case "upright": ball.ballDir = "downright"; break
                        case "downright": ball.ballDir = "upright"; break
                        case "downleft": ball.ballDir = "upleft"; break
                        default: break
                    }
            }
        }
        
        
        if(CGRectIntersectsRect(ball.frame, paddle.frame)){
            let leftRect = CGRectMake(paddle.frame.origin.x, paddle.frame.origin.y + 2, 1, paddle.bounds.size.height - 4)
            let rightRect = CGRectMake(paddle.frame.origin.x + paddle.bounds.size.width - 1, paddle.frame.origin.y + 2, 1, paddle.bounds.size.height - 4)
            if (CGRectIntersectsRect(leftRect, ball.frame))
            {
                switch(ball.ballDir){
                case "upright": ball.ballDir = "upleft"; break
                case "downright": ball.ballDir = "downleft"; break
                default: break
                }
            }
            else if (CGRectIntersectsRect(ball.frame, rightRect))
            {
                switch(ball.ballDir){
                case "upleft": ball.ballDir = "upright"; break
                case "downleft": ball.ballDir = "downright"; break
                default: break
                }
            }

            if(ball.ballDir == "downright"){
                ball.ballDir = "upright"
            }
            if(ball.ballDir == "downleft"){
                ball.ballDir = "upleft"
            }
        }
        
        if(ball.center.x >= self.view.bounds.size.width - ballRadius && ball.ballDir == "downright"){
            ball.ballDir = "downleft"
        }
        if(ball.center.x >= self.view.bounds.size.width - ballRadius && ball.ballDir == "upright"){
            ball.ballDir = "upleft"
        }
        if(ball.center.x <= ballRadius && ball.ballDir == "downleft"){
            ball.ballDir = "downright"
        }
        if(ball.center.x <= ballRadius && ball.ballDir == "upleft"){
            ball.ballDir = "upright"
        }
        if(ball.center.y >= self.view.bounds.size.height - ballRadius){
            ball.removeFromSuperview()
            paddle.userInteractionEnabled = false
            let label = UILabel(frame: CGRectMake(0, 0, 128, 128))
            label.center = CGPointMake(view.self.bounds.size.width * 0.5, view.self.bounds.size.width * 0.5)
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor(patternImage: UIImage(named: "gameover.png")!)
            label.font = UIFont(name: label.font.fontName, size: 20)
            label.text = ""
            self.view.addSubview(label)
            ballArray.removeAtIndex(ballArray.indexOf(ball)!)
        }
        if(ball.center.y <= ballRadius && ball.ballDir == "upleft"){
            ball.ballDir = "downleft"
        }
        if(ball.center.y <= ballRadius && ball.ballDir == "upright"){
            ball.ballDir = "downright"
        }
        }
    }

    
    
    func DrawBricks(){
        for indexRow in 0..<n{
            for indexCol in 0..<n{
                let image = UIImage(named: "rsz_brick.jpg")
                let brick = Brick(image: image)
                brick.BrickState = Int(arc4random_uniform(4)+1)
                
                brick.center = CGPointMake(margin + CGFloat(indexRow)*BrickSpace() , margin + CGFloat(indexCol)*50)
//                brick.center = CGPointMake(view.bounds.size.width/2, 200)
                
                
                brick.tag = indexRow + 100
                self.view.addSubview(brick)
                BrickArray.append(brick)
            }
        }
        let randomSpec = arc4random_uniform(25)
        BrickArray[Int(randomSpec)].special = 1
    }

    func BrickSpace() -> CGFloat{
        let space = (self.view.bounds.size.width - 2*margin)/CGFloat(n-1)
        return space
    }
    

}

