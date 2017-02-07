//
//  LoginViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/7/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var FBLogin: FBSDKLoginButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        var userInfo = [String:String]()
        userInfo["phone"] = phoneText.text
        userInfo["password"] = passwordText.text
        Shared.share.fromLogin = userInfo as NSDictionary!
        dismiss(animated: true, completion: nil)
        
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        passwordText.delegate = self
        initFacebook()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func initUI() {
        signInButton.clipsToBounds = true
        signInButton.layer.masksToBounds = true
        signInButton.layer.isOpaque = false
        signInButton.layer.cornerRadius = 15
        
        signUpButton.clipsToBounds = true
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.isOpaque = false
        signUpButton.layer.cornerRadius = 15
        
        FBLogin.clipsToBounds = true
        FBLogin.layer.masksToBounds = true
        FBLogin.layer.isOpaque = false
        FBLogin.layer.cornerRadius = 6
               
    }
}


extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func initFacebook() {
        if FBSDKAccessToken.current() != nil {
            print ("user already login")
            self.returnUserData()
        } else {
            FBLogin.readPermissions = ["public_profile","email","user_friends"]
            FBLogin.delegate = self
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            
        } else if result.isCancelled {
            print ("User canceled")
        }
        else {
            if result.grantedPermissions.contains("public_profile") {
                if result.grantedPermissions.contains("email") {
                    if result.grantedPermissions.contains("user_friends") {
                        self.returnUserData()
                    }
                }
                
            }
            self.returnUserData()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let resultDic = result as? NSDictionary
                print("\(resultDic)")
                print("ID: \(resultDic?["id"] as! NSString)")
                print("Username: \(resultDic?["name"] as! NSString)")
                Shared.share.fromLogin = resultDic
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    
}
