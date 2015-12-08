//
//  Extension.swift
//  ConsumeREST
//
//  Created by LNKN on 01/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation

import UIKit
//MARK: String
extension String{
    
}


//MARK: Font
extension UIFont {
    class func appRegularFont(fontSize : CGFloat)-> UIFont{
        return UIFont(name: "CenturyGothic", size: fontSize)!
    }
    
    class func appRegularFontBold(fontSize : CGFloat)-> UIFont{
        return UIFont(name: "CenturyGothic-Bold", size: fontSize)!
    }
    
    class func appRegularFontItalic(fontSize : CGFloat)-> UIFont{
        return UIFont(name: "CenturyGothic-Italic", size: fontSize)!
    }
    

}
