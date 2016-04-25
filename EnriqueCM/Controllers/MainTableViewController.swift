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
    
    private var sections: [Section] = []
    private let transitionDelegate: TransitionDelegate = TransitionDelegate()
    private var sectionOpened = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setNavigationBar()
        setTableViewBackground()
        
        //Simulating asynchronous model
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(loadCards), userInfo: nil, repeats: false)
    }
    
    func setNavigationBar() {
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hex: "#58595B")]
    }
    
    func setTableViewBackground() {
        let colorTop = UIColor(red: 52.0/255.0, green: 104.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 237.0/255.0, green: 28.0/255.0, blue: 119.0/255.0, alpha: 1.0)
        
        tableView.backgroundView = Utils.gradientView(tableView.frame, colorA: colorTop, colorB: colorBottom, rotation: -0.25/2)
    }
    
    func loadCards() {
        // Something cool
        sections = InformationManager.loadInformation()
        isLoading = false
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source and delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if isLoading {
            return 1
        } else {
            return sections.count
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
        
        let header = tableView.dequeueReusableCellWithIdentifier("cellHeader") as! CardHeaderTableViewCell
        header.delegate = self
        header.section = section
        
        if section == sectionOpened {
            header.imageSectionIndicator.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        }
        
        let section = sections[section]
        header.labelSection.text = section.title

        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if (section != sectionOpened) {
            return 0
        } else {
            let section = sections[section]
            return section.cards.count
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
                let cell = tableView.dequeueReusableCellWithIdentifier(kLoadingIdentifier, forIndexPath:indexPath) 
                return cell;
            }
            
            let section = sections[indexPath.section]
            let currentCard = section.cards[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier(kCardsIdentifier, forIndexPath: indexPath) as! CardTableViewCell
            cell.initWithCart(currentCard)
            
            cell.superview?.backgroundColor = UIColor.clearColor() // ??
            
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
        
        if cell.cardType == .Project,
            let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("projectNavigationController") as? UINavigationController {
            
            let projectViewController = navigationController.viewControllers.first as! ProjectViewController
            projectViewController.card = cell.card
            presentViewController(navigationController, animated: true, completion: nil)
            
        } else {
            
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
    }
    
    
    // MARK: UserHeaderTableViewCell delegate
    
    func didSelectUserHeaderTableViewCell(Selected: Bool, Section: Int, UserHeader: CardHeaderTableViewCell) {
        if Section == sectionOpened {
            sectionOpened = -1      // Close Section
        } else {
            sectionOpened = Section // Open Section
        }
        
        UIView.transitionWithView(tableView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { [weak self] _ in
            self?.tableView.reloadData()
            
            }, completion: nil)
    }
}
