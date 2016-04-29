//
//  DetailTableController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/27/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import WatchKit

class DetailTableController: NSObject {
    static let identifier = "DetailTableControllerIdentifier"
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!
    
    var title: String = "" {
        didSet {
            titleLabel.setText(title)
        }
    }
    
    var detail: String = "" {
        didSet {
            descriptionLabel.setText(detail)
        }
    }
    
}
