//
//  Card.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import Foundation

class Card {
    let id          : Int?
    let title       : String?
    let subtitle    : String?
    let imageName   : String?
    let about       : String?
    let type        : String?
    let info        : AnyObject?
    
    init(dictionary : NSDictionary) {
        id          = dictionary["id"]      as? Int
        title       = dictionary["title"]   as? String
        subtitle    = dictionary["subtitle"]as? String
        imageName   = dictionary["image"]   as? String
        about       = dictionary["about"]   as? String
        type        = dictionary["type"]    as? String
        info        = dictionary["info"]
    }
}