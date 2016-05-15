//
//  Skill.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/14/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

class Skill {
    
    private var _skillName: String!
    private var _skillEndorse: Int!
    private var _skillKey: String!
    
    private var _skillImage: String!
    
    private var _dogKey: String!
    
    var dogKey: String {
        return _dogKey
    }
    
    var skillName: String {
        return _skillName
    }
    
    var skillEndorse: Int {
        return _skillEndorse
    }
    
    var skillKey: String {
        return _skillKey
    }
    
    var skillImage: String {
        return _skillImage
    }
    
    init(skillKey: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._skillKey = skillKey
        
        if let name = dictionary["skillName"] as? String {
            self._skillName = name
        }
        
        if let endorse = dictionary["endorsements"] as? Int {
            self._skillEndorse = endorse
        }
        
        if let image = dictionary["skillImage"] as? String{
            self._skillImage = image
        }
        
        if let dKey = dictionary["dogKey"] as? String {
            self._dogKey = dKey
        }
    }
}
