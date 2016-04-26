//
//  InterfaceController.swift
//  EnquiCMWatch Extension
//
//  Created by Rafael Machado on 4/26/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    let names = ["A", "B", "C", "D", "E"]
    
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

extension InterfaceController {
    internal func setupTable() {
        table.setNumberOfRows(names.count, withRowType: TableController.identifier)
        fetchData()
    }
    
    private func fetchData() {
        for (index, data) in names.enumerate() {
            guard let row = table.rowControllerAtIndex(index) as? TableController else { return }
            row.name = data
        }
    }
}