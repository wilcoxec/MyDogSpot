//
//  CreateUser.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/28/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _username: String!
    private var _userLocation: String!
    private var _userImageUrl: String!
    
    private var _userKey: String!

    
    
    var userName: String {
        return _username
    }
    
    var userLocation: String {
        return _userLocation
    }
    
    var userImageUrl: String {
        return _userImageUrl
    }
    
    
    var userKey: String {
        return _userKey
    }
    
    init(username: String, userLocation: String, userImageUrl: String, dogname: String, dogImageUrl: String) {
        self._username = username
        self._userLocation = userLocation
        self._userImageUrl = userImageUrl
    }
    
    init(userKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._userKey = userKey
        
        
        if let uName = dictionary["username"] as? String {
            self._username = uName
        }
        
        if let uImgURl = dictionary["userImage"] as? String {
            self._userImageUrl = uImgURl
        }
        
        if let uLocation = dictionary["location"] as? String {
            self._userLocation = uLocation
        }
        
        
        //self._userRef = DataService.ds.REF_USERS.childByAppendingPath(self._userKey)
        
    }
    
    func addUserInfo() {
//        _userRef.childByAppendingPath("username").setValue(_username)
//        _userRef.childByAppendingPath("location").setValue(_userLocation)
//        _userRef.childByAppendingPath("userImageUrl").setValue(_username)
//        _userRef.childByAppendingPath("dname").setValue(_dogname)
//        _userRef.childByAppendingPath("dogImageUrl").setValue(_dogImageUrl)

    }
    


    
    
    
    
    
    
    
    
    
}
