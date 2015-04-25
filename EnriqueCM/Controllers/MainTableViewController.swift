//
//  MainTableViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 17/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit
import Darwin


private let kLoadingIdentifier = "cellLoading"
private let kCardsIdentifier = "cellCard"

private let kHeightForCellLoading: CGFloat = 51.0
private let kHeightForCellCardOpen: CGFloat = 271.0
private let kHeightForHeaderInSection: CGFloat = 61.0

private let nameToHighlighted: String = "ENRIQUE"

class MainTableViewController: UITableViewController, UIViewControllerTransitioningDelegate, CardHeaderTableViewCellDelegate {
    
    private var isLoading = true
    
    private var cards : [String : [Card]] = [:]
    private let transitionDelegate: TransitionDelegate = TransitionDelegate()
    private var sectionOpened :Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setNavigationBar()
        setTableViewBackground()
        
        
        //Simulating asynchronous model
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("loadCards"), userInfo: nil, repeats: false)
    }
    
    func setNavigationBar() {
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba: "#58595B")]
    }
    
    func setTableViewBackground() {
        let colorTop = UIColor(red: 255.0/255.0, green: 0.0, blue: 118.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 102.0/255.0, green: 0.0, blue: 170.0/255.0, alpha: 1.0)
        
        tableView.backgroundView = Utils.gradientView(tableView.frame, colorA: colorTop, colorB: colorBottom, rotation: -0.25/2)
        createAnimationColor()
    }
    
    func createAnimationColor () {
        
        
        var view = UIView(frame: tableView.frame)
        let colorA = UIColor(red: 255.0/255.0, green: 0.0, blue: 118.0/255.0, alpha: 1.0)
        let colorB = UIColor(red: 102.0/255.0, green: 0.0, blue: 170.0/255.0, alpha: 1.0)
        
        var rotation:Float = -0.25/2 // 135º
        
        
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [colorB.CGColor, colorA.CGColor]
        view.layer.insertSublayer(layer, atIndex: 0)
        
        var a = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.75)/2))),2))
        var b = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.0)/2))),2))
        var c = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.25)/2))),2))
        var d = CGFloat(powf(sinf((2*Float(M_PI)*((rotation+0.5)/2))),2))
        
        layer.startPoint = CGPointMake(a, b)
        layer.endPoint = CGPointMake(c, d)
        
        // WARNING: - ols
        UIView.animateWithDuration(5, delay: 0, options:.CurveEaseInOut, animations: { () -> Void in
//            self.tableView.backgroundView = view
        }) { (Finished) -> Void in
            
        }
    }
    
    
    func loadCards() {
        // Something cool
        cards = CardsManager.loadCards();
        isLoading = false
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isLoading {
            return 1
        } else {
            return cards.keys.array.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isLoading {
            return 0
        } else {
            return kHeightForHeaderInSection
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoading{
            return nil
        }
        
        var header = tableView.dequeueReusableCellWithIdentifier("cellHeader") as! CardHeaderTableViewCell
        header.delegate = self
        header.section = section
        
        if section == sectionOpened {
            header.imageSectionIndicator.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        }
        
        var text = cards.keys.array[section].lowercaseString
        header.labelSection.text = text

        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if (section != sectionOpened) {
            return 0
        } else {
            var cardsIn = cards.keys.array[section]
            return cards[cardsIn]!.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isLoading {
            return kHeightForCellLoading
        } else {
            return kHeightForCellCardOpen
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
            
            if isLoading {
                let cell = tableView.dequeueReusableCellWithIdentifier(kLoadingIdentifier, forIndexPath:indexPath) as! UITableViewCell
                return cell;
            }
            
            let currentCard = cards[cards.keys.array[indexPath.section]]![indexPath.row]
            var cell = tableView.dequeueReusableCellWithIdentifier(kCardsIdentifier, forIndexPath: indexPath) as! CardTableViewCell
            cell.initWithCart(currentCard)
            
            //      cell.superview?.backgroundColor = UIColor.clearColor()
            
            return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if isLoading {
            return
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CardTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        // Set frame to open
        let frame = tableView.rectForRowAtIndexPath(indexPath)
        let rect = CGRectMake(cell.mainView.frame.origin.x, frame.origin.y, cell.mainView.frame.size.width, cell.mainView.frame.size.height)
        let frameToOpenFrom = tableView.convertRect(rect, toView: tableView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        // Present DetailTableViewController
        let detailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailTableViewController") as! DetailTableViewController
        detailTableViewController.card = cell.card
        
        if let image = cell.cardImageView.image {
            detailTableViewController.fullImage = image
        }
        
        detailTableViewController.transitioningDelegate = transitionDelegate
        detailTableViewController.modalPresentationStyle = .Custom
        presentViewController(detailTableViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - UserHeaderTableViewCell delegate
    
    func didSelectUserHeaderTableViewCell(Selected: Bool, Section: Int, UserHeader: CardHeaderTableViewCell) {
        if Section == sectionOpened {
            sectionOpened = -1      // Close Section
        } else {
            sectionOpened = Section // Open Section
        }
        
        UIView.transitionWithView(tableView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.tableView.reloadData()
            
            }, completion: nil)
    }
}
