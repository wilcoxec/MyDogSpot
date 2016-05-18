//
//  CommentCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/7/16.
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

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UIButton!
    
    @IBOutlet weak var commentTxt: UITextView!
    
    var comment: Comment!
    
    var request: Request?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        var cFrame = self.commentTxt.frame
        cFrame.size.height = self.commentTxt.contentSize.height
        self.commentTxt.frame = cFrame
        
        
        commentTxt.scrollEnabled = false
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        profileImage.clipsToBounds = true
        commentTxt.clipsToBounds = true
    }
    
    func configureCommentCell(comment: Comment) {
        self.comment = comment
        
        print(comment.commentText)
        
        
        self.commentTxt.text = comment.commentText
        
        self.profileName.setTitle(comment.username, forState: .Normal)
        
        if comment.userImage != nil {
            
            let downloadPath = NSTemporaryDirectory().stringByAppendingString(comment.userImage)
            let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            
            let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
            readRequest.bucket = S3BucketName
            readRequest.key =  comment.userImage
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
                    self.profileImage.image = image
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                
                return nil
                
            }

        }
        
        
    }
    
}
