//
//  MaterialButton.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/5/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    
    override func awakeFromNib() {
        
        //layer.cornerRadius = 0.5 * bounds.size.width
        //layer.masksToBounds = true;
        
        layer.cornerRadius = 5.0
        //layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        //layer.shadowOpacity = 0.8
        //layer.shadowRadius = 5.0
        //layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }

}
