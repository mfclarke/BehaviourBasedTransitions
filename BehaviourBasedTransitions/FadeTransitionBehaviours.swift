//
//  FadeTransitionBehaviours.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class FadeInTransitionBehaviour: TransitionBehaviour {
    
    override func setup(presenting presenting: Bool) {
        super.setup(presenting: presenting)
        view.alpha = isPresenting ? 0 : 1
    }
    
    override func animate() {
        view.alpha = isPresenting ? 1 : 0
    }
    
    override func complete() {
        view.alpha = isPresenting ? 1 : 0
    }
    
}

class FadeOutTransitionBehaviour: TransitionBehaviour {
    
    override func setup(presenting presenting: Bool) {
        super.setup(presenting: presenting)
        view.alpha = isPresenting ? 1 : 0
    }
    
    override func animate() {
        view.alpha = isPresenting ? 0 : 1
    }
    
    override func complete() {
        view.alpha = isPresenting ? 0 : 1
    }
    
}
