//
//  HomeCellView.swift
//  ConsumeREST
//
//  Created by LNKN on 07/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit

class HomeCellView: UIView{
    let logoView = UIImageView()
    let labelView = UILabel()
    override init(frame:CGRect){
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews(){
        self.addSubview(labelView)
        self.addSubview(logoView)

        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.userInteractionEnabled = true
        logoView.frame = CGRectMake(0,0,self.frame.height,self.frame.height)
        labelView.frame = CGRectMake(0,0,self.frame.width-20,self.frame.height)
        
        logoView.layer.cornerRadius = logoView.frame.height/2
        logoView.backgroundColor = UIColor.redColor()
        
        labelView.font = UIFont.appRegularFont(self.frame.width/8)
        labelView.textAlignment = .Right
        labelView.textColor = UIColor.whiteColor()
        labelView.adjustsFontSizeToFitWidth = true
        labelView.minimumScaleFactor = 0.2

        
    }
}