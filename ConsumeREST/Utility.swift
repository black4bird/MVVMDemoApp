//
//  Utility.swift
//  ConsumeREST
//
//  Created by LNKN on 27/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
class Utility {
    static let sharedInstance = Utility()
    private init(){}
    
    func uniqueId() -> String{
       let uuid = NSUUID().UUIDString
        return uuid
    }

}