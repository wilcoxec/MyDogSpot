//
//  CommentCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/7/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UIButton!
    
    @IBOutlet weak var commentTxt: UITextView!
    
    var comment: Comment!
    
    var request: Request?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        profileImage.clipsToBounds = true
    }
    
    func configureCommentCell(comment: Comment) {
        self.comment = comment
        
        print(comment.commentText)
        
        
        self.commentTxt.text = comment.commentText
        
        self.profileName.setTitle(comment.username, forState: .Normal)
        
        if comment.userImage != nil {
            
            request = Alamofire.request(.GET, comment.userImage!).validate(contentType: ["image/*"]).response(completionHandler: {
                request, response, data, err in
                
                if err == nil {
                    let img = UIImage(data: data!)!
                    self.profileImage.image = img
                    FeedVC.imageCache.setObject(img, forKey: self.comment.userImage!)
                }
                else {
                    print(err.debugDescription)
                }
            })
        }
        
        
    }
    
}
