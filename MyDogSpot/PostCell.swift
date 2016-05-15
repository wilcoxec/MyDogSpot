//
//  PostCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/26/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!
    
    var commentRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
        tapLike.numberOfTouchesRequired = 1
        likeImage.addGestureRecognizer(tapLike)
        likeImage.userInteractionEnabled = true

       // let userTap = UITapGestureRecognizer(target: self, action: #selector(PostCell.userTapped(_:)))
       /// userTap.numberOfTapsRequired = 1
       // profileName.addGestureRecognizer(userTap)
       // profileName.userInteractionEnabled = true

    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
    }

    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        self.descriptionText.text = post.postDescription
        
        if(post.likes == 0){
            self.likesLabel.text = ""
        }
        else if (post.likes == 1){
            self.likesLabel.text = "\(post.likes) like"
        }
        else{
            self.likesLabel.text = "\(post.likes) likes"
        }
        
        self.setCommentCount()
        

        if post.imageUrl != nil {
            if img != nil {
                self.showcaseImg.image = img
            }
            else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: {
                    request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                    else {
                        print(err.debugDescription)
                    }
                })
            }
        }
        else {
            self.showcaseImg.hidden = true
        }
        
        self.setUserInfo()

        //See if the like for post exists
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            //If the like does not exist in the post
            if let likeDoesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "like")
            }
            else {
                self.likeImage.image = UIImage(named: "likeFill")
            }
        })
        
       
    }//end of func configureCell
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let likeDoesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "likeFill")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            }
            else {
                self.likeImage.image = UIImage(named: "like")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
    
    

    
    
    func setUserInfo () {
        
        profileBtn.setTitle(post.username, forState: .Normal)
        
        
    }
    
    func setCommentCount(){
        commentRef = DataService.ds.REF_POSTS.childByAppendingPath(post.postKey).childByAppendingPath("comments")
        
        var cCount: Int!
        
        cCount = 0
        
        
        commentRef.observeEventType(.Value, withBlock: {
            
            snapshot in
            print(snapshot.value)
            
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    cCount = cCount + 1
                }
            }
            
            if(cCount == 0){
                self.commentsButton.setTitle("", forState: .Normal)
            }
            else if(cCount == 1){
                self.commentsButton.setTitle("\(cCount) comment", forState: .Normal)
            }
            else{
                //self.commentsButton.titleLabel?.text = "\(cCount) comments"
                self.commentsButton.setTitle("\(cCount) comments", forState: .Normal)
            }
            
            
        })
        
        self.commentsButton.setTitle("", forState: .Normal)
        //self.commentsButton.titleLabel?.text = "comments"
        
    }
    
    


}









