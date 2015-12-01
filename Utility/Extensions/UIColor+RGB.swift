//
//  UIColor+RGB.swift
//  Copyright (c) 2014 Massimiliano Bigatti. All rights reserved.
//

import Foundation
import UIKit

/**
    UIColor extension that add a whole bunch of utility functions like:

    - HTML/CSS RGB format conversion (i.e. 0x124672)
    - lighter color
    - darker color
    - color with modified brightness

 */
extension UIColor {
    
    
    convenience init(hexColorCode: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexColorCode.hasPrefix("#")
        {
            let index   = hexColorCode.startIndex.advancedBy(1)
            let hex     = hexColorCode.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                if hex.characters.count == 6
                {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                }
                else if hex.characters.count == 8
                {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                }
                else
                {
                    print("invalid hex code string, length should be 7 or 9", terminator: "")
                }
            }
            else
            {
                print("scan hex error")
            }
        }
        else
        {
            print("invalid hex code string, missing '#' as prefix", terminator: "")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    /**
        Construct a UIColor using an HTML/CSS RGB formatted value and an alpha value
    
        - parameter rgbValue: RGB value
        - parameter alpha: color alpha value
    
        - returns: an UIColor instance that represent the required color
     */
    class func colorWithRGB(rgbValue : UInt, alpha : CGFloat = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0xFF) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
        Returns a lighter color by the provided percentage
    
        - parameter lighting: percent percentage
        - returns: lighter UIColor
     */
    func lighterColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    
    /**
        Returns a darker color by the provided percentage
        
        - parameter darking: percent percentage
        - returns: darker UIColor
    */
    func darkerColor(percent : Double) -> UIColor {
        return colorWithBrightnessFactor(CGFloat(1 - percent));
    }
    
    /**
        Return a modified color using the brightness factor provided
    
        - parameter factor: brightness factor
        - returns: modified color
    */
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
    
    /* ====================================== Custom Methods For Application =================================== */
    
    func appBackgroundColor() -> UIColor{
       return UIColor(hexColorCode: "#ded0a4")
    }

    func appSignInButtonBgColor() -> UIColor{
        return UIColor(hexColorCode: "#628c00")
    }

    func appSignUpButtonBgColor() -> UIColor{
        return UIColor(hexColorCode: "#f5894e")
    }

}
