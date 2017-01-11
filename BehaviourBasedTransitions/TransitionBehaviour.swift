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
open class TransitionBehaviour: NSObject {
    
    /// The views the behaviour should effect
    @IBOutlet open var views: [UIView] = []
    
    /// The identifier of this behaviour. Normally not used, unless the particular behaviour has a corresponding
    /// destination `TransitionBehaviour` in another UIViewController. In which case the behaviourIdentifier values
    /// for each must be the same
    @IBInspectable open var behaviourIdentifier: String = ""
    
    /// **Expected Type: TransitionBehaviourViewProvider**
    ///
    /// Setting this will override the use of the `view` `IBOutlet`
    ///
    /// Type here is `AnyObject` due to this Xcode issue: [http://stackoverflow.com/a/26180481/281734](http://stackoverflow.com/a/26180481/281734)
    @IBOutlet open weak var viewProvider: AnyObject?
    
    /// Start time for the animation, relative to the overall transition duration (0...1)
    @IBInspectable open var relativeStartTime: Double = 0
    
    /// Duration for the animation, relative to the overall transition duration (0...1)
    @IBInspectable open var relativeDuration: Double = 1
    
    /// Spring damping, as per UIView.animateWithDuration docs
    @IBInspectable open var springDamping: CGFloat = 1
    
    /// Initial spring velocity, as per UIView.animateWithDuration docs
    @IBInspectable open var initialSpringVelocity: CGFloat = 0
    
    /// If true, will reverse the timing of the animation.
    ///
    /// So if a behaviour started at 0.25 and ended at 0.5 (duration 0.25), then on dismissal it would start at 0.5
    /// and end at 0.75
    @IBInspectable open var reverseTimingOnDismissal: Bool = false
    
    /// Easing curve for the animation. Maps to the curves in UIViewAnimationOptions.
    ///
    /// EaseInOut = 0
    /// EaseIn = 1
    /// EaseOut = 2
    /// Linear = 3
    @IBInspectable open var animationCurve: Int = 0
    
    
    // MARK: Enums

    enum AnimationCurve: Int {
        case easeInOut = 0
        case easeIn = 1
        case easeOut = 2
        case linear = 3
        
        func toUIViewAnimationOption() -> UIViewAnimationOptions {
            switch self {
            case .easeInOut: return UIViewAnimationOptions()
            case .easeIn: return .curveEaseIn
            case .easeOut: return .curveEaseOut
            case .linear: return .curveLinear
            }
        }
    }


    // MARK: Internal

    /// Set by setup function for calculation of relative start and duration times
    internal(set) open var transitionDuration: TimeInterval = 0
    
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
    open var isPresenting = false
    
    /// Returns true if the transition is being driven interactively
    open var isInteractive = false
    
    /// Used to tell the transition when animation ends
    open var animationCompleted: (() -> ())?
    
    /// Extend this func to set up your viewForTransition for animation to start
    open func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour?) {}
    
    /// Override this func to add animations, using your own `UIView.animate` calls or using the provided
    /// `addAnimation` func which gives you built in handling of start time and duration
    open func addAnimations() {}
    
    /// Override this func to clean up or reset your views at the end of the transition animation
    ///
    /// Note: this takes care of transition cancellation for you. For example, if you're presenting and it's cancelled,
    /// then this callback will be called with `presented == false`
    open func complete(_ presented: Bool) {}
    
    /// Adds an animation with appropriate handling of start and duration times. The times passed in here will be relative
    /// to the time of the `TransitionBehaviour`, which in turn is relative to the duration of the whole transition
    public final func addAnimation(_ startTime: TimeInterval = 0, duration: TimeInterval = 1, animation: @escaping () -> ()) {
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
            
            UIView.animateKeyframes(
                withDuration: transitionDuration,
                delay: 0,
                options: [.allowUserInteraction],
                animations: { 
                    UIView.addKeyframe(
                        withRelativeStartTime: delayForAnim,
                        relativeDuration: durationForAnim,
                        animations: animation
                    )
                },
                completion: { [weak self] _ in self?.animationCompleted?() }
            )
        } else {
            let durationForAnim = (isReverse ? reverseDuration : forwardDuration) * transitionDuration
            let delayForAnim = (isReverse ? reverseStartTime : forwardStartTime) * transitionDuration

            let animCurve = AnimationCurve(rawValue: animationCurve) ?? .easeInOut

            // Animation behaviour changes if we specify damping or velocity, even if they are 0
            if springDamping != 1 || initialSpringVelocity != 0 {
                UIView.animate(
                    withDuration: durationForAnim,
                    delay: delayForAnim,
                    usingSpringWithDamping: springDamping,
                    initialSpringVelocity: initialSpringVelocity,
                    options: [animCurve.toUIViewAnimationOption(), .allowUserInteraction],
                    animations: animation,
                    completion: { [weak self] _ in self?.animationCompleted?() })
            } else {
                UIView.animate(
                    withDuration: durationForAnim,
                    delay: delayForAnim,
                    options: [animCurve.toUIViewAnimationOption(), .allowUserInteraction],
                    animations: animation,
                    completion: { [weak self] _ in self?.animationCompleted?() })
            }
        }
    }
    
    fileprivate func clampedTimes(_ startTime: TimeInterval, _ duration: TimeInterval) -> (TimeInterval, TimeInterval, TimeInterval) {
        let clampedStartTime = min(startTime, 1)
        let clampedDuration = min(duration, 1 - clampedStartTime)
        let finishTime = clampedStartTime + clampedDuration

        return (clampedStartTime, clampedDuration, finishTime)
    }
    
    func transitionCompleted(_ wasCancelled: Bool) {
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
    
    func viewsForBehaviour(identifier: String) -> [UIView]
    
}
