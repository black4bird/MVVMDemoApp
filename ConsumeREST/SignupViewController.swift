//
//  SignupViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 12/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation

import UIKit
import Cartography
import Bond
import CoreLocation

class SignupViewController: UIViewController {
    let backImageView = UIImageView(frame: CGRectMake(30,30,25,25))
    let signupButton = UIButton()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    //let firstnameTextField = UITextField()
    //let lastnameTextField = UITextField()
    let emailTextField = UITextField()
    let backgroundImageView = UIImageView(frame: UIScreen.mainScreen().bounds)
    let middleSpace = UIView()
    let appLabel = UILabel()
    var array = NSArray()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(appLabel)
        view.addSubview(middleSpace)
        view.addSubview(backImageView)
        middleSpace.addSubview(signupButton)
        middleSpace.addSubview(usernameTextField)
        middleSpace.addSubview(passwordTextField)
        middleSpace.addSubview(confirmPasswordTextField)
        middleSpace.addSubview(emailTextField)
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
        view.userInteractionEnabled = true
        
        constraintForSubviews()
        configureSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        backImageView.image = UIImage(named: "back-icon")
        backImageView.contentMode = .ScaleAspectFit
        backImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissView")
        backImageView.addGestureRecognizer(tapGesture)
    }
    
    func dismissView(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLayoutSubviews() {
        let width = CGFloat(2.0)
        for subview in middleSpace.subviews{
            let border = CALayer()
            border.borderColor = UIColor.darkGrayColor().CGColor
            border.frame = CGRect(x: 0, y: subview.frame.size.height - width, width: subview.frame.size.width, height: subview.frame.size.height)
            border.borderWidth = width
            subview.layer.addSublayer(border)
            subview.layer.masksToBounds = true
        }
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
            view2.height == 400
        }
        
    constrain(emailTextField,passwordTextField,confirmPasswordTextField,usernameTextField,signupButton){
            view1, view2, view3, view4, view5 in
            
            view1.left == (view1.superview?.left)! + 40
            view1.right == (view1.superview?.right)! - 40
            view1.height == 40
            view1.top == (view1.superview?.top)! + 40
            
            view2.right == view1.right
            view2.left == view1.left
            view2.height == 40
            view2.top == view1.bottom + 15
        
            view3.right == view1.right
            view3.left == view1.left
            view3.height == 40
            view3.top == view2.bottom + 15
        
            view4.top == view3.bottom + 20
            view4.left == view1.left
            view4.right == view1.right
            view4.height == 40
        
            view5.top == view4.bottom + 20
            view5.left == view1.left + 20
            view5.right == view1.right - 20
            view5.height == 40
        
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
        
        //signupButton.backgroundColor = UIColor.grayColor()
        signupButton.setTitle("Sign up", forState: .Normal)
        
        combineLatest(emailTextField.bnd_text, passwordTextField.bnd_text, confirmPasswordTextField.bnd_text, usernameTextField.bnd_text).map { (email, pass, confirmPass, username) -> Bool in
            return email!.validEmail() && pass!.validPassword() && username!.validString() && (pass==confirmPass)
        }.bindTo(signupButton.bnd_userInteractionEnabled)
        
        signupButton.bnd_userInteractionEnabled.map { (valid) -> UIColor in
            return !valid ? UIColor.grayColor() : UIColor.appColor()
        }.bindTo(signupButton.bnd_backgroundColor)
        
        signupButton.bnd_tap.observe{
            WebService.sharedInstance.queryForCreateUser(self.usernameTextField.text!,
                password: self.passwordTextField.text!,
                email: self.emailTextField.text!,completionHandler: {self.dismissView()})
                
        }
        emailTextField.backgroundColor = UIColor.whiteColor()
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .EmailAddress
        
        passwordTextField.backgroundColor = UIColor.whiteColor()
        passwordTextField.placeholder = "Password"
        passwordTextField.secureTextEntry = true
        
        confirmPasswordTextField.backgroundColor = UIColor.whiteColor()
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.secureTextEntry = true
        
        usernameTextField.backgroundColor = UIColor.whiteColor()
        usernameTextField.placeholder = "Username"

    }
}