//
//  ScaleTransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 31/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Scales a UIView from the `startSize` to the `endSize`.
open class ScaleTransitionBehaviour: TransitionBehaviour {
    
    @IBInspectable open var startSize: CGFloat = 1
    @IBInspectable open var endSize: CGFloat = 1
    
    override open func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewsForTransition.forEach { $0.transform = isPresenting ? startTransform() : endTransform() }
    }
    
    override open func addAnimations() {
        addAnimation {
            self.viewsForTransition.forEach { $0.transform = self.isPresenting ? self.endTransform() : self.startTransform() }
        }
    }
    
    override open func complete(_ presented: Bool) {
        viewsForTransition.forEach { $0.transform = presented ? self.endTransform() : self.startTransform() }
    }
    
    fileprivate func startTransform() -> CGAffineTransform {
        let sanitizedStartSize = startSize == 0 ? 0.0000001 : startSize
        return CGAffineTransform(scaleX: sanitizedStartSize, y: sanitizedStartSize)
    }
    
    fileprivate func endTransform() -> CGAffineTransform {
        let sanitizedEndSize = endSize == 0 ? 0.0000001 : endSize
        return CGAffineTransform(scaleX: sanitizedEndSize, y: sanitizedEndSize)
    }
    
}
