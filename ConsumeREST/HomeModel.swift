//
//  AppModel.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import Bond
import PromiseKit
class HomeModel {
    var feedsObserve : Observable<[ImageObject]> = Observable([])

    init(){
        
    }
    func refreshHome()  {
        WebService.sharedInstance.loadHome().then { (response)  in
            self.feedsObserve.next(response)
        }
    }
    func getHomeFeeds()-> Promise<[ImageObject]>{
            return WebService.sharedInstance.loadHome()
    }
    
}