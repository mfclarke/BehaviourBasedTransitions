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
    
    override public func setup(container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewsForTransition.forEach { $0.alpha = isPresenting ? fromAlpha : toAlpha }
    }
    
    override public func addAnimations() {
        addAnimation { [weak self] in self?.applyAnimation() }
    }
    
    private func applyAnimation() {
        viewsForTransition.forEach { $0.alpha = isPresenting ? toAlpha : fromAlpha }
    }
    
    override public func complete(presented: Bool) {
        viewsForTransition.forEach { $0.alpha = presented ? toAlpha : fromAlpha }
    }
    
}
