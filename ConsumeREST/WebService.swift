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
    //let kBaseUrl = "http://192.168.70.137:3000/api/v1"
    let kBaseUrl = "http://107.170.63.224:3000/api/v1"
    //Cloudinary constant
    private let kCloudName = "ddakp60er"
    private let kApiKey = "287623843915194"
    private let kSecret = "7zETPKxP4m-R7EsVyPi5P_8vvTA"
    
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
    
    func queryForCreateImage(image: UIImage, description: String, tagArray: NSMutableArray){
        let url = kBaseUrl + "/image"
        let publicId = Utility.sharedInstance.uniqueId().sha1()
        let cloudinary_url = "cloudinary://\(kApiKey):\(kSecret)@\(kCloudName)"
        let cloudinary = CLCloudinary(url: cloudinary_url)
        let imageData = UIImagePNGRepresentation(image)! as NSData
        let uploader = CLUploader(cloudinary, delegate: self)
        uploader.upload(imageData, options: ["public_id" : publicId, "sync": false], withCompletion: { (success, error, code, context) -> Void in
            let imageUrl = success["url"]
            let timestamp = success["created_at"]
            Alamofire.request(.POST, url, parameters: ["url" : imageUrl!,
                "userid" : AppData.sharedInstance.getUserId(),
                "timestamp" : timestamp!,
                "lat": AppData.sharedInstance.getUserLat(),
                "lon": AppData.sharedInstance.getUserLon(),
                "city": AppData.sharedInstance.getUserCity(),
                "descriptionText":description,
                "tagarray":tagArray]
            )

            }, andProgress: nil)
        

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
            let url = kBaseUrl + "/search/tag"
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
    
    //MARK: Query for all city
    func queryForAllCity()->Promise<[String]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/search/city"
            Alamofire.request(.GET, url).responseJSON{
                response in
                if (response.result.error == nil){
                    var cities :[String] = []
                    for el in response.result.value as! [AnyObject]{
                        cities.append(el["city"] as! String)
                    }
                    fulfill(cities)
                }
                else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func queryForAllUsername()->Promise<[String]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/search/user"
            Alamofire.request(.GET, url).responseJSON{
                response in
                if (response.result.error == nil){
                    var users :[String] = []
                    for el in response.result.value as! [AnyObject]{
                        users.append(el["username"] as! String)
                    }
                    fulfill(users)
                }
                else{
                    reject(response.result.error!)
                }
            }
        }
    }
    
    func queryForAllTagname()->Promise<[String]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/search/tag"
            Alamofire.request(.GET, url).responseJSON{
                response in
                if (response.result.error == nil){
                    var tagnames :[String] = []
                    for el in response.result.value as! [AnyObject]{
                        tagnames.append(el["name"] as! String)
                    }
                    fulfill(tagnames)
                }
                else{
                    reject(response.result.error!)
                }
            }
        }
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
    
//    func cloudinaryUploadImage(image: UIImage){
//        let publicId = Utility.sharedInstance.uniqueId().sha1()
//        let cloudinary_url = "cloudinary://\(kApiKey):\(kSecret)@\(kCloudName)"
//        let cloudinary = CLCloudinary(url: cloudinary_url)
//        let imageData = UIImagePNGRepresentation(image)! as NSData
//        let uploader = CLUploader(cloudinary, delegate: self)
//
//        uploader.upload(imageData, options: ["public_id" : publicId, "sync": false], withCompletion: { (success, error, code, context) -> Void in
//            print(success)
//            }, andProgress: nil)
//
//    }
    
    //MARK: Search
    func queryImageByTag(tagname: String)->Promise<[ImageObject]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/image/search/tag/" + tagname
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
    
    func queryImageByUsername(username: String)->Promise<[ImageObject]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/image/search/user/" + username
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
    
    func queryImageByCity(city: String)->Promise<[ImageObject]>{
        return Promise{
            fulfill, reject in
            let url = kBaseUrl + "/image/search/city/" + city
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
    
    //MARK: Testing shit
    func testUploadArray(){
        let url = kBaseUrl + "/image"
        let array : [String] = ["hilarious","fun","sunny","terrible"]
        let imgid = 15
        let str = "yooo"
        Alamofire.request(.POST, url, parameters: ["url" : "hlhl",
            "userid" : AppData.sharedInstance.getUserId(),
            "timestamp" : "24-24-212",
            "lat": AppData.sharedInstance.getUserLat(),
            "lon": AppData.sharedInstance.getUserLon(),
            "city": AppData.sharedInstance.getUserCity(),
            "tagarray":array]
        )


    }
}