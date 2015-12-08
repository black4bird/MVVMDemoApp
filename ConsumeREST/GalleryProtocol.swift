//
//  GalleryProtocol.swift
//  ConsumeREST
//
//  Created by LNKN on 08/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import PromiseKit

protocol GalleryProtocol{
    func refreshImageArray()
    func getImageArray()->Promise<[ImageObject]>
}