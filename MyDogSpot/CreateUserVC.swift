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

class CreateUserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameField: MaterialTextField!
    @IBOutlet weak var locationField: MaterialTextField!
    @IBOutlet weak var dognameField: MaterialTextField!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var dogImage: UIImageView!
    
    var createUser = [CreateUser]()
    
    var userImagePicker: UIImagePickerController!
    var dogImagePicker: UIImagePickerController!
    
    var uImgSelected = false
    var dImgSelected = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImagePicker = UIImagePickerController()
        dogImagePicker = UIImagePickerController()
        
        userImagePicker.delegate = self
        dogImagePicker.delegate = self

    }
    
    
    
    @IBAction func dogImageTap(sender: UITapGestureRecognizer) {
        presentViewController(dogImagePicker, animated: true, completion: nil)
        
        
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
        
        if picker == dogImagePicker {
            dogImagePicker.dismissViewControllerAnimated(true, completion: nil)
            dogImage.image = image
            dImgSelected = true
        }
        
    }
    
    @IBAction func createUser(sender: AnyObject) {
        
        let nameTxt = usernameField.text
        let locationTxt = locationField.text
        let dogTxt = dognameField.text
        
        let uImg = userImage.image!
        //let dImg = dogImage.image!

        if nameTxt != "" && locationTxt != "" && dogTxt != "" && dImgSelected == true && uImgSelected == true{
            
            
            let uImgData = UIImageJPEGRepresentation(uImg, 0.2)!
            //let dImgData = UIImageJPEGRepresentation(dImg, 0.2)!
            
            
            let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!


            //This came from alamofire github page  UPLOAD USER_IMAGE
            Alamofire.upload(
                .POST,
                "https://post.imageshack.us/upload_api.php",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: uImgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    if let userImgLink = links["image_link"] as? String {
                                        print ("LINK: \(userImgLink)")
                                        self.postUserToFirebase(userImgLink)
                                        self.postDogURL()
                                    }
                                }
                            }
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )//End Alamo User Image
            

            
        }
        else {
            //Print out error that all fields must be entered
        }
        
        
        
    }//end @IBAction createUser
    
    
    func postUserToFirebase(uImgUrl: String!) {
 
        let username = usernameField.text!
        let userlocation = locationField.text!
        let dogname = dognameField.text!
        let userImage = uImgUrl

        let namePost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
        namePost.setValue(username)
        
        let locPost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("location")
        locPost.setValue(userlocation)

        let imgPost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("userImageUrl")
        imgPost.setValue(userImage)

        let dogPost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogname")
        dogPost.setValue(dogname)

  
    }//end postUserToFirebase
    
    
    func postDogURL() {
        
        let urlStr = "https://post.imageshack.us/upload_api.php"
        let url = NSURL(string: urlStr)!
        let dImg = dogImage.image!
        
        //let uImgData = UIImageJPEGRepresentation(uImg, 0.2)!
        let dImgData = UIImageJPEGRepresentation(dImg, 0.2)!
        
        
        let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
        let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        //This came from alamofire github page  UPLOAD DOG_IMAGE
        Alamofire.upload(
            .POST,
            "https://post.imageshack.us/upload_api.php",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: dImgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                multipartFormData.appendBodyPart(data: keyData, name: "key")
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
            },
            encodingCompletion: { dogencodingResult in
                switch dogencodingResult {
                case .Success(let dogupload, _, _):
                    dogupload.responseJSON { dogresponse in
                        if let doginfo = dogresponse.result.value as? Dictionary<String, AnyObject> {
                            if let doglinks = doginfo["links"] as? Dictionary<String, AnyObject> {
                                if let dogImgLink = doglinks["image_link"] as? String {
                                    print ("LINK: \(dogImgLink)")
                                    self.postDogImageToFirebase(dogImgLink)
                                }
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )//End Alamo Dog Image
        
    }
    
    func postDogImageToFirebase(dImgUrl: String!) {
        
        let dogfirebaseUserPost = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogImageUrl")
        dogfirebaseUserPost.setValue(dImgUrl)
        
        usernameField.text = ""
        locationField.text = ""
        dognameField.text = ""
        dImgSelected = false
        uImgSelected = false
        
        dogImage.image = UIImage(named: "photoCameraDog")
        userImage.image = UIImage(named: "photoCameraPerson")
        
         self.performSegueWithIdentifier(SEGUE_LOGIN_NEW_USER, sender: nil)
        
    }//end


}


















