//
//  LoginViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/7/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import InteractiveSideMenu
import SkyFloatingLabelTextField

class LoginViewController: MenuItemContentViewController {
    
    // UI elements and variables
    @IBOutlet weak var FBLogin: FBSDKLoginButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    var passwordText: SkyFloatingLabelTextField! = nil
    var phoneText: SkyFloatingLabelTextField! = nil
    @IBAction func SignInPressed(_ sender: UIButton) {
        var userInfo = [String:String]()
        userInfo["type"] = "SignIn"
        userInfo["phone"] = phoneText.text
        userInfo["password"] = passwordText.text
        Shared.share.fromLogin = userInfo as NSDictionary!
        dismiss(animated: true, completion: nil)
        
    }
    
    //basic functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        passwordText.delegate = self
        initFacebook()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        guard Shared.share.fromLogin != nil else {
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UI functions
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
        loadStyle()
        self.hideKeyboardWhenTappedAround()
    }
    
    func loadStyle() {
        phoneText = Tools.initSkyText(placeHolder: "Enter your phone number", title: "Phone number",keyboardType: UIKeyboardType.phonePad, isSecureContent: false, Rect: CGRect.init(x: 16, y: 208, width: 288, height: 43))
        passwordText = Tools.initSkyText(placeHolder: "Enter your password", title: "Password", keyboardType: nil, isSecureContent: true, Rect: CGRect.init(x: 16, y: 280, width: 288, height: 43))
        passwordText.returnKeyType = .done
        self.view.addSubview(phoneText)
        self.view.addSubview(passwordText)
    }

}

// MARK: Facebook Implement
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
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                let resultDic = result as? NSDictionary
                print("Result: \(resultDic)")
                let returnDic: NSMutableDictionary = resultDic?.mutableCopy() as! NSMutableDictionary
                returnDic["type"]="facebook"
                Shared.share.fromLogin = returnDic
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
