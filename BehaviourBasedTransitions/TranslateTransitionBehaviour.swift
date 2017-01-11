//
//  TranslateTransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Moves a UIView from it's current position to a destination position without changing it's superview.
///
/// Typically used to move views away in the source UIViewController.
public class TranslateTransitionBehaviour: TransitionBehaviour {
    
    /// Start position relative to the size of the superview.
    ///
    /// {0,0} is the position of the UIView in the storyboard
    /// {1,1} is the full width of the `superview` right and the full height of the `superview` down
    /// {-1,-1} is the full width of the `superview` left and the full height of the `superview` up
    @IBInspectable var origin: CGPoint = CGPointZero
    
    /// Detination position relative to the size of the superview.
    ///
    /// {0,0} is the position of the UIView in the storyboard
    /// {1,1} is the full width of the `superview` right and the full height of the `superview` down
    /// {-1,-1} is the full width of the `superview` left and the full height of the `superview` up
    @IBInspectable public var destination: CGPoint = CGPointZero
    
    /// The superview used to calculate the relative origin and destination positions. This doesn't have to be a direct 
    /// ancestor of the view, but normally would be.
    @IBOutlet public weak var superview: UIView!
    

    override public func setup(container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewsForTransition.forEach { $0.transform = isPresenting ? originTransform() : destinationTransform() }
    }
    
    override public func addAnimations() {
        addAnimation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewsForTransition.forEach { $0.transform = strongSelf.isPresenting ? strongSelf.destinationTransform() : strongSelf.originTransform() }
        }
    }
    
    override public func complete(presented: Bool) {
        viewsForTransition.forEach { $0.transform = presented ? self.destinationTransform() : self.originTransform() }
    }
    
    private func originTransform() -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(superview.frame.width * origin.x, superview.frame.height * origin.y)
    }
    
    private func destinationTransform() -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(superview.frame.width * destination.x, superview.frame.height * destination.y)
    }
    
}
