//
//  MyImageView.swift
//  FanFanSwift
//
//  Created by cora1n on 14-6-5.
//  Copyright (c) 2014年 devwu. All rights reserved.
//


import UIKit

class MyImageView: UIImageView {
    var myImage : UIImage?
    var myTag : NSInteger?

    required init(coder aDecoder: NSCoder!)
    {
        super.init(coder :aDecoder)
        self.userInteractionEnabled = true
    }
    func turn2Left()
    {
        UIView.transitionWithView(self, duration: 0.5, options: .TransitionFlipFromRight, animations: {
            
            self.image = self.myImage
            }, completion:
            { (Bool finished) -> Void in
                
                //水果状态时,不可点击
                self.userInteractionEnabled = false
            })
    }
    func turn2Right()
    {
        UIView.transitionWithView(self, duration: 0.5, options: .TransitionFlipFromRight, animations: {
                self.image = UIImage(named:"contrary.png")
            }, completion:
            { (Bool finished) -> Void in
                //问号状态时可点击
                self.userInteractionEnabled = true
            })
    }
}
