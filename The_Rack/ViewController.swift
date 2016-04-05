//
//  ViewController.swift
//  The_Rack
//
//  Created by Michael Hardin on 3/31/16.
//  Copyright © 2016 Michael Hardin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    

    @IBAction func fbBtnPressed(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                //print("success \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                
                    if error != nil {
                        print("login failed \(error)")
                    }else {
                        print("logged in \(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
            }
        }
        
        
        
        
    }
    
    
    @IBAction func attemptLogin(sender:UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
           DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
            if error != nil {
                print(error.code)
                
                if error.code == STATUS_ACCOUNT_NONEXIST {
                    DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                        if error != nil {
                            self.showErrorAlert("Could not create account", msg: "Problem creating account. Try Something else")
                        }else {
                            NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                            
                            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)
                                
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                        
                        
                        
                    })
                } else {
                    self.showErrorAlert("Login Fail", msg: "Please check your username and password")
                }
            } else {
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
            }
            
            
            
           })
            
            
        }else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and password")
        }
    }
    func showErrorAlert(title:String, msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}