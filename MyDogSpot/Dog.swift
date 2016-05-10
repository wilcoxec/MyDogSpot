//
//  Dog.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/9/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

class Dog {
    
    private var _dogname: String!
    private var _dogImageUrl: String!
    private var _dogKey: String!
    
    private var _userKey: String!
    
    var dogName: String {
        return _dogname
    }
    
    var dogImageUrl: String {
        return _dogImageUrl
    }
    
    var dogKey: String {
        return _dogKey
    }
    
    init(dogname: String, dogImage: String, dogKey: String){
        self._dogname = dogname
        self._dogImageUrl = dogImage
        self._dogKey = dogKey
    }
    
    init(dogKey: String, dictionary: Dictionary<String, AnyObject>){
        self._dogKey = dogKey
        
        if let dName = dictionary["dogname"] as? String {
            self._dogname = dName
        }
        
        if let dImg = dictionary["dogImageUrl"] as? String {
            self._dogImageUrl = dImg
        }
    }
}
