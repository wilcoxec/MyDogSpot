//
//  CurrentUserProfileVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/10/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class CurrentUserProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var usersProfileImage: UIImageView!
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var usersName: UILabel!
    @IBOutlet weak var usersLocation: UILabel!
    
    @IBOutlet weak var userFollowers: UIButton!
    @IBOutlet weak var usersFollowing: UIButton!
    @IBOutlet weak var usersFriends: UIButton!
    
    
    @IBOutlet weak var dogCollection: UICollectionView!
    
    var usersImageUrl: String!
    
    var userInfo: CreateUser!
    
    var userImageRequest: Request?
    
    var userRef: Firebase!
    var dogRef: Firebase!
    
    var dogs = [Dog]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogCollection.delegate = self
        dogCollection.dataSource = self

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
 
        usersName.text = user.userName
        usersLocation.text = user.userLocation
        usersImageUrl = user.userImageUrl
        
        
        userImageRequest = Alamofire.request(.GET, usersImageUrl).validate(contentType: ["image/*"]).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let uImg = UIImage(data: data!)
                self.usersProfileImage.image = uImg
            }
            else{
                print(err.debugDescription)
            }
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cDog = dogs[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DogCell", forIndexPath: indexPath) as? DogCollectionViewCell {
            cell.request?.cancel()
            
            cell.configureCell(cDog)

            return cell
        }
        else{
            return DogCollectionViewCell()
        }
    }
    
    //func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    //}
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

}
