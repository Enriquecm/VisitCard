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

class MainTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    private var isLoading = true
    
    private var sections: [Section] = []
    private let transitionDelegate: TransitionDelegate = TransitionDelegate()
    private var sectionOpened = -1
    private var showSectionWithTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setNavigationBar()
        setTableViewBackground()
        loadCards()
        
        //Notification
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(appDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(reloadInformation), name: kVisitCardNotification, object: nil)
        registerForPreviewingWithDelegate(self, sourceView: view)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    @objc private func appDidBecomeActive(notification: NSNotification) {
        checkIfNeedToOpenSection()
    }
    
    private func checkIfNeedToOpenSection() {
        if let title = showSectionWithTitle as String? {
            for (index, section) in sections.enumerate() {
                if section.title == title {
                    sectionOpened = index
                    tableView.reloadData()
                }
            }
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(hex: "#58595B")]
    }
    
    func setTableViewBackground() {
        let colorTop = UIColor(red: 58.0/255.0, green: 62.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 216.0/255.0, green: 151.0/255.0, blue: 104.0/255.0, alpha: 1.0)
        
        tableView.backgroundView = Utils.gradientView(tableView.frame, colorA: colorTop, colorB: colorBottom, rotation: -0.25/2)
    }
    
    func loadCards() {
        // Something cool
        sections = InformationManager.loadInformation()
        
        isLoading = false
        checkIfNeedToOpenSection()
    }
    
    func reloadInformation() {
        sections = InformationManager.loadInformation()
        tableView.reloadData()
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
        header.indexSection = section
        
        if section == sectionOpened {
            header.imageSectionIndicator.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        }
        
        let ecmSection = sections[section]
        header.configureWithSection(ecmSection)

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
            cell.initWithCart(currentCard, atIndexPath: indexPath)
            cell.delegate = self
            
            cell.superview?.backgroundColor = UIColor.clearColor() // ??
            
            return cell
    }
    
    @IBAction func barButtonCancelPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func barButtonActionPressed(sender: UIBarButtonItem) {
        
    }
}

extension MainTableViewController: CardTableViewCellDelegate {
    
    func didSelectCardTableViewCell(card: Card, atIndexPath: NSIndexPath) {
        
        // Obtain the index path and the cell that was pressed.
        guard let cell = tableView.cellForRowAtIndexPath(atIndexPath) as? CardTableViewCell else { return }
        cell.backgroundColor = UIColor.clearColor()
        
        // Set frame to open
        let frame = tableView.rectForRowAtIndexPath(atIndexPath)
        let rect = CGRectMake(cell.mainView.frame.origin.x, frame.origin.y, cell.mainView.frame.size.width, cell.mainView.frame.size.height)
        let frameToOpenFrom = tableView.convertRect(rect, toView: tableView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        if card.type == .Project,
            let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("projectNavigationController") as? UINavigationController {
            
            let projectViewController = navigationController.viewControllers.first as! ProjectViewController
            projectViewController.card = card
            projectViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            presentViewController(navigationController, animated: true, completion: nil)
        } else {
            // Present DetailTableViewController
            let detailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailTableViewController") as! DetailTableViewController
            detailTableViewController.card = card
            if let image = cell.cardImageView.image {
                detailTableViewController.fullImage = image
            }
            
            detailTableViewController.transitioningDelegate = transitionDelegate
            detailTableViewController.modalPresentationStyle = .Custom
            presentViewController(detailTableViewController, animated: true, completion: nil)
        }
    }
}

extension MainTableViewController: UIViewControllerPreviewingDelegate {
        
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        presentViewController(viewControllerToCommit, animated: true, completion: nil)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        // Obtain the index path and the cell that was pressed.
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) as? CardTableViewCell else { return nil }
        
        cell.backgroundColor = UIColor.clearColor()
        
        // Set frame to open
        let frame = tableView.rectForRowAtIndexPath(indexPath)
        let rect = CGRectMake(cell.mainView.frame.origin.x, frame.origin.y, cell.mainView.frame.size.width, cell.mainView.frame.size.height)
        let frameToOpenFrom = tableView.convertRect(rect, toView: tableView.superview)
        transitionDelegate.openingFrame = frameToOpenFrom
        
        if cell.card?.type == .Project,
            let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("projectNavigationController") as? UINavigationController {
            
            let projectViewController = navigationController.viewControllers.first as! ProjectViewController
            projectViewController.card = cell.card
//            projectViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            previewingContext.sourceRect = cell.frame
            return navigationController
        } else {
            
            // Present DetailTableViewController
            let detailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailTableViewController") as! DetailTableViewController
            detailTableViewController.card = cell.card
            
            if let image = cell.cardImageView.image {
                detailTableViewController.fullImage = image
            }
            
            detailTableViewController.transitioningDelegate = transitionDelegate
            detailTableViewController.modalPresentationStyle = .Custom
//            detailTableViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
            previewingContext.sourceRect = cell.frame
            return detailTableViewController
        }
    }
}

extension MainTableViewController: CardHeaderTableViewCellDelegate {

    func didSelecCardHeaderTableViewCell(selected: Bool, section: Int) {
        
        if section == sectionOpened {
            sectionOpened = -1      // Close Section
        } else {
            sectionOpened = section // Open Section
        }
        
        UIView.transitionWithView(tableView, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { [weak self] _ in
            
            self?.tableView.reloadData()
            
            }, completion: nil)
    }
    
    func didSelecAddToShortcut(section: Section) {
        print(section.title)
        // Create the alert controller
        let alertController = UIAlertController(title: "Create Shortcut", message: "Selecting one of the options you'll create a shortcut:", preferredStyle: .Alert)
        
        // Create the actions
        let profileAction = UIAlertAction(title: "First shortcut", style: UIAlertActionStyle.Default) { [weak self] UIAlertAction in
            ShortcutManager.createShortcutForSection(section, type:.ViewProfile)
            self?.reloadInformation()
        }
        let projectsAction = UIAlertAction(title: "Second shortcut", style: UIAlertActionStyle.Default) { [weak self] UIAlertAction in
            ShortcutManager.createShortcutForSection(section, type:.ViewProjects)
            self?.reloadInformation()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(profileAction)
        alertController.addAction(projectsAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func didSelecRemoveShortcut(section: Section) {
        ShortcutManager.removeShortcutForSection(section)
        reloadInformation()
    }
}

extension MainTableViewController: PerformShortcutAction {
    
    func shareAllInformation() {
        // TODO:
    }
    
    func viewSectionWithTitle(title: String) {
        showSectionWithTitle = title
    }
}