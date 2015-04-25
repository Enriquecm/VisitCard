//
//  DetailTitleSubtitleImageTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 21/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class DetailTitleSubtitleImageTableViewCell: UITableViewCell {
    
    var id          : Int?
    var title       : String?
    var subtitle    : String?
    var imageName   : String?
    
    private var m_type : String?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!

    override func initWithDictionary(dictionary : NSDictionary) {
        var info : NSDictionary = dictionary["info"] as! NSDictionary
        
        m_type      = dictionary["type"]as? String
        id          = info["id"]        as? Int
        title       = info["title"]     as? String
        subtitle    = info["subtitle"]  as? String
        imageName   = info["image"]     as? String
    
        titleLabel.text     = title
        subtitleLabel.text  = subtitle
        if imageName != nil && imageName != "" {
            logoImageView.image = UIImage(named: imageName!)
        }
    }
}
