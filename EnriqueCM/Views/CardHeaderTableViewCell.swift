//
//  CardHeaderTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 19/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit
import Darwin

protocol CardHeaderTableViewCellDelegate {
    func didSelectUserHeaderTableViewCell(Selected: Bool, Section: Int, UserHeader: CardHeaderTableViewCell)
}

class CardHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var labelSection: UILabel!
    @IBOutlet var imageSectionIndicator: UIImageView!

    @IBOutlet var _backgroundView: UIView!
    var delegate : CardHeaderTableViewCellDelegate?
    var section : Int? = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let rightColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
        let leftColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.20)
        let rotation:Float = -0.25/2 // 135º
        
        // Degrades added with 45 degrees
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = _backgroundView.frame
        layer.colors = [leftColor.CGColor, rightColor.CGColor]
        
        let a = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.75)/2))),2))
        let b = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.0)/2))),2))
        let c = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.25)/2))),2))
        let d = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.5)/2))),2))
        
        layer.startPoint = CGPointMake(a, b)
        layer.endPoint = CGPointMake(c, d)
        _backgroundView.layer.insertSublayer(layer, atIndex: 0)
        
        
        // Selected Header
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedHeader(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func selectedHeader(sender: AnyObject) {
        delegate?.didSelectUserHeaderTableViewCell(true, Section: section!, UserHeader: self)   
    }
}
