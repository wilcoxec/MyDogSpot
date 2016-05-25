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
import AWSS3
import AWSCore
import AWSDynamoDB
import AWSSQS
import AWSSNS
import AWSCognito

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
    
    var userInfo: User!
    
    var userImageRequest: Request?
    
    
    var dogs = [Dog]()
    
    var DogProfileVC: CurrentDogProfileVC!
    
    var dogKeys = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogCollection.delegate = self
        dogCollection.dataSource = self
        
        
        //Get the users info
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            print(snapshot.value)
            
            if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                let user = User(userKey: key, dictionary: userDict)
                self.configureProfile(user)
            }
            
        })
        
        
        //Get the dogs info
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("dogs").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            print(snapshot.value)
            
            self.dogKeys = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    print(snap)
                    self.dogKeys.append(snap.key)
//                    if let dogDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        self.dogKeys.append(key)
//                        self.dogCollection.reloadData()
//                    }
                }
                
                self.configureDogCollection(self.dogKeys)
            }
            
        })
        
        dogCollection.reloadData()
        
    }
    
    func configureProfile(user: User) {
 
        usersName.text = user.userName
        usersLocation.text = user.userLocation
        usersImageUrl = user.userImageUrl
        
        if let url = NSURL(string: user.userImageUrl){
            if let data = NSData(contentsOfURL: url) {
                usersProfileImage.image = UIImage(data: data)
            }
        }
        
    }
    
    
    func configureDogCollection(dogKeys: [String]){
        
        for dog in self.dogKeys {
            
            print(dog)
            
            REF_DOGS.child(dog).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                if let dogDict = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    let dog = Dog(dogKey: key, dictionary: dogDict)
                    self.dogs.append(dog)
                    self.dogCollection.reloadData()
                }
            })
            
        }
        self.dogCollection.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let dog = dogs[indexPath.row]
        //let dog = self.dogKeys[indexPath.row]
        
        let dogInfo = indexPath.row
        
        self.performSegueWithIdentifier(SEGUE_TO_DOG_PROFILE, sender: dogInfo)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("identifier")
        print(segue.identifier)
        
        print("sender")
        print(sender)

        if(segue.identifier == SEGUE_TO_DOG_PROFILE){
            let dog = dogs[sender as! Int]

            let dogVC = segue.destinationViewController as! CurrentDogProfileVC
            dogVC.DogKeyToReceive = dog.dogKey
            dogVC.DogNameToReceive = dog.dogName
            dogVC.DogBirthToReceive = dog.dogBirth
            dogVC.DogGenderToRecieve = dog.dogGender
            dogVC.DogImageToReceive = dog.dogImageUrl
            
        }
    }

}
