//
//  FadeTransitionBehaviours.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Fades a UIView in
public class FadeInTransitionBehaviour: TransitionBehaviour {
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        viewForTransition?.alpha = isPresenting ? 0 : 1
    }
    
    override func addAnimationKeyFrames() {
        addKeyFrame(applyAnimation)
    }
    
    private func applyAnimation() {
        viewForTransition?.alpha = isPresenting ? 1 : 0
    }
    
    override func complete() {
        viewForTransition?.alpha = isPresenting ? 1 : 0
    }
    
}

/// Fades a UIView out
public class FadeOutTransitionBehaviour: TransitionBehaviour {
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        viewForTransition?.alpha = isPresenting ? 1 : 0
    }
    
    override func addAnimationKeyFrames() {
        addKeyFrame(applyAnimation)
    }
    
    private func applyAnimation() {
        viewForTransition?.alpha = isPresenting ? 0 : 1
    }
    
    override func complete() {
        viewForTransition?.alpha = isPresenting ? 0 : 1
    }
    
}
