//
//  MainViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 24/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Bond

class MainViewController: UIViewController {
    let createButton = UIButton()
    let uploadButton = UIButton()
    let deleteButton = UIButton()
    let idTextField = UITextField()
    let nameTextField = UITextField()
    var array = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createButton)
        view.addSubview(uploadButton)
        view.addSubview(deleteButton)
        view.addSubview(idTextField)
        view.addSubview(nameTextField)
        constraintForSubviews()
        configureSubviews()
    }
    
    func constraintForSubviews(){
        constrain(createButton,uploadButton,deleteButton,idTextField,nameTextField){
            view1, view2, view3, view4, view5 in
            
            view1.left == (view1.superview?.left)! + 40
            view1.width == 70
            view1.height == 40
            view1.centerY == (view1.superview?.centerY)! - 10
            
            view2.right == (view2.superview?.right)! - 40
            view2.width == 100
            view2.height == 40
            view2.centerY == (view1.superview?.centerY)! - 10
            
            view3.top == view1.bottom + 15
            view3.left == view1.left
            view3.width == 70
            view3.height == 40
            
            view4.bottom == view1.top - 15
            view4.left == (view4.superview?.left)! + 10
            view4.width == 140
            view4.height == 40
            
            view5.bottom == view1.top - 15
            view5.left == view4.right + 15
            view5.width == 140
            view5.height == 40
        }
    }
    
    func configureSubviews(){
        createButton.backgroundColor = UIColor.redColor()
        createButton.setTitle("Create", forState: .Normal)
        createButton.bnd_tap.observe{
            //WebService.sharedInstance.queryForTable()
            let chosenImage = UIImage(named: "image-sample")
            WebService.sharedInstance.cloudinaryUploadImage(chosenImage!)
            

          // WebService.sharedInstance.queryForCreateData(entity)
        }
        
        
        
        deleteButton.backgroundColor = UIColor.redColor()
        deleteButton.setTitle("Get", forState: .Normal)
        deleteButton.bnd_tap.observe{
//            WebService.sharedInstance.queryForTable()
         //   let array = WebService.sharedInstance.loadHome().value
            
            //WebService.sharedInstance.queryForCreateData("lnkn", param2: "abcd")
        }
        
        uploadButton.backgroundColor = UIColor.redColor()
        uploadButton.setTitle("UPLOAD", forState: .Normal)
        
        idTextField.backgroundColor = UIColor.grayColor()
        nameTextField.backgroundColor = UIColor.grayColor()
    }
}