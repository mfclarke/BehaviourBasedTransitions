//
//  ScaleTransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 31/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Scales a UIView from the ```startSize``` to the ```endSize```.
public class ScaleTransitionBehaviour: TransitionBehaviour {
    
    @IBInspectable public var startSize: CGFloat = 1
    @IBInspectable public var endSize: CGFloat = 1
    
    override func setup(container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewForTransition?.transform = isPresenting ? startTransform() : endTransform()
    }
    
    override func addAnimations() {
        addAnimation {
            self.viewForTransition?.transform = self.isPresenting ? self.endTransform() : self.startTransform()
        }
    }
    
    override func complete() {
        viewForTransition?.transform = CGAffineTransformIdentity
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
