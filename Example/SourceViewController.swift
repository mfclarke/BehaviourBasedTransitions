//
//  SourceViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class SourceViewController: UIViewController, BehaviourTransitionable {
    
    @IBOutlet var transitions: [BehaviourBasedTransition] = []
    @IBOutlet var transitionBehaviourCollections: [TransitionBehaviourCollection] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        prepareSegueForTransition(segue)
    }
    
    @IBAction func unwindToViewController(withSender sender: UIStoryboardSegue) {}
    
    @IBAction func dismiss(withSender sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



// MARK: Experimental UIGestureRecognizer support

// This is not needed for regular transitions! 
// Most of this boilerplate will likely be moved into the framework in future, with key vars exposed as IBInspectable.

extension SourceViewController {

    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIGestureRecognizer?) {
        guard let
            panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
            transition = self.transitions.first else { return }
        
        let rollBack = CGFloat(0.333)
        let translation = panGestureRecognizer.translationInView(view)
        let percent = max((-1.0 * translation.y) / transition.maxDistance, 0.0)
        let location = panGestureRecognizer.locationInView(view).y
        
        switch panGestureRecognizer.state {
        case .Began:
            transition.isInteractive = true
            transition.maxDistance = location
            performSegueWithIdentifier("Transition1", sender: self)
            
        case .Changed:
            transition.updateInteractiveTransition(percent)
            
        default:
            transition.isInteractive = false
            if percent > rollBack {
                transition.finishInteractiveTransition()
            } else {
                transition.cancelInteractiveTransition()
            }
        }
    }

}


extension SourceViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        return panGestureRecognizer.velocityInView(view).y < 0
    }
    
}
