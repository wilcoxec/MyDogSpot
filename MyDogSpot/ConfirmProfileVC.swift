//
//  ConfirmProfileVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 6/4/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit

class ConfirmProfileVC: UIViewController{

    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var addDog: UIButton!

    @IBOutlet weak var continueToFeed: UIButton!
    
    @IBAction func addAnother(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_ADD_ANOTHER_DOG, sender: nil)
        
        
    }
    
    @IBAction func continueToFeed(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_LOGIN_NEW_USER, sender: nil)
        
    }



}
