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
    private var id: String?
    private var url : String?
    private var timestamp : String?
    private var width : Double?
    private var height : Double?
    
    required init?(_ map: Map) {
       
    }
    
    func mapping(map: Map) {
        id  <- map["id"]
        url <- map["url"]
        timestamp <- map["create_at"]
        width <- map["width"]
        height <- map["height"]
    }
    
    func getJSON() -> String{
        return Mapper().toJSONString(self, prettyPrint: true)!
    }
    
    func getId() -> String {
        return self.id!
    }

    func getUrl() -> String {
        return self.url!
    }
    
    func getTimeStamp() -> String {
        return self.timestamp!
    }
    
    func getWidth() -> Double {
        return self.width!
    }
    
    func getHeight() -> Double {
        return self.height!
    }
}

class UserObject: Mappable, UserProtocol{
    private var id : String?
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
        return self.id!
    }
    
    func getUsername() -> String {
        return self.username!
    }
    
    func getEmail() -> String {
        return self.email!
    }
}

