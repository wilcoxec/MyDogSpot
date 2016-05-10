//
//  PorfileVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/28/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class PorfileVC: UIViewController {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var dogImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var dogName: UILabel!
    
    var userInfo: CreateUser!
    
    var imgRequest: Request?
    var dogRequest: Request?
    
    var userImageURL: String!
    var dogImageURL: String!
    
    var userRef: Firebase!
    var dogRef: Firebase!
    
    var dogs = [Dog]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRef = DataService.ds.REF_USER_CURRENT
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                let user = CreateUser(userKey: key, dictionary: userDict)
                self.configureProfile(user)
            }
            
        })
        
        dogRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs")
        
        dogRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            
            self.dogs = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    if let dogDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let dog = Dog(dogKey: key, dictionary: dogDict)
                        self.dogs.append(dog)
                    }
                }
            }

        })

    }
    
    func configureProfile(user: CreateUser) {
        
        
        userName.text = user.userName
        userLocation.text = user.userLocation
        userImageURL = user.userImageUrl
        
        
        imgRequest = Alamofire.request(.GET, userImageURL).validate(contentType: ["image/*"]).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let uImg = UIImage(data: data!)
                self.profileImg.image = uImg
            }
            else{
                print(err.debugDescription)
            }
        
        })
        
        //self.requestDogImage(dogImageURL)
        
    }
    
    
    func requestDogImage(dogURL: String!) {
        
        dogRequest = Alamofire.request(.GET, dogURL).validate(contentType: ["image/*"]).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let dImg = UIImage(data: data!)
                self.dogImg.image = dImg
            }
            else{
                print(err.debugDescription)
            }
            
        })
    }
    
    
    
    




}
