//
//  DetailImageViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {

    @IBOutlet var fullImageView: UIImageView!
    @IBOutlet var miniImageView: UIImageView!
    var fullImage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullImageView.image = fullImage
        miniImageView.image = fullImage
        
        
//        
//        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped")
//        view.addGestureRecognizer(tapRecognizer)
//        
        
        // Execute Show VIew Controller
        var swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showDetailViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier {
            if id == "segueToDetailUnwind" {
                let unwindSegue = UnwindBottonToUpCustomSegue(identifier: id,
                    source:fromViewController,
                    destination: toViewController,
                    performHandler: { () -> Void in
                        
                })
                return unwindSegue
            }
        }
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }

    
    @IBAction func dismissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }
    
    func showDetailViewController() {
        self.performSegueWithIdentifier("segueToDetail", sender: self)
    }
}
