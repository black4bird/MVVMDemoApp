//
//  WebService.swift
//  ConsumeREST
//
//  Created by LNKN on 24/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import Alamofire
import Cloudinary
import PromiseKit
import Bond
import ObjectMapper
import SwiftyJSON
class WebService:NSObject, CLUploaderDelegate{
    let kBaseUrl = "http://localhost:3000/api/v1"
    //Cloudinary constant 
    let kCloudName = "ddakp60er"
    let kApiKey = "287623843915194"
    let kSecret = "7zETPKxP4m-R7EsVyPi5P_8vvTA"
    
    static let sharedInstance = WebService()
    private override init(){}
    
    func queryForTable() -> Promise<ObservableArray<ImageObject>>{
        return Promise {
            fulfill, reject in
            Alamofire.request(.GET, kBaseUrl).responseJSON{
                response in
                
            }
        }
    
    }
    
    func loadHome() -> Promise<[ImageObject]>{
        return Promise {
            fulfill, reject in
            let url = kBaseUrl + "/image"
            Alamofire.request(.GET, url).responseJSON{
                response in
                if (response.result.error == nil){
                    let feeds = Mapper<ImageObject>().mapArray(response.result.value as! [AnyObject])
                    fulfill(feeds!)
                }
                else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func queryForUserExist(username: String, password: String, completionHandler:(success: Bool)->Void){
        let url = kBaseUrl + "/user/find"
        Alamofire.request(.POST, url, parameters:["username": username,"password": password],encoding: .JSON).responseJSON { (response) -> Void in
            if (response.result.error == nil){
                let json = JSON(response.result.value!)
                let status = json[0]["exists"].boolValue
                completionHandler(success: status)
            }
            else{
                print(response.result.error!)
            }
        }
    }
    
    func queryForCreateData(entity: ImageObject){
        let url = kBaseUrl + "/image"
        Alamofire.request(.POST, url, parameters: ["url" : entity.getUrl(),
            "timestamp" : entity.getTimeStamp(),
            "width" : entity.getWidth(),
            "height" : entity.getHeight()])
    }
    
    func uploadImage(image: UIImage){
        let imageData = UIImagePNGRepresentation(image)
        let request = NSMutableURLRequest(URL: NSURL(string: kCloudName)!)
        let session = NSURLSession.sharedSession()
        
        request.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        request.HTTPShouldHandleCookies = false
        request.timeoutInterval = 60
        request.HTTPMethod = "POST"
        
        let boundary = "-----------fasdfqe5235%!#%"
        let contenType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contenType, forHTTPHeaderField: "Content-Type")

        let body = NSMutableData()
        
        if (imageData != nil){
    
            body.appendData(("--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(("Content-Disposition: form-data; name=myfile; filename=imageName.jpg\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(("Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData!)
            body.appendData(("\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)

        }
        
        body.appendData(("--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        let postLength = "\(body.length)"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        let task = session.dataTaskWithRequest(request)
        task.resume()
    }
    
    func cloudinaryUploadImage(image: UIImage){
        let publicId = Utility.sharedInstance.uniqueId()
        let cloudinary_url = "cloudinary://\(kApiKey):\(kSecret)@\(kCloudName)"
        let cloudinary = CLCloudinary(url: cloudinary_url)
        let imageData = UIImagePNGRepresentation(image)! as NSData
        let uploader = CLUploader(cloudinary, delegate: self)
        uploader.upload(imageData, options: ["public_id" : publicId, "sync": false])
    }
    
    //Cloudinary Delegate 
    @objc func uploaderProgress(bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, context: AnyObject!) {
       // print("On going")
    }
    
    @objc func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!) {

//        let entity = ImageObject()
//        entity.url = result["url"] as! String? ?? ""
//        entity.timestamp = result["created_at"] as! String? ?? ""
//        entity.width = (result["width"] as! Double?)!
//        entity.height = (result["height"] as! Double?)!
//        
//        queryForCreateData(entity)
//        queryForTable()
    }
    
    
    @objc func uploaderError(result: String!, code: Int, context: AnyObject!) {
        print(result)
    }
}