//
//  PostCommentTextView.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/8/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import UIKit

class PostCommentTextView: UIView {
    
    override func awakeFromNib() {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    

}
