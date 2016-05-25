//
//  ProfileView.swift
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
class ProfileView: UIView {
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    
    
    
    var userInfo: User!
    
    var userImageURL: String!
    var dogImageURL: String!
    
    var imgRequest: Request?
    var dogRequest: Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func drawRect(rect: CGRect) {
        layer.cornerRadius = frame.size.width / 2
        layer.cornerRadius = frame.size.width / 2
        
        clipsToBounds = true
        clipsToBounds = true
        
    }
    
    func configureProfile(user: User) {
        
        self.userInfo = user
        
        self.userName.text = userInfo.userName
        self.userLocation.text = userInfo.userLocation
        
        
        
        self.userImageURL = userInfo.userImageUrl
        
        
        let downloadPath = NSTemporaryDirectory().stringByAppendingString(self.userImageURL)
        let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
        let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        readRequest.bucket = S3BucketName
        readRequest.key =  self.userImageURL
        readRequest.downloadingFileURL = downloadingFileURL
        
        transferManager.download(readRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("Upload failed ❌ (\(error))")
            }
            if let exception = task.exception {
                print("Upload failed ❌ (\(exception))")
            }
            if task.result != nil {
                let img = task.result
                print(img)
                let image = UIImage(contentsOfFile: downloadPath)
                self.profileImg.image = image
                
            }
            else {
                print("Unexpected empty result.")
            }
            
            return nil
            
        }


        
    }
    


    
    
}
