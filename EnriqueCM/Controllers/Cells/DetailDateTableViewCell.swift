//
//  DetailDateTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 21/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class DetailDateTableViewCell: UITableViewCell {
    
    var id          : Int?
    var title       : String?
    var date        : String?
    
    private var m_type : String?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func initWithDictionary(dictionary : NSDictionary) {
        guard let info = dictionary["info"] as? NSDictionary else { return }
        
        m_type      = dictionary["type"]as? String
        id          = info["id"]        as? Int
        title       = info["title"]     as? String
        date        = info["date"]      as? String
        
        titleLabel.text = title
        dateLabel.text  = date
    }
}
