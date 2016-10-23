//
//  PanGestureInteractable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

public protocol PanGestureInteractable {
    func updateTransitionForPanGestureChange(gestureRecognizer: UIPanGestureRecognizer)
}

public extension PanGestureInteractable where Self: UIViewController, Self: BehaviourTransitionable {
    
    public func updateTransitionForPanGestureChange(gestureRecognizer: UIPanGestureRecognizer) {
        if let transition = presentingTransition(forGestureRecognizer: gestureRecognizer) {
            transition.updateForGestureChange(panGestureRecognizer: gestureRecognizer, presenting: true)
            if gestureRecognizer.state == .Began {
                performSegueWithIdentifier(transition.segueIdentifier, sender: self)
            }
        }
        else if let transition = dismissingTransition(forGestureRecognizer: gestureRecognizer) {
            transition.updateForGestureChange(panGestureRecognizer: gestureRecognizer, presenting: false)
            if gestureRecognizer.state == .Began {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    private func presentingTransition(forGestureRecognizer gestureRecognizer: UIGestureRecognizer) -> BehaviourBasedTransition? {
        return self.transitions.filter({ $0.panGestureRecognizer == gestureRecognizer }).first
    }
    
    private func dismissingTransition(forGestureRecognizer gestureRecognizer: UIGestureRecognizer) -> BehaviourBasedTransition? {
        return transitioningDelegate as? BehaviourBasedTransition
    }
    
}
