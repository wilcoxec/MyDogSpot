//
//  Endorsement.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/14/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

class Endorsement {
    private var _eKey: String!
    
    private var _userName: String!
    private var _userImage: String!
    private var _userKey: String!
    
    
    var eKey: String {
        return _eKey
    }
    
    var userName: String {
        return _userName
    }
    
    var userKey: String {
        return _userKey
    }
    
    var userImage: String {
        return _userImage
    }
    
    init(endorsementKey: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._eKey = endorsementKey
        
        if let name = dictionary["username"] as? String {
            self._userName = name
        }
        
        if let image = dictionary["userImageUrl"] as? String{
            self._userImage = image
        }
        
        if let uKey = dictionary["userID"] as? String{
            self._userKey = uKey
        }
    }
    
}
