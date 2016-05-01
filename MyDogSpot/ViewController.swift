//
//  ViewController.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/5/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_ID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            }
            else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    if error != nil {
                        print("Login failed. \(error)")
                    }
                    else{
                        print("Logged In!\(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_ID)
                        
                        //Go change the !
                        let user = ["provider": authData.provider!]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        self.performSegueWithIdentifier(SEGUE_CREATE_USER, sender: nil)
                    }
                })
                
            }
        }
    }

    @IBAction func attemptLogin(sender: UIButton!){
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != ""{
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    if error.code == STATUS_ACCOUNT_DOESNOTEXIST {
                        
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result [KEY_ID], forKey: KEY_ID)
                                
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                                    
                                    let user = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                })
                                
                                //self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                self.performSegueWithIdentifier(SEGUE_CREATE_USER, sender: nil)
                            }
                        
                        })
                    }
                    else{
                            self.showErrorAlert("Could not login", msg: "Please check your username or password")
                    }
                }
                
                else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
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

