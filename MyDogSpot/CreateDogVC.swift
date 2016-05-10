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

class CreateDogVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var dogNameTextField: SignUpTextField!
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
        
        let dImg = dogImage.image!
        
        if dogNameTxt != "" && dogImageSelected == true {
            
            let dImgData = UIImageJPEGRepresentation(dImg, 0.2)!
            let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!

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
                                        self.postDogToFirebase(dogImgLink)
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
        
    }
    
    
    @IBAction func createDogAndContinue(sender: AnyObject) {
        
        let dogNameTxt = dogNameTextField.text
        
        let dImg = dogImage.image!
        
        if dogNameTxt != "" && dogImageSelected == true {
            
            let dImgData = UIImageJPEGRepresentation(dImg, 0.2)!
            let keyData = "49ACILMSa3bb4f31c5b6f7aeee9e5623c70c83d7".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
            
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
                                        self.postDogToFirebase(dogImgLink)
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
        
        self.performSegueWithIdentifier(SEGUE_LOGIN_NEW_USER, sender: nil)
        
    }
    
    
    func postDogToFirebase(dImgUrl: String!){
        
        let dogPostFirebase = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAutoId()
        
        var dogPost: Dictionary<String, AnyObject> = [
            "dogname": dogNameTextField.text!,
            "dogImageUrl": dImgUrl
        ]
        
        dogPostFirebase.setValue(dogPost)
        
        dogNameTextField.text = ""
        dogImageSelected = false
        dogImage.image = UIImage(named: "addphoto")

        
    }
}
