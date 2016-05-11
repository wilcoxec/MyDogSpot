//
//  DogCollectionViewCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/10/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Firebase

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
            request = Alamofire.request(.GET, dog.dogImageUrl).validate(contentType: ["image/*"]).response(completionHandler: {
                request, response, data, err in
                
                if err == nil {
                    let img = UIImage(data: data!)!
                    self.dogImage.image = img
                }
                else {
                    print(err.debugDescription)
                }
            })
        }
        
    }
}
