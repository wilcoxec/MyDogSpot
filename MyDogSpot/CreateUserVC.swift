//
//  CreateUserVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/28/16.
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

class CreateUserVC: UIViewController {

    @IBOutlet weak var usernameField: SignUpTextField!
    @IBOutlet weak var locationField: SignUpTextField!

    
    //var userRef: Firebase!
    var userKeyToPass: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    
    @IBAction func createUser(sender: AnyObject) {
        
        let nameTxt = usernameField.text
        let locationTxt = locationField.text


        
        if nameTxt != "" && locationTxt != ""{
            self.postUserToFirebase()
        }
        else {
            //Print out error that all fields must be entered
        }

        
    }//end @IBAction createUser
    
    
    func postUserToFirebase() {
 
        let username = usernameField.text!
        let userlocation = locationField.text!

        
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("username").setValue(username)
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("location").setValue(userlocation)


        self.performSegueWithIdentifier(SEGUE_ADD_USER_PHOTO, sender: nil)

  
    }//end postUserToFirebase
    

    



}


















