//
//  CameraViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let session = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    let imagePicker : UIImagePickerController! = UIImagePickerController()
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppConstant.appWidth, height: AppConstant.appHeight - 49))

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presentCamera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)

    }
    
    func presentCamera(){
        if (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil){
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {

        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage
        WebService.sharedInstance.cloudinaryUploadImage(chosenImage)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }

    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
}