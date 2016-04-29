//
//  NSNotificationExtensions.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/26/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
    func setObserver(observer: AnyObject, selector: Selector, name: String?, object: AnyObject?) {
        removeObserver(observer, name: name, object: object)
        addObserver(observer, selector: selector, name: name, object: object)
    }
}