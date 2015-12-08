//
//  RootViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController{

    let paddingX  = AppConstant.appWidth/3
    let paddingY = AppConstant.appHeight/4
    let mainVc1 = HomeViewController(style: .Grouped)
    let mainVc2 = CameraViewController()
    let mainVc3 = SearchViewController()
    let backgroundView = UIImageView(frame: UIScreen.mainScreen().bounds)
    let galleryCell = HomeCellView(frame: CGRectMake(AppConstant.appWidth/4,AppConstant.appHeight/4,AppConstant.appWidth/2,AppConstant.appHeight/8))
    let cameraCell = HomeCellView(frame: CGRectMake(AppConstant.appWidth/4,AppConstant.appHeight*3/8 + 20 ,AppConstant.appWidth/2,AppConstant.appHeight/8))
    let searchCell = HomeCellView(frame: CGRectMake(AppConstant.appWidth/4,AppConstant.appHeight*4/8 + 40,AppConstant.appWidth/2,AppConstant.appHeight/8))
    override func viewDidLoad() {
        view.addSubview(backgroundView)
        view.addSubview(galleryCell)
        view.addSubview(cameraCell)
        view.addSubview(searchCell)
        
        
//        let blurEffect = UIBlurEffect(style: .Light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]

        backgroundView.image = UIImage(named: "background_normal")
        backgroundView.contentMode = .ScaleToFill
        backgroundView.layer.insertSublayer(gradient, atIndex: 0)
//        backgroundView.addSubview(blurEffectView)
        
        galleryCell.layer.cornerRadius = galleryCell.frame.height/2
        cameraCell.layer.cornerRadius = cameraCell.frame.height/2
        searchCell.layer.cornerRadius = searchCell.frame.height/2
        
        galleryCell.labelView.text = "Gallery"
        cameraCell.labelView.text = "Camera"
        searchCell.labelView.text = "Search"
        
        let cameraGestureRecognizer = UITapGestureRecognizer(target: self, action: "goToCamera")
        cameraCell.addGestureRecognizer(cameraGestureRecognizer)
        
        let homeGestureRecognizer = UITapGestureRecognizer(target: self, action: "goToHome")
        galleryCell.addGestureRecognizer(homeGestureRecognizer)
        
        let searchGestureRecognizer = UITapGestureRecognizer(target: self, action: "goToSearch")
        searchCell.addGestureRecognizer(searchGestureRecognizer)
//        let navVc1 = UINavigationController(rootViewController: mainVc1)
//        let navVc2 = UINavigationController(rootViewController: mainVc2)
//        let controllers = [navVc1,navVc2]
//        let firstImg = UIImage(named: "home-icon")
//        let secondImg = UIImage(named: "plus-icon")
//        navVc1.tabBarItem = UITabBarItem(title: "HOME", image: firstImg, tag: 1)
//        navVc2.tabBarItem = UITabBarItem(title: "CAMERA", image: secondImg, tag: 2)
//        self.viewControllers = controllers
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    func goToCamera(){
        self.navigationController?.pushViewController(mainVc2, animated: true)
    }
    
    func goToHome(){
        self.navigationController?.pushViewController(mainVc1, animated: true)
    }
    
    func goToSearch(){
        self.navigationController?.pushViewController(mainVc3, animated: true)
    }
    
}