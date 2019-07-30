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
    @IBOutlet var birdView : UIImageView! //鸵鸟
    @IBOutlet var timeCountLabel : UILabel!//倒计时
    @IBOutlet var congratulationView : UIImageView!//胜利动画
    var bgPlayer :AVAudioPlayer!//背景音乐
    var clickPlayer :AVAudioPlayer!//点击音效
    var doublePlayer : AVAudioPlayer!//成对儿音效
    var timer : Timer!//定时器
    var doubleCount :Int = 0//匹配对数
    var isGameOver :Bool = false//游戏结束
    var tempImageView :MyImageView!// 临时对象,记录第一次点击的水果
    
    @IBAction func doMusic(sender : UIButton)
    {
        //音乐开关
        if (self.bgPlayer.isPlaying)
        {
            self.bgPlayer.stop()
            sender.setImage(UIImage(named:"soundClose"), for: .normal)
        }
        else
        {
            self.bgPlayer.play()
            sender.setImage(UIImage(named:"soundOpen"), for: .normal)
        }
    }
    //刷新按钮
    @IBAction func doRefresh(sender : UIButton?)
    {
        self.bgPlayer.play()
        
        self.timeCountLabel.text = "60"
        self.doubleCount = 0
        self.birdView.startAnimating()
        self.tempImageView = nil
        if(isGameOver || timer == nil)
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
            self.birdView.startAnimating()
            self.isGameOver = false
        }
        self.loadFruits()
        self.turnAll2Left()
        self.congratulationView.isHidden=true
//        dispatch_after(dispatch_time(DispatchTime.now(),2 * Int64(NSEC_PER_SEC)), DispatchQueue.main, {
//            self.turnAll2Right()
//            })
        
    }
    func loadFruits()
    {
        let tags = randomTags()
        let images = randomImages()
        var index = 0
        for i in 0...9
        {
            //取出一张图片
            let image:UIImage = images[i] as! UIImage
            //获取两个问号
            let my1:MyImageView = self.view.viewWithTag( tags[index] as! Int) as! MyImageView
            index+=1
            let my2:MyImageView = self.view.viewWithTag( tags[index] as! Int) as! MyImageView
            index+=1
            //设置相同的图片和标记
            my1.myImage = image
            my2.myImage = image
            my1.myTag = i
            my2.myTag = i
        }
        
    }
    func randomTags()->NSArray
    {
        let mArr:NSMutableArray =  NSMutableArray()
        while(mArr.count < 20)
        {
            let tag = arc4random()%20+100
            let t = NSNumber(value: tag)
            if(!mArr.contains(t))
            {
                mArr.add(t)
            }
        }
        return mArr
    }
    func randomImages()->NSArray
    {
        let images = NSMutableArray()
        while(images.count < 10)
        {
            let i = arc4random()%18+1
            let image:UIImage = UIImage(named: "fruit\(i).png")!
            if(!images.contains(image))
            {
                images.add(image)
            }
        }
        return images
    }
    func turnAll2Left()
    {
        print("turnAll2Left")
        for i in 100...119
        {
            let myI  = self.view.viewWithTag(i) as! MyImageView
            myI.turn2Left()
        }
    }
    func turnAll2Right()
    {
        print("turnAll2Right")
        for i in 100...119
        {
            let myI  = self.view.viewWithTag(i) as! MyImageView
            myI.turn2Right()
        }
    }
    func loadMusicByName(name : String)->AVAudioPlayer?
    {
        let path = Bundle.main.path(forResource: name,ofType: "mp3")
        let url = NSURL.fileURL(withPath: path!)
        do {
            let player = try AVAudioPlayer(contentsOf: url,fileTypeHint: nil)
            player.prepareToPlay()
            player.volume = 0.9
            return player
        }
        catch{
        
        }
        return nil;
    }
    func prepareMusic()
    {
        self.bgPlayer = loadMusicByName(name: "bg")
        self.clickPlayer = loadMusicByName(name: "click")
        self.doublePlayer = loadMusicByName(name: "double")
        self.bgPlayer.prepareToPlay()
        self.clickPlayer.prepareToPlay()
        self.doublePlayer.prepareToPlay()
        self.bgPlayer.volume = 0.8
    }
    func prepareBird()
    {
        let images :NSMutableArray = NSMutableArray()
        for i in 1...7
        {
            let str = "bird\(i).png"
            let image = UIImage(named: str)
            images.add(image!)
        }
        self.birdView.animationImages = images  as? [UIImage]
        self.birdView.animationDuration = 1.2
    }
    func prepareTimeCount()
    {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
    }
    func prepareWinView()
    {
        let images:NSMutableArray! = NSMutableArray()
        for i in 1...12
        {
            let image = UIImage(named:"congratulation\(i).png")
            images.add(image!)
        }
        
        self.congratulationView.animationImages = images as [AnyObject] as? [UIImage]
        self.congratulationView.animationDuration = 3
        self.congratulationView.startAnimating()
        self.view.addSubview(self.congratulationView)
    }
    @objc func timeCount()
    {
        var timeCount :Int = self.timeCountLabel.text!.count
        if(timeCount<=0)
        {
            self.timer.invalidate()
            self.gameOver()
        }
        else
        {
            timeCount-=1
        }
        self.timeCountLabel.text = String(timeCount)
    }
    func gameOver()
    {
        self.isGameOver = true
        self.birdView.stopAnimating()
        self.timer.invalidate()
//        var alert : UIAlertController! = UIAlertController(title: " Oh! No~````", message: "竟然失败了~`!", preferredStyle: .Alert)
//        var alertAction :UIAlertAction = UIAlertAction(title:"再来一次",
//            style:.Default,{
//                (UIAlertAction)->Void in
//                self.doRefresh(nil)
//            })
//        alert.addAction(alertAction)
//        self.presentViewController(alert,animated: true,nil)
        
    }
    func gameWin()
    {
        self.isGameOver = true
        self.birdView.stopAnimating()
        self.congratulationView.isHidden = false
        self.timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareMusic()
        self.prepareTimeCount()
        self.prepareBird()
        self.prepareWinView()
        self.doRefresh(sender: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view?.isKind(of: MyImageView.self) ?? false {
            let currentTouchView = touch?.view as! MyImageView
            currentTouchView.turn2Left()
            self.clickPlayer.play()
            if (self.tempImageView == nil)
            {
                self.tempImageView = currentTouchView
            }
            else
            {
                if(currentTouchView.myTag == self.tempImageView.myTag)
                {
                    self.doublePlayer.play()
                    self.tempImageView = nil
                    self.doubleCount+=1
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
