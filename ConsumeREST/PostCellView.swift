//
//  PostCellView.swift
//  ConsumeREST
//
//  Created by LNKN on 10/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Cartography
class PostCellView: UIView {
    let imageView = UIImageView()
    let labelView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(imageView)
        self.addSubview(labelView)
        
        constrain(imageView,labelView){
            view1, view2 in
            
            view1.top == view1.superview!.top
            view1.left == view1.superview!.left + 30
            view1.width == 30
            view1.height == 30
            
            view2.left == view1.right + 30
            view2.right == view2.superview!.right - 30
            view2.top == view2.superview!.top
            view2.height == 75
            
        }
        //self.layoutIfNeeded()
        
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        
    
        labelView.lineBreakMode = .ByTruncatingTail
        labelView.numberOfLines = 0
        labelView.font = UIFont.appRegularFont(14)


    }
    
    func setText(text: String){
        labelView.text=text
        labelView.sizeToFit()
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.labelView.frame.height+30)
    }
}