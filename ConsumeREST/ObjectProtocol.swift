//
//  Protocol.swift
//  ConsumeREST
//
//  Created by LNKN on 30/11/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation

protocol ImageProtocol{
    func getId() -> String
    func getUrl() -> String
    func getTimeStamp() -> String
    func getDescription() -> String
    func getCity() -> String
//    func getWidth() -> Double
//    func getHeight() -> Double
}

protocol UserProtocol{
    func getId() -> Int
    func getUsername() -> String
    func getEmail() -> String

}

protocol TagProtocol{
    func getName() -> String
}