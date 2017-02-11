//
//  ViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/7/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBAction func Checked(_ sender: UIButton) {
        print(Shared.share.fromLogin)
        
        let parameters: [String: AnyObject] = [
                "id":Shared.share.fromLogin["id"] as AnyObject,
                "username": Shared.share.fromLogin["name"] as AnyObject,
                "email":"yourmother@yourfather.com" as AnyObject
        ]
        Alamofire.request("http://api.triplep-backend.dev/v1/users", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            print(response)
        }
        
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        guard Shared.share.fromLogin != nil else {
            performSegue(withIdentifier: "LoginView", sender: nil)
            return
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

