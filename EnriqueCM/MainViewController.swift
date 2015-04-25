//
//  ViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 16/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showListViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        NSLog("DidLoad Main")
    }

    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier {
            if id == "segueToListUnwind" {
                let unwindSegue = CustomSequeUnwind(identifier: id,
                    source:fromViewController,
                    destination: toViewController,
                    performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
    }
    
    func showListViewController() {
        self.performSegueWithIdentifier("segueToList", sender: self)
    }
    
}

