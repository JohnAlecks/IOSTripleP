//
//  NavigationMenuViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/20/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class NavigationMenuViewController: MenuViewController {
   
    // UI elements and UI functions
    @IBOutlet weak var userAva: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapViewIndicator: UIImageView!
    @IBOutlet weak var view1Indicator: UIImageView!
  
    override func viewDidLoad() {
            super.viewDidLoad()
            loadStyle()
        }
    
}

//MARK: UI Function
extension NavigationMenuViewController {
    
    @IBAction func mapViewPressed(_ sender: Any) {
        setIndicator(index: 0)
        
    }
    @IBAction func view1Pressed(_ sender: Any) {
        setIndicator(index: 1)
    }
    
    func setIndicator (index: Int){
        switch index {
        case 0:
            mapViewIndicator.backgroundColor = UIColor.red
            view1Indicator.backgroundColor = UIColor.clear
            DispatchQueue.main.async {
                guard let menuContainerViewController = self.menuContainerViewController else { return }
                menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[0])
                menuContainerViewController.hideMenu()
            }
            break
        case 1:
            DispatchQueue.main.async {
                guard let menuContainerViewController = self.menuContainerViewController else { return }
                menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[1])
                menuContainerViewController.hideMenu()
            }
            mapViewIndicator.backgroundColor = UIColor.clear
            view1Indicator.backgroundColor = UIColor.red
            break
        default: break
            // Do nothing
        }
        
    }
    func loadStyle () {
        userAva.clipsToBounds = true
        userAva.layer.borderWidth = 3.0
        userAva.layer.borderColor = UIColor.white.cgColor
        userAva.layer.cornerRadius = 0.5 * userAva.bounds.size.width
    }
}
