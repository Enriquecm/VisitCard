//
//  InformationManager.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/24/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import Foundation

class InformationManager {

    static let sharedManager = InformationManager()
    
    class func loadInformation() -> [Section] {
        
        var sections: [Section] = []
        let infoCards = DatabaseManager.loadInformationArray()
        
        infoCards.forEach { object in
            if let dict = object as? NSDictionary {
                let section = Section(dictionary: dict)
                sections.append(section)
            }
        }
        
        return sections
    }
}