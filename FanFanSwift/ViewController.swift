//
//  ViewController.swift
//  FanFanSwift
//
//  Created by cora1n on 14-6-3.
//  Copyright (c) 2014年 devwu. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    @IBOutlet var birdView : UIImageView
    @IBOutlet var timeCountLabel : UILabel
    @IBOutlet var congratulationView : UIImageView
    var bgPlayer :AVAudioPlayer!
    var clickPlayer :AVAudioPlayer!
    var doublePlayer : AVAudioPlayer!
    var timer : NSTimer!
    var doubleCount :Int = 0
    var isGameOver :Bool = false
    var tempImageView :MyImageView!
    
    @IBAction func doMusic(sender : UIButton)
    {
        if (self.bgPlayer.playing)
        {
            self.bgPlayer.stop()
            sender.setImage(UIImage(named:"soundClose"), forState: .Normal)
        }
        else
        {
            self.bgPlayer.play()
            sender.setImage(UIImage(named:"soundOpen"), forState: .Normal)
        }
    }
    
    @IBAction func doRefresh(sender : UIButton?)
    {
        self.bgPlayer.play()
//        self.timeCountLabel.text = "60"
        self.doubleCount = 0
        self.birdView.startAnimating()
        self.tempImageView = nil
        if(isGameOver || timer == nil)
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeCount", userInfo: nil, repeats: true)
            self.birdView.startAnimating()
            self.isGameOver = false
        }
        self.loadFruits()
        self.turnAll2Left()
        self.congratulationView.hidden=true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,2 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.turnAll2Right()
            })
    }
    func loadFruits()
    {
        var tags = randomTags()
        var images = randomImages()
        var index = 0
        for (var i = 0 ;i<10;i++)
        {
            //取出一张图片
            var image:UIImage = images[i] as UIImage
            //获取两个问号
            var my1:MyImageView = self.view.viewWithTag( tags[index] as Int) as MyImageView
            index++
            var my2:MyImageView = self.view.viewWithTag( tags[index] as Int) as MyImageView
            index++
            //设置相同的图片和标记
            my1.myImage = image
            my2.myImage = image
            my1.myTag = i
            my2.myTag = i
        }
        
    }
    func randomTags()->NSArray
    {
        var mArr:NSMutableArray =  NSMutableArray()
        var count = 0
        while(mArr.count < 20)
        {
            var tag = arc4random()%20+100
            var t = NSNumber(unsignedInt: tag)
            if(!mArr.containsObject(t))
            {
                mArr.addObject(t)
            }
        }
        return mArr
    }
    func randomImages()->NSArray
    {
        var images = NSMutableArray()
        while(images.count < 10)
        {
            var i = arc4random()%18+1
            var image:UIImage = UIImage(named: "fruit\(i).png")
            if(!images.containsObject(image))
            {
                images.addObject(image)
            }
        }
        return images
    }
    func turnAll2Left()
    {
        println("turnAll2Left")
        for (var i = 100;i<120;i++)
        {
            var myI  = self.view.viewWithTag(i) as MyImageView
            myI.turn2Left()
        }
    }
    func turnAll2Right()
    {
        println("turnAll2Right")
        for (var i = 100;i<120;i++)
        {
            var myI  = self.view.viewWithTag(i) as MyImageView
            myI.turn2Right()
        }
    }
    func loadMusicByName(name : String)->AVAudioPlayer
    {
        let path = NSBundle.mainBundle().pathForResource(name,ofType: "mp3")
        let url = NSURL.fileURLWithPath(path)
        var player = AVAudioPlayer(contentsOfURL: url,error: nil)
        player.prepareToPlay()
        player.volume = 0.9
        return player
    }
    func prepareMusic()
    {
        self.bgPlayer = loadMusicByName("bg")
        self.clickPlayer = loadMusicByName("click")
        self.doublePlayer = loadMusicByName("double")
        self.bgPlayer.prepareToPlay()
        self.clickPlayer.prepareToPlay()
        self.doublePlayer.prepareToPlay()
        self.bgPlayer.volume = 0.8
    }
    func prepareBird()
    {
        var images :NSMutableArray = NSMutableArray()
        for(var i = 1;i<=7;i++)
        {
            var str = "bird\(i).png"
            var image = UIImage(named: str)
            images.addObject(image)
        }
        self.birdView.animationImages = images
        self.birdView.animationDuration = 1.2
    }
    func prepareTimeCount()
    {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeCount", userInfo: nil, repeats: true)
    }
    func prepareWinView()
    {
        var images:NSMutableArray! = NSMutableArray()
        for (var i = 1 ; i <= 12 ;i++)
        {
            var image = UIImage(named:"congratulation\(i).png")
            images.addObject(image)
        }

        self.congratulationView.animationImages = images
        self.congratulationView.animationDuration = 3
        self.congratulationView.startAnimating()
        self.view.addSubview(self.congratulationView)
    }
    func timeCount()
    {
        var timeCount :Int = self.timeCountLabel.text.toInt()!
        if(timeCount<=0)
        {
            self.timer.invalidate()
            self.gameOver()
        }
        else
        {
            timeCount--
        }
        self.timeCountLabel.text = String(timeCount)
    }
    func gameOver()
    {
        self.birdView.stopAnimating()
        self.timer.invalidate()
        var alert : UIAlertController! = UIAlertController(title: "title", message: "message", preferredStyle: .Alert)
        var alertAction :UIAlertAction = UIAlertAction(title:"OK",
            style:.Default,{
            (UIAlertAction)->Void in
                println("test")
            })
        self.presentViewController(alert,animated: true,nil)
        
    }
    func gameWin()
    {
        self.birdView.stopAnimating()
        self.congratulationView.hidden = false
        self.timer.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareMusic()
        self.prepareTimeCount()
        self.prepareBird()
        self.prepareWinView()
        self.doRefresh(nil)
    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        var touch :UITouch =  touches.anyObject() as UITouch
        if(touch.view.isKindOfClass(MyImageView.self))
        {
            var currentTouchView = touch.view as MyImageView
            currentTouchView.turn2Left()
            self.clickPlayer.play()
            if (!self.tempImageView)
            {
                self.tempImageView = currentTouchView
            }
            else
            {
                if(currentTouchView.myTag == tempImageView.myTag)
                {
                    self.doublePlayer.play()
                    self.tempImageView = nil
                    self.doubleCount++
                    if(self.doubleCount == 10)
                    {
                        self.gameWin()
                    }
                }
                else
                {
                    self.tempImageView.turn2Right()
                    self.tempImageView = currentTouchView
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}