//
//  CustomSequeUnwind.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 17/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class CustomSequeUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        var firstViewControllerView = self.sourceViewController.view as UIView!
        var secondViewControllerView = self.destinationViewController.view as UIView!
        
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        secondViewControllerView.frame = CGRectOffset(secondViewControllerView.frame, 0.0, screenHeight)
        secondViewControllerView.transform = CGAffineTransformScale(secondViewControllerView.transform, 0.001, 0.001)
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondViewControllerView, aboveSubview: firstViewControllerView)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            firstViewControllerView.transform = CGAffineTransformScale(firstViewControllerView.transform, 0.001, 0.001)
            firstViewControllerView.frame = CGRectOffset(firstViewControllerView.frame, 0.0, -screenHeight)
            
            secondViewControllerView.transform = CGAffineTransformIdentity
            secondViewControllerView.frame = CGRectOffset(secondViewControllerView.frame, 0.0, -screenHeight)
            
            }) { (Finished) -> Void in
                
                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}
