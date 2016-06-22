//
//  CollectionViewCellWithLabel.swift
//  BrainFuck
//
//  Created by Thomas Mac on 16/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class CollectionViewCellWithLabel: UICollectionViewCell {
 
    internal let titleLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        self.titleLabel.shadowOffset = CGSizeMake(0, 1)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.titleLabel)
        
        self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        //self.layer.shadowOffset = CGSizeMake(0, 1)
        //self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        //self.layer.shadowRadius = 8.0
        //self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
    }
    
    
    
}
