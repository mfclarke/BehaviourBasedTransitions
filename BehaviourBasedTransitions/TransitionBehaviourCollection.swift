//
//  TransitionBehaviourCollection.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Used to group `TransitionBehaviour`s together under a single `transitionIdentifier`
open class TransitionBehaviourCollection: NSObject {
    
    /// The identifier the `TransitionBehaviour`s belong to
    @IBInspectable open var transitionIdentifier: String = ""
    
    // The behaviours for the `transitionIdentifier`
    @IBOutlet open var behaviours: [TransitionBehaviour] = []
    
}
