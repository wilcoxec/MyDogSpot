//
//  SkillCell.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 5/14/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SkillCell: UITableViewCell {
    
    
    @IBOutlet weak var skillName: UILabel!
    @IBOutlet weak var numEndorsement: UILabel!
    
    var skill: Skill!
    
    //var skillRef: Firebase!
    //var endorsementRef: Firebase!
    
    var request: Request?
    
    var skillKey: String!
    var dogKey:  String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //override func drawRect(rect: CGRect) {
        //skillImage.layer.cornerRadius = skillImage.frame.size.width / 2
        //skillImage.clipsToBounds = true
    //}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(skill: Skill){
        self.skill = skill
        
        self.dogKey = skill.dogKey

        self.skillKey = skill.skillKey
        
        self.skillName.text = skill.skillName
        
        self.setEndorsementCount()
        
    }
    
    func setEndorsementCount(){
        
        var eCount: Int!
        eCount = 0
        //var skillKey = self.skill.skillKey
        
        print(self.dogKey)
        print(self.skillKey)
        
//        endorsementRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("dogs").childByAppendingPath(self.dogKey).childByAppendingPath("skills").childByAppendingPath(self.skillKey).childByAppendingPath("endorsements")
//        
//        endorsementRef.observeEventType(.Value, withBlock: { snapshot in
//            
//            print(snapshot.value)
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
//                for snap in snapshots{
//                    eCount = eCount + 1
//                }
//                
//                self.numEndorsement.text = "\(eCount)"
//            }
//
//        })
        self.numEndorsement.text = "\(eCount)"
        //self.numEndorsement.text = "\(eCount)"
        
    }

}










