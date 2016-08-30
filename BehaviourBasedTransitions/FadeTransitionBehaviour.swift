//
//  FadeTransitionBehaviours.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Fades a UIView from one alpha value to another
public class FadeTransitionBehaviour: TransitionBehaviour {
    
    /// Fade from this value
    @IBInspectable public var fromAlpha: CGFloat = 0
    
    /// Fade to this value
    @IBInspectable public var toAlpha: CGFloat = 0
    
    override func setup(presenting presenting: Bool, transitionDuration: NSTimeInterval, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, transitionDuration: transitionDuration, container: container, destinationBehaviour: destinationBehaviour)
        viewForTransition?.alpha = isPresenting ? fromAlpha : toAlpha
    }
    
    override func addAnimations() {
        addAnimation { self.applyAnimation() }
    }
    
    private func applyAnimation() {
        viewForTransition?.alpha = isPresenting ? toAlpha : fromAlpha
    }
    
    override func complete() {
        viewForTransition?.alpha = isPresenting ? toAlpha : fromAlpha
    }
    
}
