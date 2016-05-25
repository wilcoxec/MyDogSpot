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
            if let url = NSURL(string: dog.dogImageUrl){
                if let data = NSData(contentsOfURL: url) {
                    dogImage.image = UIImage(data: data)
                }
            }
        }
            
    }
}
