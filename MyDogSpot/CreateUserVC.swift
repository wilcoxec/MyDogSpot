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

class CreateUserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameField: SignUpTextField!
    @IBOutlet weak var locationField: SignUpTextField!
    
    @IBOutlet weak var userImage: UIImageView!
    
    var userImagePicker: UIImagePickerController!
    var uImgSelected = false
    
    var userRef: Firebase!
    var userKeyToPass: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImagePicker = UIImagePickerController()
        
        userImagePicker.delegate = self
        
        userRef = DataService.ds.REF_USER_CURRENT
        
        userRef.observeEventType(.Value, withBlock: { snapshot in
            
            print(snapshot.value)
            self.userKeyToPass = snapshot.key
            
        })


    }
    
    
    @IBAction func userImageTap(sender: UITapGestureRecognizer) {
        presentViewController(userImagePicker, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        if picker == userImagePicker {
            userImagePicker.dismissViewControllerAnimated(true, completion: nil)
            userImage.image = image
            uImgSelected = true
        }
        
    }
    
    @IBAction func createUser(sender: AnyObject) {
        
        let nameTxt = usernameField.text
        let locationTxt = locationField.text
        let uImg = userImage.image!

        
        if nameTxt != "" && locationTxt != ""  && uImgSelected == true{
            
            var path: NSString!
            path = NSTemporaryDirectory().stringByAppendingString("image.png")
            
            var imageData: NSData!
            imageData = UIImagePNGRepresentation(uImg)
            
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
                    
                    self.postUserToFirebase(uploadRequest.key)
                }
                else {
                    print("Unexpected empty result.")
                }

                
                return nil
            }
            
        }
        else {
            //Print out error that all fields must be entered
        }
        
        self.performSegueWithIdentifier(SEGUE_TO_CREATE_DOG, sender: nil)

        
    }//end @IBAction createUser
    
    
    func postUserToFirebase(uImgUrl: String!) {
 
        let username = usernameField.text!
        let userlocation = locationField.text!

        let namePost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
        namePost.setValue(username)
        
        let locPost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("location")
        locPost.setValue(userlocation)
        
        let imgPost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("userImageUrl")
        imgPost.setValue(uImgUrl)

        //self.performSegueWithIdentifier(SEGUE_TO_CREATE_DOG, sender: nil)

  
    }//end postUserToFirebase
    

    



}


















