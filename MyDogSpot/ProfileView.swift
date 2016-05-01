//
//  ProfileView.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/28/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import UIKit

class ProfileView: UIView {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var dogImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var dogName: UILabel!
    
    
    var userInfo: CreateUser!
    
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
    
    func configureProfile(user: CreateUser) {
        
        self.userInfo = user
        
        self.userName.text = userInfo.userName
        self.userLocation.text = userInfo.userLocation
        self.dogName.text = userInfo.dogName
        
        
        self.userImageURL = userInfo.userImageUrl
        self.dogImageURL = userInfo.dogImageUrl
        
        
        imgRequest = Alamofire.request(.GET, userImageURL).validate(contentType: ["image/*"]).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let uImg = UIImage(data: data!)
                self.profileImg.image = uImg
            }
            else{
                print(err.debugDescription)
            }
            
        })
        
        self.requestDogImage(dogImageURL)

        
    }
    
    func requestDogImage(dogURL: String!) {
        
        dogRequest = Alamofire.request(.GET, dogURL).validate(contentType: ["image/*"]).response(completionHandler: {
            request, response, data, err in
            
            if err == nil {
                let dImg = UIImage(data: data!)
                self.dogImg.image = dImg
            }
            else{
                print(err.debugDescription)
            }
            
        })
    }

    
    
}
