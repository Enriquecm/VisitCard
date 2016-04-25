//
//  DetailCollectionTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 21/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

protocol DetailCollectionTableViewCellDelegate {
    func didSelectDetailCollectionTableViewCell(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, type: String)
}

class DetailCollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var id          : Int?
    var title       : String?
    var delegate    : DetailCollectionTableViewCellDelegate?
    var collection  = [AnyObject]()
    
    private let kTypeMedia : String      = "media"
    private let kTypeProject : String    = "project"
    private let kTypeHonor : String      = "honor"
    
    private var type : String?
    private var isOpening : Bool = true
    
    @IBOutlet var titleLabel    : UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func initWithDictionary(dictionary : NSDictionary) {
        guard let info = dictionary["info"] as? NSDictionary else { return }
        
        type    = dictionary["type"]as? String
        id      = info["id"]        as? Int
        title   = info["title"]     as? String

        titleLabel.text = title
        
        // Invalid configuration
        if type == nil {
            return;
        }
        
        switch (type!) {
        case kTypeMedia:
            if let images = info["images"] as? [String] {
                collection.append(images)
            }
            if let videos = info["videos"] as? [String] {
                collection.append(videos)
            }
        case kTypeProject, kTypeHonor:
            if let items = info["items"] as? [[String : AnyObject]] {
                collection = items
            }
        default:
            NSLog("Invalid collection type")
        }
        isOpening = false;
        collectionView.reloadData()
    }
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if isOpening {
            return 0
        } else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOpening {
            return 0
        } else {
            return collection.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellCollectionDetail", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(1001) as? UIImageView
        let label = cell.viewWithTag(1002) as? UILabel
        
        let item: AnyObject = collection[indexPath.row]
        
        switch (type!) {
        case kTypeMedia:
            if let image = item as? String {
                imageView?.image = UIImage(named: image)
            }
        
        case kTypeProject, kTypeHonor:
            if let image = (item["image"]) as? String {
                imageView?.image = UIImage(named: image)
            }   
            if let text = (item["name"]) as? String {
                label?.text = text;
            }
        
        default:
            NSLog("Invalid collection type")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate!.didSelectDetailCollectionTableViewCell(collectionView, didSelectItemAtIndexPath: indexPath, type: type!)
    }
}
