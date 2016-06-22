//
//  AddDogPhotoVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 6/4/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase

class AddDogPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var dogImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var uImgSelected = false
    
    var dogImagePicker: UIImagePickerController!
    
    var dogKeyReceived: String!
    var dogKey: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogKey = dogKeyReceived
        
        dogImagePicker = UIImagePickerController()
        dogImagePicker.delegate = self
    }
    
    @IBAction func dogImageTap(sender: UITapGestureRecognizer) {
        presentViewController(dogImagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        dogImagePicker.dismissViewControllerAnimated(true, completion: nil)
        dogImage.image = image
        uImgSelected = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addPhoto(sender: AnyObject) {
        
        let uImg = dogImage.image!
        
        
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
        
        REF_DOGS.child(dogKey).child("dogImage").setValue(imageUrl)
        dogImage.image = UIImage(named: "addImage")
        
        self.performSegueWithIdentifier(SEGUE_CONFIRM, sender: nil)
        
        
    }

    
    func postPhotoToFirebase(imgUrl: NSURL!) {
        
        let imageURL = imgUrl
        
        REF_DOGS.child(dogKey).child("dogImage").setValue(imageURL)
        dogImage.image = UIImage(named: "addImage")

        self.performSegueWithIdentifier(SEGUE_CONFIRM, sender: nil)
        
        
    }//end postUserToFirebase
}
