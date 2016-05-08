//
//  Post.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/26/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    
    private var _username: String!
    private var _userImage: String!
    private var _userKey: String!
    
    private var _postComments: Int!
    
    private var _postKey: String!
    private var _postRef: Firebase!
    
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var userImage: String! {
        return _userImage
    }
    
    var postKey: String {
        return _postKey
    }
    
    var userKey: String {
        return _userKey
    }
    
    var postcomments: Int!{
        return _postComments
    }
    
    init(description: String, imageUrl: String?, username: String){
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        if let userUrl = dictionary["userImageUrl"] as? String {
            self._userImage = userUrl
        }
        
        if let userName = dictionary["username"] as? String {
            self._username = userName
        }
        
        if let uKey = dictionary["userID"] as? String {
            self._userKey = uKey;
        }
        
        if let commentPost = dictionary["comments"] as? Int {
            self._postComments = commentPost
        }
        
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        }
        else {
            _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
}











