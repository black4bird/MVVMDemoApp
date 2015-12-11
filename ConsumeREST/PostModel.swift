//
//  PostModel.swift
//  ConsumeREST
//
//  Created by LNKN on 11/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import Bond
class PostModel{
    var tagsObserve : Observable<[TagObject]> = Observable([])
    var imageId : String
    init(id: String){
        imageId = id
    }

    func refreshTagList()  {
        WebService.sharedInstance.queryForImageTag(imageId).then { (response)  in
            self.tagsObserve.next(response)
        }
    }
    
}