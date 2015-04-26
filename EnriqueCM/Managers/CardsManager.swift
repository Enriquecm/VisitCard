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
    
    ///
    /// Load all cards from json file
    /// This method
    ///
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
        }
        
        var xpCards = transformArrayInCards(DatabaseManager.experience())
        if !xpCards.isEmpty {
            cards["Experience"] = xpCards
        }
        
        var projectCards = transformArrayInCards(DatabaseManager.projects())
        if !projectCards.isEmpty {
            cards["Projects"] = projectCards
        }
        
        var skillsCards = transformArrayInCards(DatabaseManager.skills())
        if !skillsCards.isEmpty {
            cards["Skills"] = skillsCards
        }
        
        var qualitiesCards = transformArrayInCards(DatabaseManager.qualities())
        if !qualitiesCards.isEmpty {
            cards["qualities"] = qualitiesCards
        }
        
        var volunteeringCards = transformArrayInCards(DatabaseManager.volunteering())
        if !volunteeringCards.isEmpty {
            cards["Volunteering"] = volunteeringCards
        }
        
        var honorCards = transformArrayInCards(DatabaseManager.honor())
        if !honorCards.isEmpty {
            cards["Honor and awards"] = honorCards
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
