//
//  TranslateTransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class TranslateToTransitionBehaviour: TransitionBehaviour {
    
    @IBInspectable var destination: CGPoint = CGPointZero
    @IBOutlet var superview: UIView!
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        let destinationTransform = CGAffineTransformMakeTranslation(superview.frame.width * destination.x, superview.frame.height * destination.y)
        viewForTransition?.transform = isPresenting ? CGAffineTransformIdentity : destinationTransform
    }
    
    override func animate() {
        let destinationTransform = CGAffineTransformMakeTranslation(superview.frame.width * destination.x, superview.frame.height * destination.y)
        viewForTransition?.transform = isPresenting ? destinationTransform : CGAffineTransformIdentity
    }
    
    override func complete() {
        viewForTransition?.transform = CGAffineTransformIdentity
    }
    
}

class TranslateFromTransitionBehaviour: TransitionBehaviour {
    
    @IBInspectable var origin: CGPoint = CGPointZero
    @IBOutlet var superview: UIView!
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        let originTransform = CGAffineTransformMakeTranslation(superview.frame.width * origin.x, superview.frame.height * origin.y)
        viewForTransition?.transform = isPresenting ? originTransform : CGAffineTransformIdentity
    }
    
    override func animate() {
        let originTransform = CGAffineTransformMakeTranslation(superview.frame.width * origin.x, superview.frame.height * origin.y)
        viewForTransition?.transform = isPresenting ? CGAffineTransformIdentity : originTransform
    }
    
    override func complete() {
        viewForTransition?.transform = CGAffineTransformIdentity
    }
    
}
