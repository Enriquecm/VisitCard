//
//  CustomSegue.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 17/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        // Source and Destination views
        let firstViewControllerView = self.sourceViewController.view as UIView!
        let secondViewControllerView = self.destinationViewController.view as UIView!
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondViewControllerView, belowSubview: firstViewControllerView)
        
        // Initial size of the destination view
        secondViewControllerView.transform = CGAffineTransformScale(secondViewControllerView.transform, 0.001, 0.001)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            firstViewControllerView.transform = CGAffineTransformScale(secondViewControllerView.transform, 0.001, 0.001)
        }) { (completed) -> Void in
            UIView.animateWithDuration(1, animations: { () -> Void in
                secondViewControllerView.transform = CGAffineTransformIdentity
            }, completion: { (secondCompleted) -> Void in
                firstViewControllerView.transform = CGAffineTransformIdentity
                self.sourceViewController.presentViewController(self.destinationViewController,
                    animated: false,
                    completion: nil)
            })
        }
        
        
    }
}
