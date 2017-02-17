//
//  SignUpViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/13/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate{

   
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
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
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        retypePassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
