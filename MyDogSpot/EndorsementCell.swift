//
//  EndorsementCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/14/16.
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

class EndorsementCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UIButton!
    
    var endorsement: Endorsement!
    var request: Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func drawRect(rect: CGRect) {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(endorsement: Endorsement){
        self.endorsement = endorsement
        
        self.userName.setTitle(endorsement.userName, forState: .Normal)
        
        if endorsement.userImage != "" {
            let downloadPath = NSTemporaryDirectory().stringByAppendingString(endorsement.userImage)
            let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            
            let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            readRequest.bucket = S3BucketName
            readRequest.key =  endorsement.userImage
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
                    self.userImage.image = image
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                
                return nil
                
            }//end download
        }//end if
        
    }

}
