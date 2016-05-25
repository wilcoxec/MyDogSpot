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
    
    var DogKeyToReceive: String!
    var DogNameToReceive: String!
    var DogBirthToReceive: String!
    var DogGenderToRecieve: String!
    var DogImageToReceive: String!
    
    var dogKey: String!
    
    
    
    var dogRequest: Request?
    
    var skills = [Skill]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skillsTableView.delegate = self
        skillsTableView.dataSource = self
        
        dogKey = DogKeyToReceive
        self.dogNameLabel.text = DogNameToReceive
        self.dogBirthLabel.text = DogBirthToReceive
        self.dogGenderLabel.text = DogGenderToRecieve
        
        
        if let url = NSURL(string: DogImageToReceive){
            if let data = NSData(contentsOfURL: url) {
                self.dogProfileImage.image = UIImage(data: data)
            }
        }
        
        

        
        //Dog Skills
//        dogSkillRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAppendingPath(dogKey).childByAppendingPath("skills")
//        
//        dogSkillRef.observeEventType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
//            
//            self.skills = []
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
//                for snap in snapshots {
//                    if let skillDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let skill = Skill(skillKey: key, dictionary: skillDict)
//                        self.skills.append(skill)
//                        self.skillsTableView.reloadData()
//                    }
//                }
//            }
//
//        })
        
        self.skillsTableView.reloadData()
        
    }
    
    func getDogSkills(){
        
    }
    
    func configureDogProfile(){
        
        //self.dogNameLabel.text = dog.dogName
        //self.dogBirthLabel.text = dog.dogBirth
        //self.dogGenderLabel.text = dog.dogGender
        
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
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let sk = skills[indexPath.row]
        
        let send = sk.skillKey
        
        self.performSegueWithIdentifier(SEGUE_TO_SKILL_VIEW, sender: send)
    }
    
    
    @IBAction func editSkills(sender: AnyObject) {
        
        
        self.performSegueWithIdentifier(SEGUE_TO_EDIT_SKILL_VIEW, sender: sender)
        
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






