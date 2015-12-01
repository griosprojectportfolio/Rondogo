//
//  CommonUtilities.swift
//  Rondogo
//
//  Created by GrepRuby3 on 20/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class CommonUtilities: NSObject {
    
//    class func isValidEmail(testStr:String) -> Bool {
//        println("validate calendar: \(testStr)")
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//        
//        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) {
//            return emailTest.evaluateWithObject(testStr)
//        }
//        return false
//    }


class func isValidEmailAddress(email:String) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
  let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  let result = emailTest.evaluateWithObject(email)
  return result
 }

}