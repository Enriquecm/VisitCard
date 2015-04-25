//
//  DatabaseManager.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

private let _ManagerSharedInstance = CardsManager()

class CardsManager {
    
    internal var arrayInfo = [[String : AnyObject]]()
    internal var arrayEducation = [[String : String]]()
    
    class func loadCards() -> [String : [Card]]
    {
        var cards = [String : [Card]]()
        
        var infoCards = transformArrayInCards(DatabaseManager.personalDetails())
        if !infoCards.isEmpty {
            cards["Personal Details"] = infoCards
        }
        
        var educCards = transformArrayInCards(DatabaseManager.education())
        if !educCards.isEmpty {
            cards["Education"] = educCards
                        cards["Education2"] = educCards
                        cards["Education3"] = educCards
                        cards["Education4"] = educCards
                        cards["Education5"] = educCards
        }
        
        var xpCards = transformArrayInCards(DatabaseManager.experience())
        if !xpCards.isEmpty {
            cards["Experience"] = xpCards
        }
        
        return cards
    }
    
    private class func transformArrayInCards(arrayOfInfo : [NSDictionary]) -> [Card]
    {
        var cards = [Card]()
        for dict in arrayOfInfo {
            cards.append(Card(dictionary: dict))
        }
        
        return cards
    }
}
