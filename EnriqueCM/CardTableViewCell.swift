//
//  CardTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

protocol CardTableViewCellDelegate {
    func didSelectCardTableViewCell(card: Card, atIndexPath: NSIndexPath)
}

class CardTableViewCell: UITableViewCell {

    var card: Card? = nil
    var indexPath: NSIndexPath?
    var delegate: CardTableViewCellDelegate?
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var cardImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var aboutSummaryLabel: UILabel!
    @IBOutlet weak var imageMiniCard: UIImageView!
    
    @IBOutlet weak var buttonFake: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
    }

    func initWithCart(_card : Card, atIndexPath: NSIndexPath) {
        card = _card
        indexPath = atIndexPath
        
        titleLabel.text         = _card.title
        subtitleLabel.text      = _card.subtitle
        aboutSummaryLabel.text  = _card.about
        
        imageMiniCard.hidden    = !_card.isVisitCard
        
        if let photoName = _card.imageName {
            if (!photoName.isEmpty) {
                cardImageView.image = UIImage(named: photoName)
            } else {
                cardImageView.image = nil
            }
        }
    }
    
    @IBAction func testeFakeButton(sender: AnyObject) {
        print(sender)
    }
    
    @IBAction func fakeButtonPressed(sender: AnyObject) {
        if let cardS = card as Card?,
            let index = indexPath as NSIndexPath? {
            delegate?.didSelectCardTableViewCell(cardS, atIndexPath: index)
        }
    }
}
