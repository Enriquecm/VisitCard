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
    
    override func initWithDictionary(dictionary : NSDictionary) {
        guard let info = dictionary["info"] as? NSDictionary else { return }
        
        m_type      = dictionary["type"]as? String
        id          = info["id"]        as? Int
        title       = info["title"]     as? String
        link        = info["link"]      as? String
        
        titleLabel.text = title
        linkButton.setTitle(link, forState: .Normal)
    }
    
    @IBAction func linkClicked(sender: UIButton) {
        let url = NSURL(string: sender.titleForState(.Normal)!)
        
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            //TODO: can't open the URL
        }
    }
}
