//
//  AddUserPhotoVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 6/4/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase

class AddUserPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    var userImagePicker: UIImagePickerController!
    var uImgSelected = false
    


    override func viewDidLoad() {
        super.viewDidLoad()
        userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    @IBAction func imageTap(sender: UITapGestureRecognizer) {
        presentViewController(userImagePicker, animated: true, completion: nil)
        
        
    }
    
    //Change to add videos
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        userImagePicker.dismissViewControllerAnimated(true, completion: nil)
        userImage.image = image
        uImgSelected = true
        
        
    }
    

    @IBAction func addPhoto(sender: AnyObject) {
        
        let uImg = userImage.image!
        
        
        if uImgSelected == true{
            
            let image = uImg
            
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            
            let imagePath = FIRAuth.auth()!.currentUser!.uid +
                "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
            
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            REF_STORAGE.child(imagePath).putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    
                }
                else{
                    //let downloadURL = metadata!.downloadURL
                    self.uploadSuccess(metadata!, storagePath: imagePath)
                }
            }
            
            
            
        }
        else {
            //Print out error that all fields must be entered
        }
        
        
    }//end
    
    func uploadSuccess(metadata: FIRStorageMetadata, storagePath: String){
        
        let imageUrl = metadata.downloadURL()!.absoluteString
        
        print(imageUrl)
        
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("userImage").setValue(imageUrl)
        self.performSegueWithIdentifier(SEGUE_TO_CREATE_DOG, sender: nil)
        
        
    }
    
    func postPhotoToFirebase(imgUrl: NSURL!) {
        
        let userImageURL = imgUrl
        
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("userImage").setValue(userImageURL)

        self.performSegueWithIdentifier(SEGUE_TO_CREATE_DOG, sender: nil)
        
        
    }//end postUserToFirebase



}
