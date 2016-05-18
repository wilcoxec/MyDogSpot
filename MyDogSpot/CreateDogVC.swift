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
        
        if picker == dogImagePicker {
            dogImagePicker.dismissViewControllerAnimated(true, completion: nil)
            dogImage.image = image
            dogImageSelected = true
        }
        
    }
    
    @IBAction func createDogByAdd(sender: AnyObject) {
        
        let dogNameTxt = dogNameTextField.text
        let dogGender = dogGenderTextField.text
        let dogBirth = dogBirthTestField.text
        
        let dImg = dogImage.image!
        
        if dogNameTxt != "" && dogGender != "" && dogBirth != "" && dogImageSelected == true {
            
            
            var path: NSString!
            path = NSTemporaryDirectory().stringByAppendingString("image.png")
            
            var imageData: NSData!
            imageData = UIImagePNGRepresentation(dImg)
            
            imageData.writeToFile(path as String, atomically: true)
            
            var url: NSURL!
            url = NSURL(fileURLWithPath: path as String)
            
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            
            uploadRequest.bucket = S3BucketName
            uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + "." + "png"
            uploadRequest.contentType = "image/png"
            uploadRequest.body = url
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                }
                if let exception = task.exception {
                    print("Upload failed ❌ (\(exception))")
                }
                if task.result != nil {
                    let s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
                    print("Uploaded to:\n\(s3URL)")
                    
                    self.postDogToFirebase(uploadRequest.key)
                }
                else {
                    print("Unexpected empty result.")
                }
                
                return nil
            }

            
        }
        
    }
    
    
    @IBAction func createDogAndContinue(sender: AnyObject) {
        
        let dogNameTxt = dogNameTextField.text
        
        let dImg = dogImage.image!
        
        if dogNameTxt != "" && dogImageSelected == true {
            
            var path: NSString!
            path = NSTemporaryDirectory().stringByAppendingString("image.png")
            
            var imageData: NSData!
            imageData = UIImagePNGRepresentation(dImg)
            
            imageData.writeToFile(path as String, atomically: true)
            
            var url: NSURL!
            url = NSURL(fileURLWithPath: path as String)
            
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            
            uploadRequest.bucket = S3BucketName
            uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + "." + "png"
            uploadRequest.contentType = "image/png"
            uploadRequest.body = url
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                }
                if let exception = task.exception {
                    print("Upload failed ❌ (\(exception))")
                }
                if task.result != nil {
                    let s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
                    print("Uploaded to:\n\(s3URL)")
                    
                    self.postDogToFirebase(uploadRequest.key)
                }
                else {
                    print("Unexpected empty result.")
                }
                
                return nil
            }

            
        }
        
        self.performSegueWithIdentifier(SEGUE_LOGIN_NEW_USER, sender: nil)
      
        
    }
    
    
    func postDogToFirebase(dImgUrl: String!){
        
        let dogPostFirebase = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAutoId()
        
        var dogPost: Dictionary<String, AnyObject> = [
            "dogname": dogNameTextField.text!,
            "dogImageUrl": dImgUrl,
            "dogBirth": dogBirthTestField.text!,
            "dogGender": dogGenderTextField.text!
        ]
        
        dogPostFirebase.setValue(dogPost)
        
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
