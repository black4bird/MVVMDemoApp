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
    func timestampToFullDateString()->String{
        var newString = self.stringByReplacingOccurrencesOfString("T", withString: " at ")
        newString = newString.stringByReplacingOccurrencesOfString("Z", withString: "")
        var dateSubstr = newString.substringToIndex(self.startIndex.advancedBy(10))
        var toArray = dateSubstr.componentsSeparatedByString("-")
        toArray = toArray.reverse()
        dateSubstr = toArray[0]+"-"+toArray[1]+"-"+toArray[2]
        return newString.stringByReplacingCharactersInRange(Range<Index>(start: newString.startIndex, end: newString.startIndex.advancedBy(10)), withString: dateSubstr)
        
    }
    
    func validPassword()->Bool{
        return self.characters.count > 5
    }
    
    func validEmail()->Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func validString()->Bool{
        return self.characters.count > 0
    }
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

//MARK: Color
extension UIColor{
    class func appColor()->UIColor{
        return UIColor(red: 27/255, green: 137/255, blue: 244/255,alpha: 1.0)
    }
}
