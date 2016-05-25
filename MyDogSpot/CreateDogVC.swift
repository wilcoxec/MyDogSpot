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
    @IBOutlet weak var dogGenderTextField: SignUpTextField!
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var addDogBtn: UIButton!
    
    var dogImagePicker: UIImagePickerController!
    
    var dogImageSelected = false

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogImagePicker = UIImagePickerController()
        dogImagePicker.delegate = self
    }

    @IBAction func dogImageTap(sender: UITapGestureRecognizer) {
        presentViewController(dogImagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        

        dogImagePicker.dismissViewControllerAnimated(true, completion: nil)
        dogImage.image = image
        dogImageSelected = true

        
    }
    
    @IBAction func createDogByAdd(sender: AnyObject) {
        
        let dogNameTxt = dogNameTextField.text
        let dogGender = dogGenderTextField.text
        let dogBirth = dogBirthTestField.text
        
        let dImg = dogImage.image!
        
        if dogNameTxt != "" && dogGender != "" && dogBirth != "" && dogImageSelected == true {
            
            let image = dImg
            
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            
            let imagePath = FIRAuth.auth()!.currentUser!.uid +
                "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadREF = REF_STORAGE.child(imagePath).putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    
                }
                else{
                    let downloadURL = metadata!.downloadURL()?.absoluteString
                    print(downloadURL)
                    self.postDogToFirebase(downloadURL)
                }
            }
            
            
        }
        
    }
    
    
    @IBAction func createDogAndContinue(sender: AnyObject) {
        
        let dogNameTxt = dogNameTextField.text
        
        let dImg = dogImage.image!
        
        if dogNameTxt != "" && dogImageSelected == true {
            
            let image = dImg
            
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            
            let imagePath = FIRAuth.auth()!.currentUser!.uid +
                "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadREF = REF_STORAGE.child(imagePath).putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    
                }
                else{
                    let downloadURL = metadata!.downloadURL()?.absoluteString
                    print(downloadURL)
                    self.postDogToFirebase(downloadURL)
                }
            }
            
        }
        
        //self.performSegueWithIdentifier(SEGUE_LOGIN_NEW_USER, sender: nil)
      
        
    }
    
    
    func postDogToFirebase(dImgUrl: String!){
        
        let newDog = REF_DOGS.childByAutoId()
        
        newDog.key
        
        REF_DOGS.child(newDog.key).child("dogname").setValue(dogNameTextField.text)
        REF_DOGS.child(newDog.key).child("birthday").setValue(dogBirthTestField.text)
        REF_DOGS.child(newDog.key).child("gender").setValue(dogGenderTextField.text)
        REF_DOGS.child(newDog.key).child("dogImage").setValue(dImgUrl)
        REF_DOGS.child(newDog.key).child("owner").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(true)
        
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("dogs").child(newDog.key).setValue(true)
        
        
        dogNameTextField.text = ""
        dogGenderTextField.text = ""
        dogBirthTestField.text = ""
        dogImageSelected = false
        dogImage.image = UIImage(named: "addphoto")

        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
        var initViewController: ViewController {
            return self.storyboard?.instantiateViewControllerWithIdentifier("initial") as! ViewController
        }
        
        self.presentViewController(initViewController, animated: true, completion: nil)
    }
    
}
