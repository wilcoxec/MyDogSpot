//
//  SignInVC.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 6/4/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func attemptLogin(sender: UIButton!){
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != ""{

            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in
                
                if error != nil {
                    if error?.code == 17011{
                        
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: (error?.localizedFailureReason)!)
                            }
                            else {
                                
                                REF_USERS.child(user!.uid).setValue(["provider": email])
                                print(FIRAuth.auth()?.currentUser?.uid)
                                self.performSegueWithIdentifier(SEGUE_CREATE_USER, sender: nil)
                                
                            }
                        })
                    }
                }
                
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
  
                
            })

            
        }
        else{
            showErrorAlert("Email and Password Required", msg: "You must enter an email and password.")
        }
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}
