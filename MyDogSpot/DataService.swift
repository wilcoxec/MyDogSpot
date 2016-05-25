//
//  DataService.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/7/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://mydogspot.firebaseio.com"

let FIREBASE_REF = FIRDatabase.database().reference()

let REF_BASE = FIREBASE_REF

let REF_POSTS = FIREBASE_REF.child("posts")

let REF_USERS = FIREBASE_REF.child("users")

let REF_DOGS = FIREBASE_REF.child("dogs")

let REF_COMMENTS = FIREBASE_REF.child("comments")

let REF_SKILL = FIREBASE_REF.child("skills")

let REF_CURRENT_USER = FIRAuth.auth()?.currentUser

let STORAGE = FIRStorage.storage()

let REF_STORAGE = STORAGE.referenceForURL("gs://project-443474076168895709.appspot.com")

class DataService {
    

    
    var REF_BASE = FIREBASE_REF
    
    var REF_POSTS = FIREBASE_REF.child("posts")
    
    var REF_USERS = FIREBASE_REF.child("users")
    
    var REF_DOGS = FIREBASE_REF.child("dogs")
    
    var REF_COMMENTS = FIREBASE_REF.child("comments")
    
    var REF_SKILL = FIREBASE_REF.child("skills")

    
    var REF_CURRENT_USER = FIRAuth.auth()?.currentUser

    
   
    

}

