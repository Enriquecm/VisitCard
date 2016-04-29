//
//  DetailTableViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 19/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

private let kTableHeaderHeight  : CGFloat = 400.0
private let kTableHeaderCut     : CGFloat = 80.0

class DetailTableViewController: UITableViewController, DetailCollectionTableViewCellDelegate {
    
    private var isLoading = true
    private var headerView      : UIView?
    private var headerMaskLayer : CAShapeLayer?
    private var arrayOfCardInfo: [[String: AnyObject]]? = []
    
    @IBOutlet var fullImageView : UIImageView!
    @IBOutlet var miniImageView : UIImageView!
    @IBOutlet var viewFullImageView: UIView!
    @IBOutlet weak var buttonMiniCard: UIButton!
    
    var card        : Card? = nil
    var fullImage   : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.miniImageView.image = self.fullImage
        self.fullImageView.image = self.fullImage
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        checkIfIsVisitCard()
        
        // TODO: Remove Timer
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(loadCardInfo), userInfo: nil, repeats: false)
        
        // Notification
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(checkIfIsVisitCard), name: kVisitCardNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func checkIfIsVisitCard() {
        if let card = self.card where card.isVisitCard {
            buttonMiniCard.alpha = 1.0
        } else {
            buttonMiniCard.alpha = 0.6
        }
    }
    
    func loadCardInfo() {
        if let array = card?.info as? [[String : AnyObject]] {
            for info in array {
                arrayOfCardInfo?.append(info)
            }
        }
        isLoading = false
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5, animations: { [weak self] _ in
            
            self?.headerView = self?.tableView.tableHeaderView
            self?.tableView.tableHeaderView = nil
            self?.tableView.addSubview(self?.headerView ?? UIView())
            
            let effectiveHeight = kTableHeaderHeight //- kTableHeaderCut/2
            self?.tableView.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
            self?.tableView.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            self?.headerMaskLayer = CAShapeLayer()
            self?.headerMaskLayer?.fillColor = UIColor.blackColor().CGColor
            
            self?.headerView?.layer.mask = self?.headerMaskLayer
            
            self?.updateHeaderView()
            
            }) { finished in
                //Nothing to do
        }
    }
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight //- kTableHeaderCut/2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y //+ kTableHeaderCut/2
        }
        headerView?.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height - kTableHeaderCut))
        headerMaskLayer?.path = path.CGPath
    }
    
    
    // MARK: Segue unwind ----->>> Deprecated in iOS9
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
//        if let id = identifier {
//            if id == "segueToDetailUnwind" {
//                let unwindSegue = UnwindBottonToUpCustomSegue(identifier: id,
//                    source:fromViewController,
//                    destination: toViewController,
//                    performHandler: { () -> Void in
//                        
//                })
//                return unwindSegue
//            }
//        }
//        
//        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
//    }
    
    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ScrollView delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return arrayOfCardInfo!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if isLoading {
            cell = tableView.dequeueReusableCellWithIdentifier("cellLoading", forIndexPath: indexPath)
            return cell
        }
        
        if let info = arrayOfCardInfo?[indexPath.row] where info["type"] is String {
            
            let identifier = getPropertiesFromType(info["type"] as! String)["identifier"] as! String
            cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
            cell.initWithDictionary(info)
            
            // Custom property on Detail Collection Table View Cell
            if cell is DetailCollectionTableViewCell {
                let cellCollection = cell as! DetailCollectionTableViewCell
                cellCollection.delegate = self;
            }
            
            return cell
            
        } else {
            return tableView.dequeueReusableCellWithIdentifier("cellLoading", forIndexPath: indexPath)
        }
    }
    
    //MARK: - Methods
    
    func getPropertiesFromType(type:NSString) -> [String : AnyObject] {
        switch(type){
        case "title":
            return ["identifier": "cellTitleSubtitleImage", "height": 60.0]
        case "adjustable-text":
            return ["identifier": "cellAdjustableText", "height": 122.0]
        case "link":
            return ["identifier": "cellLink", "height": 53.0]
        case "date":
            return ["identifier": "cellDate", "height": 33.0]
        case "media", "project", "honor":
            return ["identifier": "cellCollection", "height": 155.0]
        default:
            return ["identifier": "cellLoading", "height": 80]
        }
    }
    
    //MARK: - DetailCollectionTableViewCellDelegate
    
    func didSelectDetailCollectionTableViewCell(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, type: String) {
        
        //TODO Go To Projects
        if type == "project" {
//            let projectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("projectViewController") as! ProjectViewController
//            projectViewController.card = card
//            presentViewController(projectViewController, animated: true, completion: nil)
        }
    }

    //MARK: Actions
    
    @IBAction func buttonUseAsVisitCardPressed(sender: UIButton) {
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
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        var style: UIPreviewActionStyle
        if let card = self.card where card.isVisitCard {
            style = .Selected
        } else {
            style = .Default
        }
        
        let action_0 = UIPreviewAction(title: "Use as Visit Card", style: style) { (action: UIPreviewAction, vc: UIViewController) -> Void in
            if let viewController = vc as? DetailTableViewController {
                viewController.card?.saveAsVisitCard()
            }
        }
        
//        let action_1 = UIPreviewAction(title: "as a PDF file", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
//            NSLog("Share Information as a PDF")
//        }
//        
//        let action_2 = UIPreviewAction(title: "as an Image", style: .Default) { (action: UIPreviewAction, vc: UIViewController) -> Void in
//            NSLog("Share Information as a Image")
//        }
//        
//        let action_3 = UIPreviewActionGroup(title: "Share…", style: .Default, actions: [action_1, action_2])
        
        return [action_0/*, action_3*/]
    }
}


// SHARE PDF

//        let filename = "TestABCD.pdf"
//        createPdfFromView(view, saveToDocumentsWithFileName: filename)
//
//        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
//            let str = documentDirectories + "/" + filename
//
//            let pdfData = NSData.dataWithContentsOfMappedFile(str)
//            let url = NSURL(fileURLWithPath: str)
//
//            let vc = UIActivityViewController(activityItems: ["test", url], applicationActivities: [])
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
////        http://stackoverflow.com/questions/15781877/how-to-send-a-pdf-file-using-uiactivityviewcontroller
