//
//  ViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/7/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func Checked(_ sender: UIButton) {
        print(Shared.share.fromLogin)
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

