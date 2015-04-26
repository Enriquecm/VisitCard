//
//  ProjectViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 25/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProjectCollectionTableViewCellDelegate {

    var card            : Card? = nil
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var imageName = card?.imageName {
            imageView.image = UIImage(named: imageName)
        }
        if var appName = card?.title {
            titleLabel.text = appName
        }
        if var info = card?.info as? [[String : AnyObject]]{
            if var appCompany = info[0]["subtitle"] as? String{
                subtitleLabel.text = appCompany
            }
        }
        if var info = card?.info as? [[String : AnyObject]]{
            if var actionName = info[0]["action"] as? String{
                actionButton.setTitle(actionName, forState: .Normal)
            }
        }
        
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func closeProject(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func actionButtonClicked(sender: UIButton) {
        
        if var info = card?.info as? [[String : AnyObject]]{
            if var link = info[0]["link"] as? String{
                let application = UIApplication.sharedApplication()
                let url = NSURL(string: link)
                if application.canOpenURL(url!) {
                    application.openURL(url!)
                } else {
                    //TODO: can't open the URL
                }
            }
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("cellCollection", forIndexPath: indexPath) as! ProjectCollectionTableViewCell
            cell.delegate = self;

            if var info = card?.info as? [[String : AnyObject]]{
                var dict = info[0] as NSDictionary
                cell.initWithDictionary(dict)
//                if var medias = info[0]["media"] as? [String]{
//                
//                }
            }
            
//            var dict = ["info": [ "images" : ["Foto1.jpg"] ] ] as NSDictionary
//            cell.initWithDictionary(dict)

            return cell
            
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("cellDescription", forIndexPath: indexPath) as! UITableViewCell
            if var info = card?.info as? [[String : AnyObject]]{
                if var appDescription = info[0]["text"] as? String{
                    if var label = cell.viewWithTag(1000) as? UILabel {
                        label.text = appDescription
                    }
                }
            }

            return cell
        }
    }
    
    
    func didSelectProjectCollectionTableViewCell(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cliquei em: %d", indexPath.row)
    }
    
}
