//
//  ViewController.swift
//  TripleP
//
//  Created by John Whisker on 2/7/17.
//  Copyright © 2017 John Whisker. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import ALLoadingView
import InteractiveSideMenu


class ViewController: MenuContainerViewController {
    
   
    
    // Basic of View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
         initMenuBar()
        
    }
    override func menuTransitionOptionsBuilder() -> TransitionOptionsBuilder? {
        return TransitionOptionsBuilder() { builder in
            builder.duration = 0.5
            builder.contentScale = 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
       
        guard Shared.share.fromLogin != nil
            else {
            ALLoadingView.manager.showLoadingView(ofType: .basic)
            performSegue(withIdentifier: "LoginView", sender: nil)
            ALLoadingView.manager.hideLoadingView()
            return
        }
      
    }
    
}

//MARK: Implement MenuSideBar
extension ViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func initMenuBar() {
        menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
    
        contentViewControllers = contentControllers()
    
        selectContentViewController(contentViewControllers.first!)

    
    }
       private func contentControllers() -> [MenuItemContentViewController] {
        var contentList = [MenuItemContentViewController]()
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "Map") as! MenuItemContentViewController)
        contentList.append(self.storyboard?.instantiateViewController(withIdentifier: "View1") as! MenuItemContentViewController)
        return contentList
    }

}
