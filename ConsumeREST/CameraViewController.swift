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
import Bond
class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let session = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput?
    var takePictureButton = UIButton()
    let imagePicker : UIImagePickerController! = UIImagePickerController()

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        //presentCamera()
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takePictureButton.frame = CGRectMake(AppConstant.appWidth/2 - 40 , AppConstant.appWidth*3/4 + 80, 120,120)
        takePictureButton.layer.cornerRadius = 60
        takePictureButton.layer.borderWidth = 5
        takePictureButton.layer.borderColor = UIColor.blueColor().CGColor
        takePictureButton.backgroundColor = UIColor.blackColor()
        takePictureButton.bnd_tap.observe {
            if let videoConnection = self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
                videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
                self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                    if (sampleBuffer != nil) {
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        let dataProvider = CGDataProviderCreateWithCFData(imageData)
                        let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                        let currentCameraInput: AVCaptureInput = self.session.inputs[0] as! AVCaptureInput
                        self.session.removeInput(currentCameraInput)
                        let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                        let createPostInfoVc = CreatePostInfoViewController(image: image)
                        self.navigationController?.pushViewController(createPostInfoVc, animated: true)
                        
                    }
                })
            }
        }
        view.addSubview(takePictureButton)
        session.sessionPreset = AVCaptureSessionPresetiFrame1280x720
        let devices = AVCaptureDevice.devices()
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        for device in devices{
            if (device.hasMediaType(AVMediaTypeVideo)){
                if (device.position == AVCaptureDevicePosition.Back){
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        if captureDevice != nil {
            beginSession()
        }
        

        
    }
    
    func beginSession(){
    
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
            session.addOutput(stillImageOutput)
        } catch {
            print(error)
        }
        let cameraPreview = UIView(frame: CGRectMake(0,0,AppConstant.appWidth,AppConstant.appWidth*3/4))
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        let bounds = cameraPreview.layer.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        previewLayer.bounds = bounds
        cameraPreview.layer.addSublayer(previewLayer)
        cameraPreview.backgroundColor = UIColor.redColor()
        view.addSubview(cameraPreview)
        session.startRunning()
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

        let createPostInfoVc = CreatePostInfoViewController(image: chosenImage)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.pushViewController(createPostInfoVc, animated: true)
        
//        WebService.sharedInstance.cloudinaryUploadImage(chosenImage)
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.tabBarController?.selectedIndex = 0
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