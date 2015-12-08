//
//  TagGalleryModel.swift
//  ConsumeREST
//
//  Created by LNKN on 08/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import Bond
import PromiseKit

class TagGalleryModel: GalleryProtocol{
    var imagesObserve : Observable<[ImageObject]> = Observable([])
    var name: String?
    init(name: String){
        self.name = name
    }
    
    func refreshImageArray()  {
        WebService.sharedInstance.queryImageByTag(name!).then { (response)  in
            self.imagesObserve.next(response)
        }
    }
    func getImageArray()-> Promise<[ImageObject]>{
        return WebService.sharedInstance.queryImageByTag(name!)
    }

}


class CityGalleryModel: GalleryProtocol{
    var imagesObserve : Observable<[ImageObject]> = Observable([])
    var name: String?
    init(name: String){
        self.name = name
    }
    func refreshImageArray()  {
        WebService.sharedInstance.queryImageByCity(name!).then { (response)  in
            self.imagesObserve.next(response)
        }
    }
    func getImageArray()-> Promise<[ImageObject]>{
        return WebService.sharedInstance.queryImageByCity(name!)
    }
    
}

class UsernameGalleryModel: GalleryProtocol{
    var imagesObserve : Observable<[ImageObject]> = Observable([])
    var name: String?
    init(name: String){
        self.name = name
    }
    
    func refreshImageArray()  {
        WebService.sharedInstance.queryImageByUsername(name!).then { (response)  in
            self.imagesObserve.next(response)
        }
    }
    func getImageArray()-> Promise<[ImageObject]>{
        return WebService.sharedInstance.queryImageByUsername(name!)
    }
    
}

