//
//  MainViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 01/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Bond
import CoreLocation

class LoginViewController: UIViewController {
    let loginButton = UIButton()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    var array = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        constraintForSubviews()
        configureSubviews()
    }
    
    func constraintForSubviews(){
        constrain(usernameTextField,passwordTextField,loginButton){
            view1, view2, view3 in
            
            view1.left == (view1.superview?.left)! + 40
            view1.right == (view1.superview?.right)! - 40
            view1.height == 40
            view1.centerY == (view1.superview?.centerY)! - 20
            
            view2.right == view1.right
            view2.left == view1.left
            view2.height == 40
            view2.top == view1.bottom + 15
            
            view3.top == view2.bottom + 20
            view3.left == view1.left + 20
            view3.right == view1.right - 20
            view3.height == 40
        
        }
    }
    
    func configureSubviews(){
        loginButton.backgroundColor = UIColor.redColor()
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.bnd_tap.observe{
            WebService.sharedInstance.queryForUserExist(self.usernameTextField.text!, password: self.passwordTextField.text!, completionHandler: { (success) -> Void in
                if(success){
                    
                    let rootViewVc = RootViewController()
                    self.navigationController!.pushViewController(rootViewVc, animated: true)
                }
                else{
                    let alertVC = UIAlertController(
                        title: "Invalid login",
                        message: "Sorry, wrong username or password",
                        preferredStyle: .Alert)
                    let okAction = UIAlertAction(
                        title: "OK",
                        style:.Default,
                        handler: nil)
                    alertVC.addAction(okAction)
                    self.presentViewController(
                        alertVC,
                        animated: true,
                        completion: nil)
                }
            })

        }
        usernameTextField.backgroundColor = UIColor.grayColor()
        
        passwordTextField.backgroundColor = UIColor.grayColor()
        passwordTextField.secureTextEntry = true
    }
}