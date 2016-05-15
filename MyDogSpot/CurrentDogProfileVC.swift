//
//  CurrentDogProfileVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/14/16.
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

class CurrentDogProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var dogProfileImage: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var dogBirthLabel: UILabel!
    @IBOutlet weak var dogGenderLabel: UILabel!
    
    @IBOutlet weak var skillsTableView: UITableView!
    
    
    var dog: Dog!
    
    var DogInfoToSend: String!
    var DogKeyToReceive: String!
    
    var dogKey: String!
    var dogRef: Firebase!
    var dogSkillRef: Firebase!
    
    var dogRequest: Request?
    
    var skills = [Skill]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillsTableView.delegate = self
        skillsTableView.dataSource = self
        
        dogKey = DogKeyToReceive
        
        dogRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAppendingPath(dogKey)
        
        dogRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            if let dogDict = snapshot.value as? Dictionary<String, AnyObject>{
                let key = snapshot.key
                let dog = Dog(dogKey: key, dictionary: dogDict)
                self.configureDogProfile(dog)
                
            }
        
        })
        
        //Dog Skills
        dogSkillRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAppendingPath(dogKey).childByAppendingPath("skills")
        
        dogSkillRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.skills = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    if let skillDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let skill = Skill(skillKey: key, dictionary: skillDict)
                        self.skills.append(skill)
                        self.skillsTableView.reloadData()
                    }
                }
            }

        })
        
        self.skillsTableView.reloadData()
        
    }
    
    func configureDogProfile(dog: Dog){
        
        self.dogNameLabel.text = dog.dogName
        self.dogBirthLabel.text = dog.dogBirth
        self.dogGenderLabel.text = dog.dogGender
        
        let downloadPath = NSTemporaryDirectory().stringByAppendingString(dog.dogImageUrl)
        let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
        let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest.bucket = S3BucketName
        readRequest.key =  dog.dogImageUrl
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
                self.dogProfileImage.image = image
                
            }
            else {
                print("Unexpected empty result.")
            }
            
            return nil
            
        }

        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let skill = skills[indexPath.row]
        
        if let cell = skillsTableView.dequeueReusableCellWithIdentifier("SkillCell") as? SkillCell {
            
            cell.request?.cancel()
            
            cell.configureCell(skill)
            
            return cell
            
        }
        else{
            return SkillCell()
        }
        
        self.skillsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let sk = skills[indexPath.row]
        
        let send = sk.skillKey
        
        self.performSegueWithIdentifier(SEGUE_TO_SKILL_VIEW, sender: send)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == SEGUE_TO_SKILL_VIEW)
        {
            let sVC = segue.destinationViewController as! SkillVC
            sVC.dogKeyReceived = dogKey
            sVC.skillKeyReceived = sender as! String
        }
    }
}






