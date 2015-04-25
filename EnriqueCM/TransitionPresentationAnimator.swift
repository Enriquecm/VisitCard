//
//  TransitionPresentationAnimator.swift
//  EnriqueCM
//
//  Created by Enrique Melgarejo on 18/04/15.
//  Copyright (c) 2015 Enrique Choynowski Melgarejo. All rights reserved.
//

import UIKit

class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        let animationDuration = self.transitionDuration(transitionContext)
        
        // Take a snapshot of the detail ViewController
        let snapshotView = toViewController.view.resizableSnapshotViewFromRect(toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        snapshotView.center = fromViewController.view.center
        containerView.addSubview(snapshotView)
        
        // Hide the detail view until the snapshot is being animated
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: nil,
            animations: { () -> Void in
                snapshotView.transform = CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                snapshotView.removeFromSuperview()
                toViewController.view.alpha = 1.0
                transitionContext.completeTransition(finished)
        })
    }
    
}