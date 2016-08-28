//
//  BehaviourTransitionable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Used by ```BehaviourBasedTransition```s to get access to the correct ```TransitionBehaviour```s for animation
protocol BehaviourTransitionable {
    
    /// Array of collections, which should each be assigned a unique ```transitionIdentifier``` that matches the
    /// ```BehaviourBasedTransition``` they should be used in
    var transitionBehaviourCollections: [TransitionBehaviourCollection] { get set }
}
