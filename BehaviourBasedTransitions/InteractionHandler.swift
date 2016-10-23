//
//  InteractionHandler.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Abstract class to encapsulate common logic for using `UIGestureRecognizer`s to drive interactive transitions 
public class InteractionHandler: NSObject {
    
    /// The gesture recognizer to handle
    @IBOutlet var gestureRecognizer: UIGestureRecognizer!
    
    /// The source view controller for the interactive transition.
    /// Only has to be connected if the recognizer is for a presentation transition
    @IBOutlet var sourceViewController: UIViewController?
    
    /// The interactive transition
    /// Only has to be connected if the recognizer is for a presentation transition
    @IBOutlet var transition: BehaviourBasedTransition?
    
    /// The destination view controller for the interactive transition.
    /// Only has to be connected if the recognizer is for a dismissal transition
    @IBOutlet var destinationViewController: UIViewController?
    
    /// The percent threshold for a transition to complete if the interaction stops before completion
    /// The transition will rollback to the initial state if the interaction percent progress is below this value
    @IBInspectable var rollback: CGFloat = 0.3333
    
    /// Returns true if the `sourceViewController` is connected
    public var isHandlerForPresentationTransition: Bool {
        return sourceViewController != nil
    }
    
    /// Should be connected to the gesture recognizer's action
    /// Used to trigger the segue/dismiss, and update the transition progress
    @IBAction public func panGestureChanged(withGestureRecognizer gestureRecognizer: UIGestureRecognizer!) {
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
    
    
    // MARK: Subclass callbacks
    
    /// Called when the recognizer begins, for any specific setup. For example, using the start location of a touch
    /// to work out the distance the user must swipe for interaction to complete
    public func setupForGestureBegin() { }
    
    /// Should return the progress of the interaction, based on values from the connected gesture recognizer
    public func calculatePercent() -> CGFloat {
        return 0
    }
    
    /// Return true if the gesture recognizer is in a state that should start a presentation transition
    public func shouldBeginPresentationTransition() -> Bool {
        return false
    }
    
    /// Return true if the gesture recognizer is in a state that should start a dismissal transition
    public func shouldBeginDismissalTransition() -> Bool {
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

extension InteractionHandler {
    
    private func updateTransition(transition: BehaviourBasedTransition, presenting: Bool) {
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
    
}
