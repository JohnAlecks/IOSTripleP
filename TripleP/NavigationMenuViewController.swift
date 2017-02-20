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

    @IBOutlet weak var userAva: UIImageView!
    let kItemsCount = 2
    let kCellReuseIdentifier = "Cell"
    let cats = ["Map View", "Login View"]
    @IBOutlet weak var tableView: UITableView!
    
    func loadStyle () {
        userAva.clipsToBounds = true
        userAva.layer.borderWidth = 3.0
        userAva.layer.borderColor = UIColor.white.cgColor
        userAva.layer.cornerRadius = 0.5 * userAva.bounds.size.width
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            loadStyle() 
            tableView.delegate = self
            tableView.dataSource = self
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
}


    extension NavigationMenuViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return kItemsCount
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseIdentifier, for: indexPath) as UITableViewCell
            cell.textLabel?.text = cats[indexPath.row]
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            DispatchQueue.main.async {
                guard let menuContainerViewController = self.menuContainerViewController else { return }
                menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[indexPath.row])
                menuContainerViewController.hideMenu()
            }
        }
        
    }




