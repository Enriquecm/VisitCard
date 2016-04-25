//
//  UIColorExtensions.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/24/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init (hex: String) {
        if !hex.isHexColor() {
            self.init(red: 1, green: 1, blue: 0, alpha: CGFloat(1))
            return
        }
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
