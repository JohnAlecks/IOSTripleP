//
//  ISeeViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/14/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit

class ISeeViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var policeButton: UIButton!
    var delegate: ViewControllerProtocols?
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStyle()
        // Do any additional setup after loading the view.
    }
    @IBAction func PolicePressed(_ sender: UIButton) {
        self.delegate?.pinPoint()  
        dismiss(animated: true, completion: nil)
    }
    
    func loadStyle() {
        closeButton.clipsToBounds = true
        policeButton.clipsToBounds = true
        popUpView.clipsToBounds = true
        closeButton.layer.cornerRadius = 20
        popUpView.layer.cornerRadius = 20
        policeButton.layer.cornerRadius = 16
    }
 
}
