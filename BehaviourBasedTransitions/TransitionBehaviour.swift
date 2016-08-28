//
//  TransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// An abstract class for implementation of IB behaviours that execute during a transition. Subclass this to provide
/// a specific behaviour to use on a single view in a UIViewControllerAnimatedTransitioning animation
public class TransitionBehaviour: NSObject {
    
    /// The view the behaviour should effect
    @IBOutlet public var view: UIView!
    
    /// The identifier of this behaviour. Normally not used, unless the particular behaviour has a corresponding
    /// destination ```TransitionBehaviour``` in another UIViewController. In which case the behaviourIdentifier values
    /// for each must be the same
    @IBInspectable public var behaviourIdentifier: String = ""
    
    /// Optional TransitionBehaviourViewProvider for the behaviour. Type here is ```AnyObject``` due to this Xcode
    /// issue: http://stackoverflow.com/a/26180481/281734
    @IBOutlet public var viewProvider: AnyObject?
    
    /// Start time for the animation, relative to the overall transition duration (0..1)
    @IBInspectable public var relativeStartTime: Double = 0
    
    /// Duration for the animation, relative to the overall transition duration (0..1)
    @IBInspectable public var relativeDuration: Double = 1
    
    @IBInspectable public var reverseKeyFrameTimingOnDismissal: Bool = false
    
    /// Returns the view to use for the transition. If there's a viewProvider connected, the viewProvider must provide the view.
    /// If no delegate connected, it will use the view ```IBOutlet```.
    var viewForTransition: UIView? {
        if let viewProvider = viewProvider as? TransitionBehaviourViewProvider {
            return viewProvider.viewForBehaviour(identifier: behaviourIdentifier)
        } else {
            return view
        }
    }
    
    /// Returns true if the transition is presenting rather than dismissing. 
    /// Set up by the BehaviourBasedTransition object.
    var isPresenting = false
    
    /// Extend this func to set up your viewForTransition for animation to start
    func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour?) {
        isPresenting = presenting
    }
    
    /// Override this func to add animation key frames. Use ```UIView.addKeyframeWithRelativeStartTime``` or other
    /// functions that can work inside ```UIView.animateKeyframesWithDuration```
    func addAnimationKeyFrames() {}
    
    /// Override this func to clean up or reset your views at the end of the transition animation
    func complete() {}
    
    func addKeyFrame(animations: () -> ()) {
        let startTime = reverseKeyFrameTimingOnDismissal && !isPresenting ?
            (1 - relativeStartTime - relativeDuration) :
            relativeStartTime
        UIView.addKeyframeWithRelativeStartTime(startTime, relativeDuration: relativeDuration) {
            animations()
        }
    }
    
}

/// Allows an object to dynamically provide the right view for the behaviour. Used for views that are created dynamically
/// like ```UITableView```s or ```UICollectionView```s, views loaded from xibs, embedded controllers etc. 
///
/// You can use this to provide a UICollectionViewCell's subview to a behaviour for example.
public protocol TransitionBehaviourViewProvider {
    
    func viewForBehaviour(identifier identifier: String) -> UIView?
    
}
