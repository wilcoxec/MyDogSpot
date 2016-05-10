//
//  SignUpTextField.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/8/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//


import UIKit

class SignUpTextField: UITextField {
    
    override func awakeFromNib() {
        let border = CALayer()
        let width = CGFloat(1.0)
        
        let color = UIColor(red: 22.0/255.0, green: 28.0/255.0, blue: 38.0/255.0, alpha: 1)
        
        border.borderColor = color.CGColor
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