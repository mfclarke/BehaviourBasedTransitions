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
    
    /// The views the behaviour should effect
    @IBOutlet public var views: [UIView] = []
    
    /// The identifier of this behaviour. Normally not used, unless the particular behaviour has a corresponding
    /// destination `TransitionBehaviour` in another UIViewController. In which case the behaviourIdentifier values
    /// for each must be the same
    @IBInspectable public var behaviourIdentifier: String = ""
    
    /// **Expected Type: TransitionBehaviourViewProvider**
    /// 
    /// Setting this will override the use of the `view` `IBOutlet`
    /// 
    /// Type here is `AnyObject` due to this Xcode issue: [http://stackoverflow.com/a/26180481/281734](http://stackoverflow.com/a/26180481/281734)
    @IBOutlet public var viewProvider: AnyObject?
    
    /// Start time for the animation, relative to the overall transition duration (0...1)
    @IBInspectable public var relativeStartTime: Double = 0
    
    /// Duration for the animation, relative to the overall transition duration (0...1)
    @IBInspectable public var relativeDuration: Double = 1
    
    /// Spring damping, as per UIView.animateWithDuration docs
    @IBInspectable public var springDamping: CGFloat = 1
    
    /// Initial spring velocity, as per UIView.animateWithDuration docs
    @IBInspectable public var initialSpringVelocity: CGFloat = 0
    
    /// If true, will reverse the timing of the animation.
    /// 
    /// So if a behaviour started at 0.25 and ended at 0.5 (duration 0.25), then on dismissal it would start at 0.5
    /// and end at 0.75
    @IBInspectable public var reverseTimingOnDismissal: Bool = false
    
    /// Easing curve for the animation. Maps to the curves in UIViewAnimationOptions.
    ///
    /// EaseInOut = 0
    /// EaseIn = 1
    /// EaseOut = 2
    /// Linear = 3
    @IBInspectable public var animationCurve: Int = 0
    
    
    // MARK: Enums
    
    enum AnimationCurve: Int {
        case EaseInOut = 0
        case EaseIn = 1
        case EaseOut = 2
        case Linear = 3
        
        func toUIViewAnimationOption() -> UIViewAnimationOptions {
            switch self {
            case EaseInOut: return .CurveEaseInOut
            case EaseIn: return .CurveEaseIn
            case EaseOut: return .CurveEaseOut
            case Linear: return .CurveLinear
            }
        }
    }
    
    
    // MARK: Internal
    
    /// Set by setup function for calculation of relative start and duration times
    var transitionDuration: NSTimeInterval = 0
    
    /// Returns the views to use for the transition. If there's a viewsProvider connected, the viewsProvider must provide the views.
    /// If no delegate connected, it will use the views `IBOutlet` collection.
    public final var viewsForTransition: [UIView] {
        if let viewProvider = viewProvider as? TransitionBehaviourViewProvider {
            return viewProvider.viewsForBehaviour(identifier: behaviourIdentifier)
        } else {
            return views
        }
    }
    
    /// Returns true if the transition is presenting rather than dismissing. 
    /// Set up by the BehaviourBasedTransition object.
    public var isPresenting = false
    
    /// Returns true if the transition is being driven interactively
    public var isInteractive = false
    
    /// Used to tell the transition when animation ends
    public var animationCompleted: (() -> ())?
    
    /// Extend this func to set up your viewForTransition for animation to start
    public func setup(container: UIView, destinationBehaviour: TransitionBehaviour?) {}
    
    /// Override this func to add animations, using your own `UIView.animate` calls or using the provided
    /// `addAnimation` func which gives you built in handling of start time and duration
    public func addAnimations() {}
    
    /// Override this func to clean up or reset your views at the end of the transition animation
    ///
    /// Note: this takes care of transition cancellation for you. For example, if you're presenting and it's cancelled,
    /// then this callback will be called with `presented == false`
    public func complete(presented: Bool) {}
    
    /// Adds an animation with appropriate handling of start and duration times. The times passed in here will be relative
    /// to the time of the `TransitionBehaviour`, which in turn is relative to the duration of the whole transition
    public final func addAnimation(startTime: NSTimeInterval = 0, duration: NSTimeInterval = 1, animation: () -> ()) {
        let (animStartTime, animDuration, animFinishTime) = clampedTimes(startTime, duration)
        let (behaviourStartTime, behaviourDuration, behaviourFinishTime) = clampedTimes(relativeStartTime, relativeDuration)
        
        let forwardStartTime = behaviourStartTime + (animStartTime * behaviourDuration)
        let forwardDuration = min(behaviourDuration * animDuration, behaviourDuration)
        let forwardFinishTime = behaviourFinishTime * animFinishTime
        
        let reverseStartTime = 1 - forwardFinishTime
        let reverseDuration = min(forwardDuration, 1 - forwardStartTime)
        
        let isReverse = (!isPresenting && reverseTimingOnDismissal)
        
        if isInteractive {
            let durationForAnim = (isReverse ? reverseDuration : forwardDuration)
            let delayForAnim = (isReverse ? reverseStartTime : forwardStartTime)
            
            UIView.animateKeyframesWithDuration(
                transitionDuration,
                delay: 0,
                options: [.AllowUserInteraction],
                animations: { 
                    UIView.addKeyframeWithRelativeStartTime(
                        delayForAnim,
                        relativeDuration: durationForAnim,
                        animations: animation
                    )
                },
                completion: { _ in self.animationCompleted?() }
            )
        } else {
            let durationForAnim = (isReverse ? reverseDuration : forwardDuration) * transitionDuration
            let delayForAnim = (isReverse ? reverseStartTime : forwardStartTime) * transitionDuration
            let animCurve = AnimationCurve(rawValue: animationCurve) ?? .EaseInOut
            
            UIView.animateWithDuration(
                durationForAnim,
                delay: delayForAnim,
                usingSpringWithDamping: springDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: [animCurve.toUIViewAnimationOption(), .AllowUserInteraction],
                animations: animation,
                completion: { _ in self.animationCompleted?() })
        }
    }
    
    private func clampedTimes(startTime: NSTimeInterval, _ duration: NSTimeInterval) -> (NSTimeInterval, NSTimeInterval, NSTimeInterval) {
        let clampedStartTime = min(startTime, 1)
        let clampedDuration = min(duration, 1 - clampedStartTime)
        let finishTime = clampedStartTime + clampedDuration
        
        return (clampedStartTime, clampedDuration, finishTime)
    }
    
    func transitionCompleted(wasCancelled: Bool) {
        if isPresenting {
            if !wasCancelled {
                complete(true)
            } else {
                complete(false)
            }
        } else {
            if !wasCancelled {
                complete(false)
            } else {
                complete(true)
            }
        }
    }
    
}

/// Allows an object to dynamically provide the right view for the behaviour. Used for views that are created dynamically
/// like `UITableView`s or `UICollectionView`s, views loaded from xibs, embedded controllers etc. 
///
/// You can use this to provide a UICollectionViewCell's subview to a behaviour for example.
public protocol TransitionBehaviourViewProvider {
    
    func viewsForBehaviour(identifier identifier: String) -> [UIView]
    
}
