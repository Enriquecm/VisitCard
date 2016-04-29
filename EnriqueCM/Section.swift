//
//  Section.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/24/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class Section {
    
    static let kSectionShortcutKey = "kSectionShortcutKey" 
    var title : String = ""
    var cards : [Card] = []
    var isShortcut: Bool {
        get {
            return checkIfSectionIsShortcut(title)
        }
        set {
            self.isShortcut = newValue
        }
    }
    
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

extension Section {
    
    internal func checkIfSectionIsShortcut(sectionTitle: String) -> Bool {
        
        if let shortcuts = UIApplication.sharedApplication().shortcutItems {
            for shortcut in shortcuts {
                if shortcut.localizedTitle == sectionTitle {
                    return true
                }
            }
        }
        
        return false
    }
}