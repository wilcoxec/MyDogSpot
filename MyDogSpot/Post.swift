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
    private var _postText: String!
    private var _postImage: String?
    private var _postLikes: Int!
    
    private var _postDate: Int!
    
    private var _postUser: String!
    private var _postUserImg: String!
    private var _postUserKey: String!
    
    private var _postComments: Int!
    private var _postKey: String!

    
    
    var postText: String {
        return _postText
    }
    
    var postImage: String? {
        return _postImage
    }
    
    var postLikes: Int {
        return _postLikes
    }
    
    var postUser: String {
        return _postUser
    }
    
    var postUserImg: String! {
        return _postUserImg
    }
    
    var postKey: String {
        return _postKey
    }
    
    var postUserKey: String {
        return _postUserKey
    }
    
    var postComments: Int {
        return _postComments
    }
    
    var postDate: Int {
        return _postDate
    }
    

    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._postLikes = likes
        }
        
        if let imgUrl = dictionary["image"] as? String {
            self._postImage = imgUrl
        }
        
        if let desc = dictionary["text"] as? String {
            self._postText = desc
        }

        if let comments = dictionary["comments"] as? Int {
            self._postComments = comments
        }
        
        if let date = dictionary["date"] as? Int {
            self._postDate = date
        }
        
        if let userInfo = dictionary["user"] as? Dictionary<String, AnyObject> {
            //self._postUserKey = userInfo.key
            print(userInfo)
            for (key, _) in userInfo {
                self._postUserKey = key
                print(self._postUserKey)
            }
            
        }
        
    }
    
    func setUserInfo(user: User){
        
        self._postUser = user.userName
        self._postUserImg = user.userImageUrl
    }
    
    func adjustLikes(addLike: Bool) {
//        if addLike {
//            _likes = _likes + 1
//        }
//        else {
//            _likes = _likes - 1
//        }
        
       // _postRef.childByAppendingPath("likes").setValue(_likes)
    }
}











