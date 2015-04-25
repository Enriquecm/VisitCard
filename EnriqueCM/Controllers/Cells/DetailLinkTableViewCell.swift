//
//  DetailLinkTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 21/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class DetailLinkTableViewCell: UITableViewCell {
    
    var id      : Int?
    var title   : String?
    var link    : String?
    
    private var m_type : String?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func initWithDictionary(dictionary : NSDictionary) {
        var info : NSDictionary = dictionary["info"] as! NSDictionary
        
        m_type      = dictionary["type"]as? String
        id          = info["id"]        as? Int
        title       = info["title"]     as? String
        link        = info["link"]      as? String
        
        titleLabel.text = title
        linkButton.setTitle(link, forState: .Normal)
    }
    
    @IBAction func linkClicked(sender: UIButton) {
        let application = UIApplication.sharedApplication()
        let url = NSURL(string: sender.titleForState(.Normal)!)
        if application.canOpenURL(url!) {
            application.openURL(url!)
        } else {
            //TODO: can't open the URL
        }
    }
}
