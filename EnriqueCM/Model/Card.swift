//
//  Card.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import Foundation

let kVisitCardNotification = "kVisitCardNotification"

enum CardType: String {
    case Unknown, Personal = "personal", Detail = "detail", Project = "project"
}

class Card {
    
    var title       : String = ""
    let subtitle    : String?
    let imageName   : String?
    let about       : String?
    var type: CardType? = .Unknown
    let info        : AnyObject?
    var isVisitCard: Bool {
        get {
            return checkIfCardIsVisitCard(title)
        }
    }
    
    init(dictionary : NSDictionary) {
        title       = dictionary["title"]   as? String ?? ""
        subtitle    = dictionary["subtitle"]as? String
        imageName   = dictionary["image"]   as? String
        about       = dictionary["about"]   as? String
        info        = dictionary["info"]

        if let cardType = dictionary["type"] as? String {
            type = CardType.init(rawValue:cardType)
        }
    }
    
    func saveAsVisitCard() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(title, forKey: "visitCard")
        userDefaults.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(kVisitCardNotification, object: nil, userInfo: nil)
    }
    
    private func checkIfCardIsVisitCard(cardTitle: String) -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let titleVisitCard = userDefaults.stringForKey("visitCard") {
            if titleVisitCard == cardTitle {
                return true
            }
        } else {
            if cardTitle == "Enrique" {
                saveAsVisitCard()
            }
        }
        return false
    }
}