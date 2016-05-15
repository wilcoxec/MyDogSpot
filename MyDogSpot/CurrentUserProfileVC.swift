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
    
    var userInfo: CreateUser!
    
    var userImageRequest: Request?
    
    var userRef: Firebase!
    var dogRef: Firebase!
    
    var dogs = [Dog]()
    
    var DogProfileVC: CurrentDogProfileVC!
    
    
    
    
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
                        self.dogCollection.reloadData()
                    }
                }
            }
            
        })
        
        dogCollection.reloadData()
        
    }
    
    func configureProfile(user: CreateUser) {
 
        usersName.text = user.userName
        usersLocation.text = user.userLocation
        usersImageUrl = user.userImageUrl
        
        
        let downloadPath = NSTemporaryDirectory().stringByAppendingString(usersImageUrl)
        let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
        let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest.bucket = S3BucketName
        readRequest.key =  usersImageUrl
        readRequest.downloadingFileURL = downloadingFileURL
        
        transferManager.download(readRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("Upload failed ❌ (\(error))")
            }
            if let exception = task.exception {
                print("Upload failed ❌ (\(exception))")
            }
            if task.result != nil {
                let img = task.result
                print(img)
                let image = UIImage(contentsOfFile: downloadPath)
                self.usersProfileImage.image = image
                
            }
            else {
                print("Unexpected empty result.")
            }
            
            return nil
            
        }

        
        
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
        let dog = dogs[indexPath.row]
        
        self.performSegueWithIdentifier(SEGUE_TO_DOG_PROFILE, sender: dog.dogKey)
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
            let dogVC = segue.destinationViewController as! CurrentDogProfileVC
            dogVC.DogKeyToReceive = sender as! String
            
        }
    }

}
