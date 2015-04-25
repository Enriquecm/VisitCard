//
//  FirstCustomSegue.swift
//  EnriqueCM
//
//  This custom class creates a transition from the bottom to up, between the 
//  source and destination ViewControllers
//
//  Created by Enrique Melgarejo on 17/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class BottomToUpCustomSegue: UIStoryboardSegue {
 
    override func perform() {
        // Source and Destination views
        var firstViewControllerView = self.sourceViewController.view as UIView!
        var secondViewControllerView = self.destinationViewController.view as UIView!

        // Screen Size
        let screenWidht = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Initial position of the destination view
        secondViewControllerView.frame = CGRectMake(0.0, screenHeight, screenWidht, screenHeight)
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondViewControllerView, aboveSubview: firstViewControllerView)
        
        // Animate custom transition
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstViewControllerView.frame = CGRectOffset(firstViewControllerView.frame, 0.0, -screenHeight)
            secondViewControllerView.frame = CGRectOffset(secondViewControllerView.frame, 0.0, -screenHeight)
        }) { (completed) -> Void in
            self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController,
                animated: false,
                completion: nil)
        }
    }
}
