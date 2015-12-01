//
//  HomeTableViewCell.swift
//  ConsumeREST
//
//  Created by LNKN on 28/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewCell : UITableViewCell {
    let imgView = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(imgView)
   //     imgView.frame = CGRectMake(0,10,self.superview!.frame.width, self.superview!.frame.height - 20)
        imgView.contentMode = .ScaleAspectFill
        imgView.backgroundColor = UIColor.redColor()
        imgView.clipsToBounds = true
        print(imageView!.frame)
        //imgView.image = UIImage(named: "image-sample2")
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}