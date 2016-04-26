//
//  TableController.swift
//  EnriqueCM
//
//  Created by Rafael Machado on 4/26/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import WatchKit

class TableController: NSObject {
    static let identifier = "TableControllerIdentifier"
    var name: String = "" {
        didSet {
            nameLabel.setText(name)
        }
    }
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
}
