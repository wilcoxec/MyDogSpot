//
//  profileImage.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/29/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit

class profileImage: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width / 2
        
        clipsToBounds = true
    }

    override func drawRect(rect: CGRect) {
        layer.cornerRadius = frame.size.width / 2
        
        clipsToBounds = true
    }
}
