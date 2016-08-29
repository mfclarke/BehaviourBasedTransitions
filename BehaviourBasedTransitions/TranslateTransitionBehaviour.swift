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
    /// {1,1} is the full width of the ```superview``` right and the full height of the ```superview``` down
    /// {-1,-1} is the full width of the ```superview``` left and the full height of the ```superview``` up
    @IBInspectable var origin: CGPoint = CGPointZero
    
    /// Detination position relative to the size of the superview.
    ///
    /// {0,0} is the position of the UIView in the storyboard
    /// {1,1} is the full width of the ```superview``` right and the full height of the ```superview``` down
    /// {-1,-1} is the full width of the ```superview``` left and the full height of the ```superview``` up
    @IBInspectable public var destination: CGPoint = CGPointZero
    
    /// The superview used to calculate the relative origin and destination positions. This doesn't have to be a direct 
    /// ancestor of the view, but normally would be.
    @IBOutlet public var superview: UIView!
    

    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        
        viewForTransition?.transform = isPresenting ? originTransform() : destinationTransform()
    }
    
    override func addAnimationKeyFrames() {
        addKeyFrame {
            self.viewForTransition?.transform = self.isPresenting ? self.destinationTransform() : self.originTransform()
        }
    }
    
    override func complete() {
        viewForTransition?.transform = CGAffineTransformIdentity
    }
    
    private func originTransform() -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(superview.frame.width * origin.x, superview.frame.height * origin.y)
    }
    
    private func destinationTransform() -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(superview.frame.width * destination.x, superview.frame.height * destination.y)
    }
    
}
