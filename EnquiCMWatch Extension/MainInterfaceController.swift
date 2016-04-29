//
//  InterfaceController.swift
//  EnquiCMWatch Extension
//
//  Created by Enrique Melgarejo on 4/26/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import WatchKit
import Foundation


class MainInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    internal var sections: [Section] = []
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        setupTable()
    }
    
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
}

extension MainInterfaceController {
    
    internal func setupTable() {
        fetchData()
    }
    
    private func fetchData() {
        let infoCards = DatabaseManager.loadInformationArray()
        
        infoCards.forEach { object in
            if let dict = object as? NSDictionary {
                let section = Section(dictionary: dict)
                sections.append(section)
            }
        }
        table.setNumberOfRows(sections.count, withRowType: SectionTableController.identifier)
        for (index, data) in sections.enumerate() {
            guard let row = table.rowControllerAtIndex(index) as? SectionTableController else { return }
            row.name = data.title
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let section = sections[rowIndex]
        pushControllerWithName(DetailInterfaceController.identifier, context: section.cards)
    }
}

class Section {
    
    static let kSectionShortcutKey = "kSectionShortcutKey"
    var title : String = ""
    var cards : [Card] = []
    var isShortcut: Bool = false
    
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