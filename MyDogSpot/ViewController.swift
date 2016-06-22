//
//  ViewController.swift
//  MyDogSpot
//
//  Created by Erika Wilcox on 4/5/16.
//  Copyright © 2016 Erika Wilcox. All rights reserved.
//

import UIKit
import Firebase
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
        
    
        //Check if the user is already logged in
//        if FIRAuth.auth()?.currentUser != nil {
//           print(FIRAuth.auth()?.currentUser?.email)
//           self.performSegueWithIdentifier(SEGUE_LOGGED_IN_FB, sender: nil)
//        }

    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was canceled.")
            }
            else{
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
                
                
//                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
//                    if error != nil {
//                        print("Login failed. \(error)")
//                    }
//                    else{
//                        print("Logged In!\(authData)")
//                        
//
//                        
//                        let userRef = DataService.ds.REF_USERS.childByAppendingPath(authData.uid)
//                        
//                        userRef.observeSingleEventOfType(.Value, withBlock: {
//                            snap in
//                            
//                            if snap.value is NSNull {
//                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_ID)
//
//                                let user = ["provider": authData.provider!]
//                                DataService.ds.createFirebaseUser(authData.uid, user: user)
//                                
//                                self.performSegueWithIdentifier(SEGUE_CREATE_USER, sender: nil)
//                            }
//                            else{
//                                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_ID)
//                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
//                            }
//                            
//                       })
//                        
//                        
//                    }
//                })
                
            }
        }
    }
    @IBAction func SignUpPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier(SEGUE_SIGN_UP, sender: nil)
    }

        
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}

