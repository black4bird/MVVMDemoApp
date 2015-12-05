//
//  RootViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UITabBarController{
    
    let mainVc1 = HomeViewController(style: .Grouped)
    let mainVc2 = CameraViewController()
    
    override func viewDidLoad() {
        let navVc1 = UINavigationController(rootViewController: mainVc1)
        let navVc2 = UINavigationController(rootViewController: mainVc2)
        let controllers = [navVc1,navVc2]
        let firstImg = UIImage(named: "home-icon")
        let secondImg = UIImage(named: "plus-icon")
        navVc1.tabBarItem = UITabBarItem(title: "HOME", image: firstImg, tag: 1)
        navVc2.tabBarItem = UITabBarItem(title: "CAMERA", image: secondImg, tag: 2)
        self.viewControllers = controllers
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
}