//
//  SignUpViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/13/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // UI elements and variables
    @IBOutlet weak var errorLabel: UILabel!
    var firstNameText: SkyFloatingLabelTextField! = nil
    var lastName: SkyFloatingLabelTextField! = nil
    var phoneNumber: SkyFloatingLabelTextField! = nil
    var password: SkyFloatingLabelTextField! = nil
    var retypePassword: SkyFloatingLabelTextField! = nil
    
    // basic Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

//MARK: Others functions
extension SignUpViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func checkRetypePassword(sender: UITextField) {
        if (password.text != ""){
            password.errorMessage = ""
            if (retypePassword.text != password.text) {
                retypePassword.errorMessage = "Password do not match"
            } else {
                retypePassword.errorMessage = ""
            }
        } else {
            password.errorMessage = "Input your password"
        }
    }


}

//MARK: UI functions
extension SignUpViewController {
    
    func initUI() {
        firstNameText = Tools.initSkyText(placeHolder: "Enter you first name", title: "First name", keyboardType: nil, isSecureContent: false, Rect: CGRect.init(x: 16, y: 155, width: 288, height: 43))
        lastName = Tools.initSkyText(placeHolder: "Enter you last name", title: "Last name", keyboardType: nil, isSecureContent: false, Rect: CGRect.init(x: 16, y: 212, width: 288, height: 43))
        phoneNumber = Tools.initSkyText(placeHolder: "Enter your phone number", title: "Phone number", keyboardType: UIKeyboardType.phonePad, isSecureContent: false, Rect: CGRect.init(x: 16, y: 269, width: 288, height: 43))
        password = Tools.initSkyText(placeHolder: "Enter your password", title: "Password", keyboardType: nil, isSecureContent: true, Rect: CGRect.init(x: 16, y: 326, width: 288, height: 43))
        retypePassword = Tools.initSkyText(placeHolder: "Retype your password", title: "Retype Password", keyboardType: nil, isSecureContent: true, Rect: CGRect.init(x: 16, y: 383, width: 288, height: 43))
        firstNameText.delegate = self
        lastName.delegate = self
        phoneNumber.delegate = self
        password.delegate = self
        retypePassword.delegate = self
        retypePassword.errorColor = UIColor.red
        retypePassword.addTarget(self, action: #selector(checkRetypePassword(sender:)), for: UIControlEvents.editingChanged)
        self.view.addSubview(firstNameText)
        self.view.addSubview(lastName)
        self.view.addSubview(phoneNumber)
        self.view.addSubview(phoneNumber)
        self.view.addSubview(password)
        self.view.addSubview(retypePassword)
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if (retypePassword.isEditing || password.isEditing) {
            if let keyboardSize = (notification.userInfo?   [UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func pressSignUp(_ sender: UIButton) {
        guard password.text == retypePassword.text else {
            errorLabel.text = "Retype password does not match password you've type"
            errorLabel.textColor = .red
            return
        }
        errorLabel.text = ""
        var DataSend = [String:AnyObject]()
        DataSend["type"] = "SignUp" as AnyObject
        DataSend["first_name"] = firstNameText.text as AnyObject
        DataSend["last_name"] = lastName.text as AnyObject
        DataSend["phone_number"] = phoneNumber.text as AnyObject
        DataSend["password"] = password.text as AnyObject
        Shared.share.fromLogin = DataSend as NSDictionary!
        self.dismiss(animated: true, completion: nil)
    }
}
