//
//  Comment.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/7/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    private var _commentText: String!
    private var _userImageUrl: String!
    private var _userName: String!
    private var _userKey: String!
    
    //Will add later
    private var _commentDate: Int!
    private var _likes: Int!
    
    
    private var _commentKey: String!
    //private var _commentKey: String!
    private var _commentRef: Firebase!
    
    
    
    var commentText: String {
        return _commentText
    }
    
    var username: String {
        return _userName
    }
    
    var userImage: String! {
        return _userImageUrl
    }
    
    var commentKey: String {
        return _commentKey
    }
    
    var userKey: String {
        return _userKey
    }
    
    var likes: Int {
        return _likes
    }
    
    
    init(description: String, imageUrl: String?, username: String){
        self._commentText = description
        self._userImageUrl = imageUrl
        self._userName = username
    }
    
    init(commentKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._commentKey = commentKey
        
        
        if let desc = dictionary["commentText"] as? String {
            self._commentText = desc
        }
        
        if let userUrl = dictionary["userImageUrl"] as? String {
            self._userImageUrl = userUrl
        }
        
        if let userName = dictionary["username"] as? String {
            self._userName = userName
        }
        
        if let uKey = dictionary["userID"] as? String {
            self._userKey = uKey;
        }
        
        
        
        //self._commentRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey).childByAppendingPath("Comments")
        
    }
}
