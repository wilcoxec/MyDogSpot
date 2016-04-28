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
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
        tapLike.numberOfTouchesRequired = 1
        likeImage.addGestureRecognizer(tapLike)
        likeImage.userInteractionEnabled = true
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
        self.likesLabel.text = "\(post.likes)"
        
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

}









