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
            request = Alamofire.request(.GET, endorsement.userImage).validate(contentType: ["image/*"]).response(completionHandler: {
                request, response, data, err in
                
                if err == nil {
                    let img = UIImage(data: data!)!
                    self.userImage.image = img
                    //FeedVC.imageCache.setObject(img, forKey: self.comment.userImage!)
                }
                else {
                    print(err.debugDescription)
                }
            })
        }
    }

}
