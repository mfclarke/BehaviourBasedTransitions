//
//  TransformToPositionSourceBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class TransformToPositionSourceBehaviour: TransitionBehaviour {
    
    @IBInspectable var behaviourIdentifier: String = ""
    var destinationFrame: CGRect?
    
    override func setup(presenting presenting: Bool, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(presenting: presenting)
        destinationFrame = destinationBehaviour?.viewForTransition?.frame
        
        if let destinationFrame = destinationFrame {
            let destinationTransform = CGAffineTransformMakeTranslation(destinationFrame.origin.x, destinationFrame.origin.y)
            viewForTransition?.transform = isPresenting ? CGAffineTransformIdentity : destinationTransform
        }
    }
    
    override func animate() {
        if let destinationFrame = destinationFrame {
            let destinationTransform = CGAffineTransformMakeTranslation(destinationFrame.origin.x, destinationFrame.origin.y)
            viewForTransition?.transform = isPresenting ? CGAffineTransformIdentity : destinationTransform
        }
    }
    
    override func complete() {
        viewForTransition?.transform = CGAffineTransformIdentity
    }
    
}

class TransformToPositionDestinationBehaviour: TransitionBehaviour {
    
    @IBInspectable var behaviourIdentifier: String = ""
    
}
