//
//  SearchModel.swift
//  ConsumeREST
//
//  Created by LNKN on 08/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import Bond
import PromiseKit
class SearchModel {
    var tagsObserve : Observable<[String]> = Observable([])
    var cityObserve: Observable<[String]> = Observable([])
    var usernameObserve : Observable<[String]> = Observable([])
    init(){
        
    }
    func refreshAllTag()  {
        WebService.sharedInstance.queryForAllTagname().then { (response)  in
            self.tagsObserve.next(response)
        }
    }
    func getAllTag()-> Promise<[TagObject]>{
        return WebService.sharedInstance.queryForAllTag()
    }
    func refreshAllCity()  {
        WebService.sharedInstance.queryForAllCity().then { (response)  in
            self.cityObserve.next(response)
        }
    }
    func getAllCity()-> Promise<[String]>{
        return WebService.sharedInstance.queryForAllCity()
    }
    func refreshAllUsername()  {
        WebService.sharedInstance.queryForAllUsername().then { (response)  in
            self.usernameObserve.next(response)
        }
    }
    func getAllTag()-> Promise<[String]>{
        return WebService.sharedInstance.queryForAllUsername()
    }
    
}
