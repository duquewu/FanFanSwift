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

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder :aDecoder)!
        self.isUserInteractionEnabled = true
    }
    func turn2Left()
    {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: {
            
            self.image = self.myImage
            }, completion:
            { (finished) -> Void in
                
                //水果状态时,不可点击
                self.isUserInteractionEnabled = false
            })
    }
    func turn2Right()
    {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: {
                self.image = UIImage(named:"contrary.png")
            }, completion:
            { (finished) -> Void in
                //问号状态时可点击
                self.isUserInteractionEnabled = true
            })
    }
}
