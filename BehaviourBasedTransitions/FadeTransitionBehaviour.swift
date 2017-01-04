//
//  FadeTransitionBehaviours.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Fades a UIView from one alpha value to another
open class FadeTransitionBehaviour: TransitionBehaviour {
    
    /// Fade from this value
    @IBInspectable open var fromAlpha: CGFloat = 0
    
    /// Fade to this value
    @IBInspectable open var toAlpha: CGFloat = 0
    
    override open func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewsForTransition.forEach { $0.alpha = isPresenting ? fromAlpha : toAlpha }
    }
    
    override open func addAnimations() {
        addAnimation { self.applyAnimation() }
    }
    
    fileprivate func applyAnimation() {
        viewsForTransition.forEach { $0.alpha = isPresenting ? toAlpha : fromAlpha }
    }
    
    override open func complete(_ presented: Bool) {
        viewsForTransition.forEach { $0.alpha = presented ? toAlpha : fromAlpha }
    }
    
}
