//
//  Section.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/24/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import Foundation

class Section {
    var title : String = ""
    var cards : [Card] = []
    
    convenience init(dictionary : NSDictionary) {
        self.init()
        title = dictionary["title"] as? String ?? ""
        
        if let cardsInfo = dictionary["items"] as? [NSDictionary] {
            for dict in cardsInfo {
                cards.append(Card(dictionary: dict))
            }
        }
    }
}