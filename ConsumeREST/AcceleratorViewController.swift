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
class AcceleratorViewController : UIViewController {
    let xLabel = UILabel()
    let yLabel = UILabel()
    let zLabel = UILabel()
    let manager = CMMotionManager()
    let queue = NSOperationQueue.mainQueue()
    let imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(xLabel)
        view.addSubview(yLabel)
        view.addSubview(zLabel)
        view.addSubview(imageView)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image-sample")
        setupAccelerometer()
        //constraintForSubviews()
        //configureSubviews()
    }
    
    func setupAccelerometer(){
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
           
            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (data, error) -> Void in
                let rotation = atan2(data!.gravity.x, data!.gravity.y) - M_PI
                self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
            })
        }
    }
    
    func constraintForSubviews(){
        constrain(xLabel,yLabel,zLabel){
            view1, view2, view3 in
            
            view1.left == (view1.superview?.left)! + 40
            view1.top == (view1.superview?.top)! + 40
            view1.width == 100
            view1.height == 20
            
            view2.left == view1.left
            view2.top == view1.bottom + 40
            view2.width == view1.width
            view2.height == view1.height
            
            view3.left == view2.left
            view3.top == view2.bottom + 40
            view3.width == view2.width
            view3.height == view2.height
            
        }
    }
    
    func configureSubviews(){
        xLabel.text = "x-axis: "
        yLabel.text = "y-axis: "
        zLabel.text = "z-axis: "
    }
}