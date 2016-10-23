//
//  DestinationViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class DestinationViewController: UIViewController, BehaviourTransitionable {
    
    @IBOutlet var transitions: [BehaviourBasedTransition] = []
    @IBOutlet var transitionBehaviourCollections: [TransitionBehaviourCollection] = []
    
}



// MARK: Experimental UIGestureRecognizer support

// This is not needed for regular transitions!
// Most of this boilerplate will likely be moved into the framework in future, with key vars exposed as IBInspectable.

extension DestinationViewController {

    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIGestureRecognizer?) {
        guard let
            panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
            let transition = transitioningDelegate as? BehaviourBasedTransition else { return }
        
        let rollBack = CGFloat(0.333)
        let translation = panGestureRecognizer.translation(in: view)
        let percent = max((1.0 * translation.y) / transition.maxDistance, 0.0)
        let location = panGestureRecognizer.location(in: view).y
        
        switch panGestureRecognizer.state {
        case .began:
            transition.isInteractive = true
            transition.maxDistance = view.frame.height - location
            dismiss(animated: true, completion: nil)
        case .changed:
            transition.update(percent)
        default: // .Ended, .Cancelled, .Failed ...
            transition.isInteractive = false
            if percent > rollBack {
                transition.finish()
            } else {
                transition.cancel()
            }
        }
    }
    
}

extension DestinationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        return panGestureRecognizer.velocity(in: view).y > 0
    }
    
}
