//
//  MockTransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 28/10/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class MockTransitionBehaviour: TransitionBehaviour {
    
    var didSetup = false
    var didAddAnimations = false
    var completedPresentation: Bool?
    var destinationBehaviour: TransitionBehaviour?
    
    override func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour?) {
        didSetup = true
        self.destinationBehaviour = destinationBehaviour
    }
    
    override func addAnimations() {
        didAddAnimations = true
    }
    
    override func complete(_ presented: Bool) {
        completedPresentation = presented
    }

}
