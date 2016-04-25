//
//  Utils.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 25/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    /// This method return a UIView with gradient.
    ///
    /// :param: frame frame.
    /// :param: colorA starts on top.
    /// :param: colorB starts on below.
    /// :param: rotation It is between 0 and 1. Move anti-clockwise.
    class func gradientView(frame: CGRect, colorA: UIColor, colorB: UIColor, rotation: Float) -> UIView {
        let view = UIView(frame: frame)
        
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [colorA.CGColor, colorB.CGColor]
        view.layer.insertSublayer(layer, atIndex: 0)
        
        let a = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.75)/2))),2))
        let b = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.0)/2))),2))
        let c = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.25)/2))),2))
        let d = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.5)/2))),2))
        
        layer.startPoint = CGPointMake(a, b)
        layer.endPoint = CGPointMake(c, d)
        
        return view
    }
    
    
    /// This method return a attributed text.
    /// The corresponding character at the same position of the
    /// parameter 'usingName' is underlined.
    ///
    /// :param: text Text to compare.
    /// :param: position position of caracter to underscore.
    /// :param: usingName Reference text.
//    class func underlineCharacter(text: String, position: Int, usingName: String) -> NSAttributedString
//    {
//        let uppercaseText:NSString = text.lowercaseString
//        let char:String = usingName.uppercaseString[position]
//        let range: NSRange = uppercaseText.rangeOfString(char)
//        
//        var attributeText = NSMutableAttributedString(string: uppercaseText as String)
//        attributeText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
//        
//        return attributeText
//    }
}
