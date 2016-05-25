//
//  PostCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/26/16.
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

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var postTime: UILabel!
    
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var commentImg: UIImageView!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    

    
    var post: Post!
    var request: Request?
    //var likeRef: Firebase!
    
    //var commentRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let tapLike = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
//        tapLike.numberOfTouchesRequired = 1
//        likeImage.addGestureRecognizer(tapLike)
//        likeImage.userInteractionEnabled = true



    }
    
    override func drawRect(rect: CGRect) {
//        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
//        
//        profileImg.clipsToBounds = true
//        showcaseImg.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(post: Post, img: UIImage?) {
//        self.post = post
//        
//        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
//        
//        self.descriptionText.text = post.postDescription
//        
//        if(post.likes == 0){
//            self.likesLabel.text = ""
//        }
//        else if (post.likes == 1){
//            self.likesLabel.text = "\(post.likes) like"
//        }
//        else{
//            self.likesLabel.text = "\(post.likes) likes"
//        }
//        
//        self.setCommentCount()
//        
//
//        if post.imageUrl != nil {
//            if img != nil {
//                self.showcaseImg.image = img
//            }
//            else {
//                
//                let downloadPath = NSTemporaryDirectory().stringByAppendingString(post.imageUrl!)
//                let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
//                
//                let transferManager = AWSS3TransferManager.defaultS3TransferManager()
//                
//                
//                let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
//                readRequest.bucket = S3BucketName
//                readRequest.key =  post.imageUrl
//                readRequest.downloadingFileURL = downloadingFileURL
//                
//                transferManager.download(readRequest).continueWithBlock { (task) -> AnyObject! in
//                    if let error = task.error {
//                        print("Upload failed ❌ (\(error))")
//                    }
//                    if let exception = task.exception {
//                        print("Upload failed ❌ (\(exception))")
//                    }
//                    if task.result != nil {
//                        let img = task.result
//                        print(img)
//                        let image = UIImage(contentsOfFile: downloadPath)
//                        self.showcaseImg.image = image
//                        
//                    }
//                    else {
//                        print("Unexpected empty result.")
//                    }
//                    
//                    return nil
//                    
//                }
//
//            }
//        }
//        else {
//            self.showcaseImg.hidden = true
//        }
//        
//        self.setUserInfo()
//
//        //See if the like for post exists
//        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            
//            //If the like does not exist in the post
//            if let likeDoesNotExist = snapshot.value as? NSNull {
//                self.likeImage.image = UIImage(named: "like")
//            }
//            else {
//                self.likeImage.image = UIImage(named: "likeFill")
//            }
//        })
        
       
    }//end of func configureCell
    
    func likeTapped(sender: UITapGestureRecognizer) {
//        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            
//            if let likeDoesNotExist = snapshot.value as? NSNull {
//                self.likeImage.image = UIImage(named: "likeFill")
//                self.post.adjustLikes(true)
//                self.likeRef.setValue(true)
//            }
//            else {
//                self.likeImage.image = UIImage(named: "like")
//                self.post.adjustLikes(false)
//                self.likeRef.removeValue()
//            }
//        })
    }
    
    

    
    
    func setUserInfo () {
        
//        profileBtn.setTitle(post.username, forState: .Normal)
//        
//        
//        let downloadPath = NSTemporaryDirectory().stringByAppendingString(post.userImage!)
//        let downloadingFileURL = NSURL(fileURLWithPath: downloadPath )
//        
//        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        
//        let readRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
//        readRequest.bucket = S3BucketName
//        readRequest.key =  post.userImage
//        readRequest.downloadingFileURL = downloadingFileURL
//        
//        transferManager.download(readRequest).continueWithBlock { (task) -> AnyObject! in
//            if let error = task.error {
//                print("Upload failed ❌ (\(error))")
//            }
//            if let exception = task.exception {
//                print("Upload failed ❌ (\(exception))")
//            }
//            if task.result != nil {
//                let img = task.result
//                print(img)
//                let image = UIImage(contentsOfFile: downloadPath)
//                self.showcaseImg.image = image
//                
//            }
//            else {
//                print("Unexpected empty result.")
//            }
//            
//            return nil
//            
//        }
 
        
    }
    
    func setCommentCount(){
//        commentRef = DataService.ds.REF_POSTS.childByAppendingPath(post.postKey).childByAppendingPath("comments")
//        
//        var cCount: Int!
//        
//        cCount = 0
//        commentRef.observeEventType(.Value, withBlock: {
//            
//            snapshot in
//            print(snapshot.value)
//            
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
//                for snap in snapshots {
//                    cCount = cCount + 1
//                }
//            }
//            
//            if(cCount == 0){
//                self.commentsButton.setTitle("", forState: .Normal)
//            }
//            else if(cCount == 1){
//                self.commentsButton.setTitle("\(cCount) comment", forState: .Normal)
//            }
//            else{
//                //self.commentsButton.titleLabel?.text = "\(cCount) comments"
//                self.commentsButton.setTitle("\(cCount) comments", forState: .Normal)
//            }
//            
//            
//        })
        
       // self.commentsButton.setTitle("", forState: .Normal)
        
    }
    
    


}









