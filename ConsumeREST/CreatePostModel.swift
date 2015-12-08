//
//  CreatePostModel.swift
//  ConsumeREST
//
//  Created by LNKN on 05/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation

import Bond
import PromiseKit
class CreatePostModel {
    var tagsObserve : Observable<[TagObject]> = Observable([])
    
    init(){
        
    }
    func refreshTagArray()  {
        WebService.sharedInstance.queryForAllTag().then { (response)  in
            self.tagsObserve.next(response)
        }
    }
    func getTagArray()-> Promise<[TagObject]>{
        return WebService.sharedInstance.queryForAllTag()
    }
    
}