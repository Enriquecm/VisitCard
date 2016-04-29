//
//  DetailInterfaceController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/27/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class DetailInterfaceController: WKInterfaceController {
    static let identifier = "DetailInterfaceController"
    @IBOutlet weak var table: WKInterfaceTable!
    private var cards: [Card] = []
    private var session : WCSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let cards = context as? [Card] {
            self.cards = cards
            setupTable()

        }
    }
    
    override func willActivate() {
        super.willActivate()
        if(WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session?.activateSession()
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func openAppPressed() {
        //TODO:
    }
    
    @IBAction func shareVisitCardPressed() {
        //TODO:
    }
}

extension DetailInterfaceController {
    
    internal func setupTable() {
        table.setNumberOfRows(cards.count, withRowType: DetailTableController.identifier)
        for (index, data) in cards.enumerate() {
            guard let row = table.rowControllerAtIndex(index) as? DetailTableController else { return }
            row.title  = data.title ?? ""
            row.detail = data.subtitle ?? ""
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let selectedCard = cards[rowIndex]
        sendCardToApplication(selectedCard)
    }
    
    private func sendCardToApplication(card: Card) {
        WCSession.defaultSession()
        .sendMessage(["Card": card], replyHandler: nil, errorHandler: nil)
    }
}
