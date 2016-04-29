//
//  ShortcutManager.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/25/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

enum ShortcutType: String {
    case ShareAll = "com.choynowski.EnriqueCM.share-all", ViewProfile = "com.choynowski.EnriqueCM.view-profile", ViewProjects = "com.choynowski.EnriqueCM.view-projects"
}

protocol PerformShortcutAction {
    
    func shareAllInformation()

    func viewSectionWithTitle(title: String)
}

class ShortcutManager {
    
    var shareAllSection: Section?
    var viewProfileSection: Section?
    var viewProjectsSection: Section?
    
    class func removeShortcutForSection(section: Section) {
        if var shortcuts = UIApplication.sharedApplication().shortcutItems {
            var indexToRemove: Int?
            
            for shortcut in shortcuts {
                if shortcut.localizedTitle == section.title {
                    indexToRemove = shortcuts.indexOf(shortcut)
                }
            }
            
            if indexToRemove != nil {
                shortcuts.removeAtIndex(indexToRemove!)
                UIApplication.sharedApplication().shortcutItems = shortcuts
            }
        }
    }
    
    class func createShortcutForSection(section: Section, type: ShortcutType) {
        
        let title = section.title
        let subtitle = "" //getSubtitleForType(type)
        let icon = getShortcutIconForType(type)
//        let icon = getShortcutIconFromCard(section.cards.first)
        
        if var shortcuts = UIApplication.sharedApplication().shortcutItems {
            let filtered = shortcuts.filter({ $0.type == type.rawValue })
            if !filtered.isEmpty,
                let shortcut = filtered.first,
                let indexToRemove = shortcuts.indexOf(shortcut){

                shortcuts.removeAtIndex(indexToRemove)
            }
            
            let shortcut = UIApplicationShortcutItem(type: type.rawValue, localizedTitle: title, localizedSubtitle: subtitle, icon: icon , userInfo: [Section.kSectionShortcutKey : section.title])
            shortcuts.append(shortcut)
            UIApplication.sharedApplication().shortcutItems = shortcuts
        }
    }
    
    private class func saveSectionForType(section:Section, type: ShortcutType) {
//        switch type {
//        case .ShareAll:
////            shareAllSection = section
//        case .ViewProfile:
////            viewProfileSection = section
//        case .ViewProjects:
////            viewProjectsSection = section
//        }
    }
    
    private class func getTitleForType(type: ShortcutType) -> String {
        switch type {
        case .ShareAll:
            return "Share"
        case .ViewProfile:
            return "Personal details"
        case .ViewProjects:
            return "Projects"
        }
    }
    
    private class func getSubtitleForType(type: ShortcutType) -> String {
        switch type {
        case .ShareAll:
            return "All information"
        case .ViewProfile:
            return ""
        case .ViewProjects:
            return ""
        }
    }
    
    private class func getShortcutIconForType(type: ShortcutType) -> UIApplicationShortcutIcon {
        switch type {
        case .ShareAll:
            return UIApplicationShortcutIcon(type: .Share)
        case .ViewProfile:
            return UIApplicationShortcutIcon(type: .Contact)
        case .ViewProjects:
            return UIApplicationShortcutIcon(type: .Confirmation)
        }
    }
    
    private class func getShortcutIconFromCard(card: Card?) -> UIApplicationShortcutIcon? {
        if card != nil,
            let imageName = card?.imageName as String? {
            
            let imageIcon = UIApplicationShortcutIcon(templateImageName: imageName)
            return imageIcon
        } else {
            return nil
        }
    }
}