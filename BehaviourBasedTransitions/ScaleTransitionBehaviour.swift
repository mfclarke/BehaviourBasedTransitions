//
//  ScaleTransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 31/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Scales a UIView from the `startSize` to the `endSize`.
public class ScaleTransitionBehaviour: TransitionBehaviour {
    
    @IBInspectable public var startSize: CGFloat = 1
    @IBInspectable public var endSize: CGFloat = 1
    
    override public func setup(container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewsForTransition.forEach { $0.transform = isPresenting ? startTransform() : endTransform() }
    }
    
    override public func addAnimations() {
        addAnimation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewsForTransition.forEach { $0.transform = strongSelf.isPresenting == true ? strongSelf.endTransform() : strongSelf.startTransform() }
        }
    }
    
    override public func complete(presented: Bool) {
        viewsForTransition.forEach { $0.transform = presented ? self.endTransform() : self.startTransform() }
    }
    
    private func startTransform() -> CGAffineTransform {
        let sanitizedStartSize = startSize == 0 ? 0.0000001 : startSize
        return CGAffineTransformMakeScale(sanitizedStartSize, sanitizedStartSize)
    }
    
    private func endTransform() -> CGAffineTransform {
        let sanitizedEndSize = endSize == 0 ? 0.0000001 : endSize
        return CGAffineTransformMakeScale(sanitizedEndSize, sanitizedEndSize)
    }
    
}
