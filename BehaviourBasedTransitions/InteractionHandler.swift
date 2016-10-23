//
//  InteractionHandler.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

public class InteractionHandler: NSObject {
    
    @IBOutlet var gestureRecognizer: UIGestureRecognizer!
    
    @IBOutlet var sourceViewController: UIViewController?
    @IBOutlet var transition: BehaviourBasedTransition?
    
    @IBOutlet var destinationViewController: UIViewController?
    
    @IBInspectable var rollback: CGFloat = 0.3333
    
    public var isHandlerForPresentationTransition: Bool {
        return sourceViewController != nil
    }
    
    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIGestureRecognizer!) {
        guard gestureRecognizer == self.gestureRecognizer else { return }
        
        if let sourceViewController = sourceViewController, transition = transition {
            updateTransition(transition, presenting: true)
            
            if gestureRecognizer.state == .Began {
                sourceViewController.performSegueWithIdentifier(transition.segueIdentifier, sender: self)
            }
        }
        else if let destinationViewController = destinationViewController,
            let transition = destinationViewController.transitioningDelegate as? BehaviourBasedTransition
        {
            updateTransition(transition, presenting: false)
            
            if gestureRecognizer.state == .Began {
                destinationViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func updateTransition(transition: BehaviourBasedTransition, presenting: Bool) {
        let percent = calculatePercent()
        
        switch gestureRecognizer.state {
        case .Began:
            transition.isInteractive = true
            setupForGestureBegin()
            break
            
        case .Changed:
            transition.updateInteractiveTransition(percent)
            
        default:
            transition.isInteractive = false
            if percent > rollback {
                transition.finishInteractiveTransition()
            } else {
                transition.cancelInteractiveTransition()
            }
        }
    }
    
    func setupForGestureBegin() { }
    
    func calculatePercent() -> CGFloat {
        return 0
    }
    
    func shouldBeginPresentationTransition() -> Bool {
        return false
    }
    
    func shouldBeginDismissalTransition() -> Bool {
        return false
    }
    
}

extension InteractionHandler: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isHandlerForPresentationTransition {
            return shouldBeginPresentationTransition()
        } else {
            return shouldBeginDismissalTransition()
        }
    }
    
}
