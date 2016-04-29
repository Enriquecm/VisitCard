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
    
    @IBOutlet weak var barButtonMiniCard: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageName = card?.imageName {
            imageView.image = UIImage(named: imageName)
        }
        if let appName = card?.title {
            titleLabel.text = appName
            title = appName
        }
        if var info = card?.info as? [[String : AnyObject]]{
            if let appCompany = info[0]["subtitle"] as? String{
                subtitleLabel.text = appCompany
            }
        }
        if var info = card?.info as? [[String : AnyObject]]{
            if let actionName = info[0]["action"] as? String{
                actionButton.setTitle(actionName, forState: .Normal)
            }
        }
        
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        // Notification
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(checkIfIsVisitCard), name: kVisitCardNotification, object: nil)
        
        checkIfIsVisitCard()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func checkIfIsVisitCard() {
        if let card = self.card where card.isVisitCard {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func closeProject(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func actionButtonClicked(sender: UIButton) {
        
        if var info = card?.info as? [[String : AnyObject]]{
            if let link = info[0]["link"] as? String{
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
            let cell = tableView.dequeueReusableCellWithIdentifier("cellCollection", forIndexPath: indexPath) as! ProjectCollectionTableViewCell
            cell.delegate = self;

            if var info = card?.info as? [[String : AnyObject]]{
                let dict = info[0] as NSDictionary
                cell.initWithDictionary(dict)
//                if var medias = info[0]["media"] as? [String]{
//                
//                }
            }
            
//            var dict = ["info": [ "images" : ["Foto1.jpg"] ] ] as NSDictionary
//            cell.initWithDictionary(dict)

            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellDescription", forIndexPath: indexPath)
            if var info = card?.info as? [[String : AnyObject]]{
                if let appDescription = info[0]["text"] as? String{
                    if let label = cell.viewWithTag(1000) as? UILabel {
                        label.text = appDescription
                    }
                }
            }

            return cell
        }
    }
    
    
    func didSelectProjectCollectionTableViewCell(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cliquei em: %d", indexPath.row)
    }
    
    @IBAction func barButtonMiniCardPressed(sender: AnyObject) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Use as Visit Card", message: "Do you want to use this information as visit card?", preferredStyle: .Alert)
        
        // Create the actions
        let visitCardAction = UIAlertAction(title: "Use as Visit Card", style: UIAlertActionStyle.Default) { [weak self] UIAlertAction in
            
            self?.card?.saveAsVisitCard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(visitCardAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
