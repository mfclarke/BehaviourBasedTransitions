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
open class TranslateTransitionBehaviour: TransitionBehaviour {
    
    /// Start position relative to the size of the superview.
    ///
    /// {0,0} is the position of the UIView in the storyboard
    /// {1,1} is the full width of the `superview` right and the full height of the `superview` down
    /// {-1,-1} is the full width of the `superview` left and the full height of the `superview` up
    @IBInspectable var origin: CGPoint = CGPoint.zero
    
    /// Detination position relative to the size of the superview.
    ///
    /// {0,0} is the position of the UIView in the storyboard
    /// {1,1} is the full width of the `superview` right and the full height of the `superview` down
    /// {-1,-1} is the full width of the `superview` left and the full height of the `superview` up
    @IBInspectable open var destination: CGPoint = CGPoint.zero
    
    /// The superview used to calculate the relative origin and destination positions. This doesn't have to be a direct 
    /// ancestor of the view, but normally would be.
    @IBOutlet open weak var superview: UIView!
    

    override open func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour?) {
        viewsForTransition.forEach { $0.transform = isPresenting ? originTransform() : destinationTransform() }
    }
    

    override open func addAnimations() {
        addAnimation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.viewsForTransition.forEach { $0.transform = strongSelf.isPresenting ? strongSelf.destinationTransform() : strongSelf.originTransform() }
        }
    }
    
    override open func complete(_ presented: Bool) {
        viewsForTransition.forEach { $0.transform = presented ? self.destinationTransform() : self.originTransform() }
    }
    
    fileprivate func originTransform() -> CGAffineTransform {
        return CGAffineTransform(translationX: superview.frame.width * origin.x, y: superview.frame.height * origin.y)
    }
    
    fileprivate func destinationTransform() -> CGAffineTransform {
        return CGAffineTransform(translationX: superview.frame.width * destination.x, y: superview.frame.height * destination.y)
    }
    
}
