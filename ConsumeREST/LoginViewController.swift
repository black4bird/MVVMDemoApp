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
    let signupButton = UIButton()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let backgroundImageView = UIImageView(frame: UIScreen.mainScreen().bounds)
    let middleSpace = UIView()
    let appLabel = UILabel()
    var array = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(appLabel)
        view.addSubview(middleSpace)

        middleSpace.addSubview(signupButton)
        middleSpace.addSubview(loginButton)
        middleSpace.addSubview(usernameTextField)
        middleSpace.addSubview(passwordTextField)
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
        view.userInteractionEnabled = true

        constraintForSubviews()
        configureSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        let border1 = CALayer()
        let width = CGFloat(2.0)
        border1.borderColor = UIColor.darkGrayColor().CGColor
        border1.frame = CGRect(x: 0, y: self.usernameTextField.frame.size.height - width, width: self.usernameTextField.frame.size.width, height: self.usernameTextField.frame.size.height)
        border1.borderWidth = width
        self.usernameTextField.layer.addSublayer(border1)
        self.usernameTextField.layer.masksToBounds = true
        
        let border2 = CALayer()
        border2.borderColor = UIColor.darkGrayColor().CGColor
        border2.frame = CGRect(x: 0, y: self.passwordTextField.frame.size.height - width, width: self.passwordTextField.frame.size.width, height: self.passwordTextField.frame.size.height)
        border2.borderWidth = width
        self.passwordTextField.layer.addSublayer(border2)
        self.passwordTextField.layer.masksToBounds = true
    }
    
    func constraintForSubviews(){
        constrain(appLabel,middleSpace){
            view1, view2 in
            
            view1.left == (view1.superview?.left)! + 40
            view1.right == (view1.superview?.right)! - 40
            view1.top == (view1.superview?.top)! + 20
            view1.height == 75
            
            view2.left == view1.left
            view2.right == view1.right
            view2.top == view1.bottom
            view2.height == 300
        }
        
        constrain(usernameTextField,passwordTextField,loginButton, signupButton){
            view1, view2, view3, view4 in
            
            view1.left == (view1.superview?.left)! + 40
            view1.right == (view1.superview?.right)! - 40
            view1.height == 40
            view1.top == (view1.superview?.top)! + 40
            
            view2.right == view1.right
            view2.left == view1.left
            view2.height == 40
            view2.top == view1.bottom + 15
            
            view3.top == view2.bottom + 40
            view3.left == view1.left + 20
            view3.right == view1.right - 20
            view3.height == 40
            
            view4.top == view3.bottom + 20
            view4.left == view3.left
            view4.right == view3.right
            view4.height == 40
        
        }
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }
    func configureSubviews(){
        backgroundImageView.image = UIImage(named: "background_normal")
        backgroundImageView.contentMode = .ScaleToFill
        
        appLabel.textAlignment = .Center
        
     
        let attStr1 = NSMutableAttributedString(string: "Photo", attributes: [NSFontAttributeName:UIFont.appRegularFontBold(24.0)])
        let attStr2 = NSMutableAttributedString(string: "Sharing", attributes: [NSFontAttributeName:UIFont.appRegularFontItalic(24.0)])
        attStr1.appendAttributedString(attStr2)
        appLabel.attributedText = attStr1
        
        middleSpace.backgroundColor = UIColor.whiteColor()
        middleSpace.alpha = 0.8
        

        loginButton.setTitle("Login", forState: .Normal)
        
        signupButton.backgroundColor = UIColor.appColor()
        signupButton.setTitle("Sign up", forState: .Normal)
        
        combineLatest(usernameTextField.bnd_text, passwordTextField.bnd_text).map { (username, password) -> Bool in
            return username!.validEmail() && password!.validPassword()
        }.bindTo(loginButton.bnd_userInteractionEnabled)
        
        loginButton.bnd_userInteractionEnabled.map { (valid) -> UIColor in
            return valid ? UIColor.appColor() : UIColor.grayColor()
        }.bindTo(loginButton.bnd_backgroundColor)
        
        
        loginButton.bnd_tap.observe{
            WebService.sharedInstance.queryForUserExist(self.usernameTextField.text!, password: self.passwordTextField.text!, completionHandler: { (success) -> Void in
                if(success){
                    
                    let rootViewVc = RootViewController()
                    self.navigationController!.pushViewController(rootViewVc, animated: true)

                }
                else{
                    let alertVC = UIAlertController(
                        title: "Invalid login",
                        message: "Sorry, wrong email or password",
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
        
        signupButton.bnd_tap.observe {
            let vc = SignupViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        usernameTextField.backgroundColor = UIColor.whiteColor()
        usernameTextField.keyboardType = .EmailAddress
        usernameTextField.placeholder = "Email"
        
        passwordTextField.backgroundColor = UIColor.whiteColor()
       
        passwordTextField.placeholder = "Password"
        passwordTextField.secureTextEntry = true
    }
}