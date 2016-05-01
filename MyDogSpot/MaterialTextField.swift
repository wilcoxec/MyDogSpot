//
//  MaterialTextField.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/5/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        //layer.cornerRadius = 2.0
        //layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: //0.1).CGColor
        //layer.borderWidth = 1.0
        
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.whiteColor().CGColor
        //border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
