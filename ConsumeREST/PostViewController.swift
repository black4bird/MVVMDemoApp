//
//  ThermometerViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Bond
import CoreMotion
import SDWebImage

class PostViewController : UIViewController {
    let imageView = UIImageView()
    let descriptionCell = PostCellView()
    let timestampCell = PostCellView()
    let tagCell = PostCellView()
    let locationCell = PostCellView()
    var entity : ImageObject?

    init(imageEntity: ImageObject){
        super.init(nibName: nil, bundle: nil)
        entity = imageEntity
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(imageView)
        view.addSubview(descriptionCell)
        view.addSubview(timestampCell)
        view.addSubview(tagCell)
        view.addSubview(locationCell)
        
        var posY :CGFloat = 0
        let padding : CGFloat = 20
        imageView.frame = CGRectMake(0,0,AppConstant.appWidth,AppConstant.appWidth*3/4)
        posY += imageView.frame.height + padding
        imageView.sd_setImageWithURL(NSURL(string: entity!.getUrl()))
        
        descriptionCell.frame = CGRectMake(0,posY,AppConstant.appWidth-20,75)
        descriptionCell.imageView.image = UIImage(named: "description-icon")
        descriptionCell.setText(entity!.getDescription())
        
        posY += descriptionCell.frame.height + padding
        timestampCell.frame = CGRectMake(0,posY,AppConstant.appWidth,50)
        timestampCell.imageView.image = UIImage(named: "clock-icon")
        timestampCell.setText(entity!.getTimeStamp())
        
        posY += timestampCell.frame.height + padding
        tagCell.frame = CGRectMake(0,posY,AppConstant.appWidth,50)
        tagCell.imageView.image = UIImage(named: "tag-icon")
        
        posY += tagCell.frame.height + padding
        locationCell.frame = CGRectMake(0,posY,AppConstant.appWidth,50)
        locationCell.imageView.image = UIImage(named: "location-icon")
        locationCell.setText(entity!.getCity())
    }
}