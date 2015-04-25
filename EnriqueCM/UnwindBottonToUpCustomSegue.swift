//
//  UnwindBottonToUpCustomSegue.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 17/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class UnwindBottonToUpCustomSegue: UIStoryboardSegue {
    
    //    override func perform() {
    //        // Source and Destination views
    //        var firstViewControllerView = self.sourceViewController.view as UIView!
    //        var secondViewControllerView = self.destinationViewController.view as UIView!
    //
    //        // Screen Height
    //        let screenHeight = UIScreen.mainScreen().bounds.size.height
    //
    //        let window = UIApplication.sharedApplication().keyWindow
    //        window?.insertSubview(firstViewControllerView, aboveSubview: secondViewControllerView)
    //
    //
    //        // Animate custom transition.
    //        UIView.animateWithDuration(0.4, animations: { () -> Void in
    //            firstViewControllerView.frame = CGRectOffset(firstViewControllerView.frame, 0.0, screenHeight)
    //            secondViewControllerView.frame = CGRectOffset(secondViewControllerView.frame, 0.0, screenHeight)
    //
    //        }) { (completed) -> Void in
    //            self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
    //        }
    //    }
    
    override func perform() {
        
        // Source and Destination views
        var secondViewControllerView = self.sourceViewController.view as UIView!
        var firstViewControllerView = self.destinationViewController.view as UIView!
        
        //Screen Height
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(firstViewControllerView, aboveSubview: secondViewControllerView)
        
        
        // Animate custom transition.
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstViewControllerView.frame = CGRectOffset(firstViewControllerView.frame, 0.0, screenHeight)
            secondViewControllerView.frame = CGRectOffset(secondViewControllerView.frame, 0.0, screenHeight)
            
            }) { (completed) -> Void in
                
                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
}
