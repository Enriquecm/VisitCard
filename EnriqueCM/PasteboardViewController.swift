//
//  PasteboardViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 4/26/16.
//  Copyright © 2016 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class PasteboardViewController: UIViewController {

    @IBOutlet weak var viewVisitCard: UIView!
    @IBOutlet weak var labelVisitCardTitle: UILabel!
    
    @IBOutlet weak var labelVisitCardSubtitle: UILabel!
    @IBOutlet weak var imageViewVisitCardImage: UIImageView!
    @IBOutlet weak var labelAbout: UILabel!
    
    @IBOutlet weak var viewPersonalDetails: UIView!
    
    @IBOutlet weak var labelPDEmail: UILabel!
    @IBOutlet weak var labelPDPhone: UILabel!
    @IBOutlet weak var labelPDLinkedin: UILabel!
    @IBOutlet weak var labelPDGithub: UILabel!
    
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var buttonFake: UIButton!
    private var needToGoToNextPageWithTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVisitCard()
        checkIfNeedGoToNextPage()
        
        //Notification
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(appDidBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().setObserver(self, selector: #selector(loadVisitCardInformation), name: kVisitCardNotification, object: nil)
        
        configureFakeButtonTouch()
    }
    
    func configureFakeButtonTouch() {
        let colorView = UIView(frame: buttonFake.frame)
        colorView.backgroundColor = UIColor(hex: "#898989")
        colorView.alpha = 0.6
        
        UIGraphicsBeginImageContext(colorView.bounds.size)
        colorView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        buttonFake.setBackgroundImage(colorImage, forState:.Highlighted)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    @objc private func appDidBecomeActive(notification: NSNotification) {
        checkIfNeedGoToNextPage()
    }
    
    private func checkIfNeedGoToNextPage() {
        if let title = needToGoToNextPageWithTitle {
            let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mainTableViewController") as! MainTableViewController
            mainViewController.viewSectionWithTitle(title)
            navigationController?.pushViewController(mainViewController, animated: true)
        }
    }
    
    func loadVisitCardInformation() {
        var visitCard: Card?
        let sections = InformationManager.loadInformation()
        for section in sections {
            for card in section.cards {
                if card.isVisitCard {
                    visitCard = card
                }
            }
        }
        
        if let visitCard = visitCard {
            //            var title       : String = ""
            //            let subtitle    : String?
            //            let imageName   : String?
            //            let about       : String?
            //            var type: CardType? = .Unknown
            //            let info        : AnyObject?
            
            labelVisitCardTitle.text = visitCard.title
            labelVisitCardSubtitle.text = visitCard.subtitle
            
            if let about = visitCard.about {
                labelAbout.text = "     " + about
            }
            
            if let imageName = visitCard.imageName {
                imageViewVisitCardImage.image = UIImage(named: imageName)
            }
            
            if let type = visitCard.type where type == .Personal,
                let infos = visitCard.info as? [NSDictionary] {
                labelAbout.hidden = true
                viewPersonalDetails.hidden = false
                
                for item in infos {
                    if let info = item["info"] as? NSDictionary {
                        if let title = info["title"] as? String where title == "Email",
                            let text = info["link"] as? String {
                            labelPDEmail.text = text.stringByReplacingOccurrencesOfString("mailto:", withString: "")
                        }
                        if let title = info["title"] as? String where title == "Contact",
                            let text = info["link"] as? String {
                            labelPDPhone.text = text.stringByReplacingOccurrencesOfString("tel://", withString: "")
                        }
                        if let title = info["title"] as? String where title == "Linkedin",
                            let text = info["link"] as? String {
                            labelPDLinkedin.text = text
                        }
                        if let title = info["title"] as? String where title == "GitHub",
                            let text = info["link"] as? String {
                            labelPDGithub.text = text
                        }
                    }
                }
                
            } else {
                labelAbout.hidden = false
                viewPersonalDetails.hidden = true
            }
        }
    }
    
    private func configureVisitCard() {
        
        loadVisitCardInformation()
        viewVisitCard.layer.cornerRadius = 15

        self.viewVisitCard.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        
        UIView.animateWithDuration(0.5/1.5, delay: 0.5, options: .LayoutSubviews, animations: {
            self.viewVisitCard.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
        }) { _ in
            UIView.animateWithDuration(0.5/2, animations: {
                self.viewVisitCard.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
            }) { _ in
                UIView.animateWithDuration(0.5/2, animations: {
                    self.viewVisitCard.transform = CGAffineTransformIdentity
                })
            }
        }
    }
    
    //MARK: Actions
    @IBAction func shareButtonPressed(sender: AnyObject) {
        shareVisitCard()
    }
    
    private func shareVisitCard() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.buttonShare.hidden = true
            let image = self.viewVisitCard.takeSnapshot()
            self.buttonShare.hidden = false
            
            if let data = UIImagePNGRepresentation(image),
                let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
                
                let documentsFileName = documentDirectories + "/" + "image.png"
                debugPrint(documentsFileName)
                if data.writeToFile(documentsFileName, atomically: true) {
                    
                    let url = NSURL(fileURLWithPath: documentsFileName)
                    let docController = UIDocumentInteractionController(URL: url)
                    docController.delegate = self
                    docController.presentPreviewAnimated(true)
                }
            }
        }
    }
}

extension PasteboardViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension UIView {
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension PasteboardViewController: PerformShortcutAction {
    func shareAllInformation() {
        shareVisitCard()
    }
    
    func viewSectionWithTitle(title: String) {
        needToGoToNextPageWithTitle = title
    }
}




//
//        createPdfFromView(viewVisitCard, saveToDocumentsWithFileName: filename)
//
//        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
//            let str = documentDirectories + "/" + filename
//
//            //            let pdfData = NSData.dataWithContentsOfMappedFile(str)
//            let url = NSURL(fileURLWithPath: str)
//
//            let vc = UIActivityViewController(activityItems: ["test", url], applicationActivities: [])
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
//        http://stackoverflow.com/questions/15781877/how-to-send-a-pdf-file-using-uiactivityviewcontroller

//    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
//    {
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
//        UIGraphicsBeginImageContextWithOptions(aView.bounds.size, false, UIScreen.mainScreen().scale)
////        UIGraphicsBeginPDFPageWithInfo(CGRectMake(aView.frame.origin.x, aView.frame.origin.y, aView.bounds.width, aView.bounds.height), nil)
//
//
//        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
//        aView.layer.renderInContext(pdfContext)
//        UIGraphicsEndPDFContext()
//
//        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
//            let documentsFileName = documentDirectories + "/" + fileName
//            debugPrint(documentsFileName)
//            pdfData.writeToFile(documentsFileName, atomically: true)
//        }
//