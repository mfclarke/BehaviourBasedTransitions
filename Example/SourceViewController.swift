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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        prepareSegueForTransition(segue)
    }
    
    @IBAction func unwindToViewController(withSender sender: UIStoryboardSegue) {}
    
    @IBAction func dismiss(withSender sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



// MARK: Experimental UIGestureRecognizer support

// This is not needed for regular transitions! 
// Most of this boilerplate will likely be moved into the framework in future, with key vars exposed as IBInspectable.

extension SourceViewController {

    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIGestureRecognizer?) {
        guard let
            panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
            let transition = self.transitions.first else { return }
        
        let rollBack = CGFloat(0.333)
        let translation = panGestureRecognizer.translation(in: view)
        let percent = max((-1.0 * translation.y) / transition.maxDistance, 0.0)
        let location = panGestureRecognizer.location(in: view).y
        
        switch panGestureRecognizer.state {
        case .began:
            transition.isInteractive = true
            transition.maxDistance = location
            performSegue(withIdentifier: "Transition1", sender: self)
            
        case .changed:
            transition.update(percent)
            
        default:
            transition.isInteractive = false
            if percent > rollBack {
                transition.finish()
            } else {
                transition.cancel()
            }
        }
    }

}


extension SourceViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        return panGestureRecognizer.velocity(in: view).y < 0
    }
    
}
