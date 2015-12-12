//
//  AppEntity.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import ObjectMapper

class ImageObject: Mappable, ImageProtocol{
    private var id: Int?
    private var userId : String?
    private var url : String?
    private var timestamp : String?
    //private var width : Double?
    //private var height : Double?
    private var description: String?
    private var lat: Double? = 0
    private var lon: Double? = 0
    private var city: String? = "Undefined"

    private var location : Location?
    required init?(_ map: Map) {
       
    }
    
    struct Location{
        var lat: Double? = 0
        var lon: Double? = 0
        var city: String? = "Undefined"
    }
    
    func mapping(map: Map) {
        id  <- map["id"]
        url <- map["url"]
        timestamp <- map["timestamp"]
      
        description <- map["description"]
        userId <- map["user_id"]
        lat <- map["location"]["lat"]
        lon <- map["location"]["lon"]
        city <- map["location"]["city"]
        //  width <- map["width"]
        //  height <- map["height"]
//        location!.lat <- map["lat"]
//        location!.lon <- map["lon"]
//        location!.city <- map["city"]
    }
    
    func setDescription(desc: String?){
        self.description = desc
    }
    
    func getJSON() -> String{
        return Mapper().toJSONString(self, prettyPrint: true)!
    }
    
    
    func getId() -> String {
        return String(self.id!)
    }
    
    func getUserId() -> String{
        return self.userId!;
    }
    func getUrl() -> String {
        return self.url!
    }
    
    func getTimeStamp() -> String {
        return self.timestamp!
    }
    
    func getDescription() -> String {
        return self.description!
    }
//    func getWidth() -> Double {
//        return self.width!
//    }
//    
//    func getHeight() -> Double {
//        return self.height!
//    }
    func getLat() -> Double {
        return self.lat!
    }
    func getLon() -> Double {
        return self.lon!
    }
    func getCity() -> String {
        return self.city!
    }
    
    func getLocation() -> Location{
        return self.location!
    }
}

class UserObject: Mappable, UserProtocol{
    private var id : Int?
    private var username: String?
    private var email: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        email <- map["email"]
    }
    
    func getId() -> String {
        return String(self.id!)
    }
    
    func getUsername() -> String {
        return self.username!
    }
    
    func getEmail() -> String {
        return self.email!
    }
}

class TagObject: Mappable, TagProtocol{
    
    private var name: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]

    }
    
    
    func getName() -> String {
        return self.name!
    }
}

