//
//  ProjectCollectionTableViewCell.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 25/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

protocol ProjectCollectionTableViewCellDelegate {
    func didSelectProjectCollectionTableViewCell(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
}

class ProjectCollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var delegate    : ProjectCollectionTableViewCellDelegate?
    var collection  = [AnyObject]()
    
    private var isOpening : Bool = true
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func initWithDictionary(dictionary : NSDictionary) {

        if var images = dictionary["media"] as? [String] {
            for image in images {
                collection.append(image)
            }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        var imageView = cell.viewWithTag(1001) as? UIImageView

        var item: AnyObject = collection[indexPath.row]
        if var image = item as? String {
            imageView?.image = UIImage(named: image)
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSizeMake(300, 300)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate!.didSelectProjectCollectionTableViewCell(collectionView, didSelectItemAtIndexPath: indexPath)
    }
}
