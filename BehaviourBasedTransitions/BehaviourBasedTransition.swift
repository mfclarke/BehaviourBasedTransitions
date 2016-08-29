//
//  BehaviourBasedTransition.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/16.
//  Copyright (c) 2016 Max Dev Ltd. All rights reserved.
//

import UIKit

/// Animates a UIViewController transition using ```TransitionBehaviour``` objects, typically set up in the Storyboard.
///
/// Either or both ```UIViewController```s should conform to the ```BehaviourTransitionable``` protocol, to provide the
/// ```TransitionBehaviour```s used in the transition, via ```TransitionBehaviourCollection```s.
///
/// Each ```BehaviourBasedTransition``` should have a unique transitionIdentifier, which is used to get the correct
/// ```TransitionBehaviour``` for the transition via the ```UIViewController```s ```TransitionBehaviourCollection```s.
public class BehaviourBasedTransition: NSObject {
    
    // MARK: IBInspectable vars
    
    /// Unique identifier for the transition
    @IBInspectable public var transitionIdentifier: String = ""
    
    /// Segue identifier that should use the transition
    @IBInspectable public var segueIdentifier: String = ""
    
    /// Duration of the transition
    @IBInspectable public var duration: Double = 0.5
    
    /// Easing curve for the transition. Maps to the curves in UIViewAnimationOptions.
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
        
        func toUIViewKeyframeAnimationOptions() -> UIViewKeyframeAnimationOptions {
            switch self {
            case EaseInOut: return UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseInOut.rawValue)
            case EaseIn: return UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseIn.rawValue)
            case EaseOut: return UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseOut.rawValue)
            case Linear: return UIViewKeyframeAnimationOptions(rawValue: UIViewAnimationOptions.CurveLinear.rawValue)
            }
        }
    }
    
    
    // MARK: Private
    
    private var isPresenting = false
    
}

extension BehaviourBasedTransition: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            container = transitionContext.containerView(),
            fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        if isPresenting {
            container.addSubview(toController.view)
        } else {
            container.insertSubview(toController.view, belowSubview: fromController.view)
        }
        
        let behaviours = setupBehaviours(fromController, toController: toController, container: container)
        let animCurve = (AnimationCurve(rawValue: animationCurve) ?? .EaseInOut).toUIViewKeyframeAnimationOptions()
        
        UIView.animateKeyframesWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            options: [animCurve],
            animations: { 
                behaviours.forEach { $0.addAnimationKeyFrames() }
            },
            completion: { completed in
                behaviours.forEach { $0.complete() }
                
                transitionContext.completeTransition(true)
            }
        )
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    // TODO: Handle interactive transitions
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

private extension BehaviourBasedTransition {
    
    func setupBehaviours(fromController: UIViewController, toController: UIViewController, container: UIView) -> [TransitionBehaviour] {
        if isPresenting {
            toController.view.hidden = true
            toController.view.layoutIfNeeded()
        }
        
        let sourceBehaviours = isPresenting ? behavioursFromController(fromController) : behavioursFromController(toController)
        let destBehaviours = isPresenting ? behavioursFromController(toController) : behavioursFromController(fromController)
        let allBehaviours = sourceBehaviours + destBehaviours
        
        sourceBehaviours.forEach { behaviour in
            behaviour.setup(
                presenting: self.isPresenting,
                container: container,
                destinationBehaviour: destBehaviours.filter { behaviour.behaviourIdentifier == $0.behaviourIdentifier}.first
            )
        }
        
        destBehaviours.forEach { behaviour in
            behaviour.setup(presenting: self.isPresenting, container: container, destinationBehaviour: nil)
        }
        
        if isPresenting {
            toController.view.hidden = false
        }
        
        return allBehaviours
    }
    
    func behavioursFromController(controller: UIViewController) -> [TransitionBehaviour] {
        if let transitionable = controller as? BehaviourTransitionable {
            return transitionable.transitionBehaviourCollections
                .filter { $0.transitionIdentifier == self.transitionIdentifier }
                .flatMap { $0.behaviours }
        }
        
        return []
    }
    
}
