//
//  BehaviourTransitionable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Used by ```BehaviourBasedTransition```s to get access to the correct ```TransitionBehaviour```s for animation
public protocol BehaviourTransitionable {
    
    /// Array of transitions that this view controller is the source for
    var transitions: [BehaviourBasedTransition] { get set }
    
    /// Array of collections, which should each be assigned a unique ```transitionIdentifier``` that matches the
    /// ```BehaviourBasedTransition``` they should be used in
    var transitionBehaviourCollections: [TransitionBehaviourCollection] { get set }
}

public extension BehaviourTransitionable {
    
    /// Helper method to handle logic for assigning the correct transition for the segue
    public func prepareSegueForTransition(segue: UIStoryboardSegue) {
        segue.destinationViewController.transitioningDelegate = transitions.filter { $0.segueIdentifier == segue.identifier }.first
    }
    
}
