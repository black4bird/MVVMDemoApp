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
    var imageId : Int
    init(id: Int){
        imageId = id
    }
    var tagsObserve : Observable<[String]> = Observable([])
    
}