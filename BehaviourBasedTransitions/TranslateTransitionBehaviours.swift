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
class TranslateToTransitionBehaviour: TransitionBehaviour {
    
    /// Destination position relative to the size of the superview.
    ///
    ///```{0,0}``` is the top left corner, ```{1,1}``` is the bottom right corner
    @IBInspectable var destination: CGPoint = CGPointZero
    
    /// The superview used to calculate the relative destination position. This doesn't have to be a direct parent
    /// of the view, but normally would be.
    @IBOutlet var superview: UIView!
    

    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        
        viewForTransition.transform = isPresenting ? CGAffineTransformIdentity : destinationTransform()
    }
    
    override func addAnimationKeyFrames() {
        UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1) {
            self.applyAnimation()
        }
    }
    
    private func applyAnimation() {
        viewForTransition.transform = isPresenting ? destinationTransform() : CGAffineTransformIdentity
    }
    
    override func complete() {
        viewForTransition.transform = CGAffineTransformIdentity
    }
    
    private func destinationTransform() -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(superview.frame.width * destination.x, superview.frame.height * destination.y)
    }
    
}


/// Moves a UIView from a specified origin position to it's regular position in the Storyboard without changing it's superview.
///
/// Typically used to move views into place in the destination UIViewController.
class TranslateFromTransitionBehaviour: TransitionBehaviour {
    
    /// Start position relative to the size of the superview.
    ///
    ///```{0,0}``` is the top left corner, {1,1} is the bottom right corner
    @IBInspectable var origin: CGPoint = CGPointZero
    
    /// The superview to use to calculate the relative destination position. This doesn't have to be a direct parent
    /// of the view, but normally would be
    @IBOutlet var superview: UIView!
    
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        
        viewForTransition.transform = isPresenting ? originTransform() : CGAffineTransformIdentity
    }
    
    override func addAnimationKeyFrames() {
        UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1) {
            self.applyAnimation()
        }
    }
    
    private func applyAnimation() {
        viewForTransition.transform = isPresenting ? CGAffineTransformIdentity : originTransform()
    }
    
    override func complete() {
        viewForTransition.transform = CGAffineTransformIdentity
    }
    
    private func originTransform() -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(superview.frame.width * origin.x, superview.frame.height * origin.y)
    }
    
}
