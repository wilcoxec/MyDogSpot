//
//  CreateDogVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/9/16.
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

class CreateDogVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var dogNameTextField: SignUpTextField!
    @IBOutlet weak var dogBirthTestField: SignUpTextField!

    @IBOutlet weak var genderSelect: UISegmentedControl!
    
    var dogGender: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogGender = "Male"

    }


    
    @IBAction func createDogByAdd(sender: AnyObject) {
        
        let dogNameTxt = dogNameTextField.text
        let dogBirth = dogBirthTestField.text
  
        if dogNameTxt != "" && dogBirth != "" {
            self.postDogToFirebase()
            
        }
        
    }
    
    @IBAction func genderSelect(sender: AnyObject) {
        
        switch genderSelect.selectedSegmentIndex
        {
        case 0:
            dogGender = "Male"
        case 1:
            dogGender = "Female"
        default:
            break
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dogPhotoVC = segue.destinationViewController as! AddDogPhotoVC
        dogPhotoVC.dogKeyReceived = sender as! String

        
    }
    
    func postDogToFirebase(){
        
        print(dogGender)
        
        let newDog = REF_DOGS.childByAutoId()
        
        newDog.key
        
        REF_DOGS.child(newDog.key).child("dogname").setValue(dogNameTextField.text)
        REF_DOGS.child(newDog.key).child("birthday").setValue(dogBirthTestField.text)
        REF_DOGS.child(newDog.key).child("gender").setValue(dogGender)
        REF_DOGS.child(newDog.key).child("owner").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(true)
        
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("dogs").child(newDog.key).setValue(true)
        
        
        dogNameTextField.text = ""
        dogBirthTestField.text = ""
        
        self.performSegueWithIdentifier(SEGUE_ADD_DOG_PHOTO, sender: newDog.key)


    }
    
    
}
