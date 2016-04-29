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
    func didSelecAddToShortcut(section: Section)
    func didSelecRemoveShortcut(section: Section)
    func didSelecCardHeaderTableViewCell(selected: Bool, section: Int)
}

class CardHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var labelSection: UILabel!
    @IBOutlet private weak var viewBackground: UIView!
    @IBOutlet private weak var buttonRadio: UIButton!
    
    @IBOutlet weak var imageSectionIndicator: UIImageView!
    
    private var currentSection: Section? {
        didSet {
            if currentSection != nil &&
                currentSection!.isShortcut {
                buttonRadio.setImage(UIImage(named: "radio-checked"), forState: UIControlState.Normal)
            } else {
                buttonRadio.setImage(UIImage(named: "radio-unchecked"), forState: UIControlState.Normal)
            }
        }
    }
    var delegate : CardHeaderTableViewCellDelegate?
    var indexSection: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let rightColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
        let leftColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.20)
        let rotation:Float = -0.25/2 // 135º
        
        // Degrades added with 45 degrees
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = viewBackground.frame
        layer.colors = [leftColor.CGColor, rightColor.CGColor]
        
        let a = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.75)/2))),2))
        let b = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.0)/2))),2))
        let c = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.25)/2))),2))
        let d = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.5)/2))),2))
        
        layer.startPoint = CGPointMake(a, b)
        layer.endPoint = CGPointMake(c, d)
        viewBackground.layer.insertSublayer(layer, atIndex: 0)
        
        
        // Selected Header
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedHeader(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func configureWithSection(section: Section) {
        labelSection.text = section.title
        currentSection = section
    }
    
    func selectedHeader(sender: AnyObject) {
        delegate?.didSelecCardHeaderTableViewCell(true, section: indexSection)
    }
    
    @IBAction func didSelectRadioButton(sender: AnyObject) {
        if let section = currentSection as Section? {
            if section.isShortcut {
                delegate?.didSelecRemoveShortcut(section)
            } else {
                delegate?.didSelecAddToShortcut(section)
            }
        }
    }
}
