//
//  DetailAdjustableTextTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 21/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class DetailAdjustableTextTableViewCell: UITableViewCell {
    
    var id          : Int?
    var title       : String?
    var mainText    : String?
    
    private var m_type : String?
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var mainTextLabel : UILabel! //TODO: Create adjustable label
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func initWithDictionary(dictionary : NSDictionary) {
        var info : NSDictionary = dictionary["info"] as! NSDictionary
        
        m_type      = dictionary["type"]as? String
        id          = info["id"]        as? Int
        title       = info["title"]     as? String
        mainText    = info["text"]      as? String
        
        titleLabel.text     = title
        mainTextLabel.text   = mainText
    }
}
