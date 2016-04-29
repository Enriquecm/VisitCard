//
//  TableController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/26/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import WatchKit

class SectionTableController: NSObject {
    static let identifier = "SectionTableControllerIdentifier"
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    
    var name: String = "" {
        didSet {
            nameLabel.setText(name)
        }
    }
}
