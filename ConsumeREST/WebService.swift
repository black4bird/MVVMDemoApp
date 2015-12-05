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
import CryptoSwift

class WebService:NSObject, CLUploaderDelegate{
    let kBaseUrl = "http://192.168.70.137:3000/api/v1"
    //Cloudinary constant 
    let kCloudName = "ddakp60er"
    let kApiKey = "287623843915194"
    let kSecret = "7zETPKxP4m-R7EsVyPi5P_8vvTA"
    
    static let sharedInstance = WebService()
    private override init(){}

        //MARK:Query for images
    func loadHome() -> Promise<[ImageObject]>{
        return Promise {
            fulfill, reject in
            let url = kBaseUrl + "/image"
            Alamofire.request(.GET, url).responseJSON{
                response in
                if (response.result.error == nil){

                    if let feeds = Mapper<ImageObject>().mapArray(response.result.value as! [AnyObject]){
                        fulfill(feeds)
                    }
                }
                else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func queryForCreateImage(imageUrl: String, timestamp: String){
        let url = kBaseUrl + "/image"
        Alamofire.request(.POST, url, parameters: ["url" : imageUrl,
            "userid" : AppData.sharedInstance.getUserId(),
            "timestamp" : timestamp,
            "lat": AppData.sharedInstance.getUserLat(),
            "lon": AppData.sharedInstance.getUserLon(),
            "city": AppData.sharedInstance.getUserCity()]
        )
    }
    
    //MARK: Query for users
    func queryForUserExist(username: String, password: String, completionHandler:(success: Bool)->Void){
        let url = kBaseUrl + "/user/find"
        Alamofire.request(.POST, url, parameters:["username": username,"password": password.sha1()],encoding: .JSON).responseJSON { (response) -> Void in
            if (response.result.error == nil){
                let json = JSON(response.result.value!)
                let status = json[0]["exists"].boolValue
                if (status){
                    self.queryForUser(username, pass: password)

                }
                completionHandler(success: status)
            }
            else{
                print(response.result.error!)
            }
        }
    }
    
    func queryForUser(username: String, pass: String) -> Promise<UserObject>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/login"
            Alamofire.request(.POST, url, parameters:["username": username,"password": pass.sha1()],encoding: .JSON).responseJSON{
                response in
                if (response.result.error == nil){
                   if let user = Mapper<UserObject>().mapArray(response.result.value as! [AnyObject])
                   {
    
                        AppData.sharedInstance.setUserId(user[0].getId())
                        print(user[0].getId())
                        fulfill(user[0])
                    }
                    
                }
                else{

                    reject(response.result.error!)
                }

            }
        }
    }
    
 
    
    
    //MARK: Query for tag
    func queryForAllTag()->Promise<[TagObject]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/tag"
            Alamofire.request(.GET, url).responseJSON{
                response in
                if (response.result.error == nil){
                    
                    if let tags = Mapper<TagObject>().mapArray(response.result.value as! [AnyObject]){
                        fulfill(tags)
                    }
                }
                else{
                    reject(response.result.error!)
                }
            }
        }
    }

    
    func queryForImageTag(){
    
    }
    
    
    //MARK: Upload image
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
        let publicId = Utility.sharedInstance.uniqueId().sha1()
        let cloudinary_url = "cloudinary://\(kApiKey):\(kSecret)@\(kCloudName)"
        let cloudinary = CLCloudinary(url: cloudinary_url)
        let imageData = UIImagePNGRepresentation(image)! as NSData
        let uploader = CLUploader(cloudinary, delegate: self)
        uploader.upload(imageData, options: ["public_id" : publicId, "sync": false])
    }
    
    //MARK: Cloudinary Delegate 
    @objc func uploaderProgress(bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, context: AnyObject!) {
       // print("On going")
    }
    
    @objc func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!) {

       let url = result["url"] as! String
        let timestamp = result["created_at"] as! String
        queryForCreateImage(url, timestamp: timestamp)
        
    }
    
    
    @objc func uploaderError(result: String!, code: Int, context: AnyObject!) {
        print(result)
    }
}