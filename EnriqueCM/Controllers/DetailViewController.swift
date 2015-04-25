//
//  DetailViewController.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 19/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Execute Dismiss VIew Controller
        // Do any additional setup after loading the view.
        var swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showDetailImageViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func showDetailImageViewController() {
        self.performSegueWithIdentifier("segueToDetailUnwind", sender: self)
    }
}
