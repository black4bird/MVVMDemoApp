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
    
    let mainVc1 = MainViewController()
    let mainVc2 = CameraViewController()
    
    override func viewDidLoad() {
        let controllers = [mainVc1, mainVc2]
        let firstImg = UIImage(named: "home-icon")
        let secondImg = UIImage(named: "plus-icon")
        mainVc1.tabBarItem = UITabBarItem(title: "HOME", image: firstImg, tag: 1)
        mainVc2.tabBarItem = UITabBarItem(title: "CAMERA", image: secondImg, tag: 2)
        self.viewControllers = controllers
    }

    
}