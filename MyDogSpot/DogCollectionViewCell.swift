//
//  DogCollectionViewCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/10/16.
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

class DogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    
    var dog: Dog!
    var request: Request?
    
    override func drawRect(rect: CGRect) {
        dogImage.layer.cornerRadius = dogImage.frame.size.width / 2
        dogImage.clipsToBounds = true
    }
    
    func configureCell(dog: Dog)
    {
        self.dog = dog
        dogName.text = dog.dogName
        
        if dog.dogImageUrl != "" {
            
            let downloadPath = NSTemporaryDirectory().stringByAppendingString(dog.dogImageUrl)
            let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            
            let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            readRequest.bucket = S3BucketName
            readRequest.key =  dog.dogImageUrl
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
                    self.dogImage.image = image
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                
                return nil
                
            }
        }
        
    }
}
