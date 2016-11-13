//
//  BehaviourBasedTransition.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/16.
//  Copyright (c) 2016 Max Dev Ltd. All rights reserved.
//

import UIKit

/// Animates a UIViewController transition using `TransitionBehaviour` objects, typically set up in the Storyboard.
///
/// Either or both `UIViewController`s should conform to the `BehaviourTransitionable` protocol, to provide the
/// `TransitionBehaviour`s used in the transition, via `TransitionBehaviourCollection`s.
///
/// Each `BehaviourBasedTransition` should have a unique transitionIdentifier, which is used to get the correct
/// `TransitionBehaviour` for the transition via the `UIViewController`s `TransitionBehaviourCollection`s.
public class BehaviourBasedTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    // MARK: IBInspectable vars
    
    /// Unique identifier for the transition
    @IBInspectable public var transitionIdentifier: String = ""
    
    /// Segue identifier that should use the transition
    @IBInspectable public var segueIdentifier: String = ""
    
    /// Duration of the transition
    @IBInspectable public var transitionDuration: Double = 0.5
    
    // MARK: Private
    
    public internal(set) var isPresenting = false
    public var isInteractive = false
    
    private var behaviourAnimationsCompleted = 0
    private var allBehaviours: [TransitionBehaviour] = []
    
    private weak var sourceViewControllerSuperview: UIView?

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        fromController.viewWillDisappearByTransition(withIdentifier: transitionIdentifier)
        toController.viewWillAppearByTransition(withIdentifier: transitionIdentifier)
        
        let container = transitionContext.containerView()
        
        if isPresenting {
            sourceViewControllerSuperview = fromController.view.superview
            container.addSubview(fromController.view)
            container.addSubview(toController.view)
        } else {
            container.addSubview(toController.view)
            container.addSubview(fromController.view)
        }
        
        let behaviours = setupBehaviours(fromController, toController: toController, container: container, context: transitionContext)
        
        behaviours.forEach { $0.addAnimations() }
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }
    
}

extension BehaviourBasedTransition: UIViewControllerTransitioningDelegate {
    
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
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? self : nil
    }
    
}

private extension BehaviourBasedTransition {
    
    func setupBehaviours(fromController: UIViewController, toController: UIViewController, container: UIView, context: UIViewControllerContextTransitioning) -> [TransitionBehaviour] {
        if isPresenting {
            toController.view.hidden = true
            toController.view.layoutIfNeeded()
        }
        
        let sourceBehaviours = isPresenting ? behavioursFromController(fromController) : behavioursFromController(toController)
        let destBehaviours = isPresenting ? behavioursFromController(toController) : behavioursFromController(fromController)
        allBehaviours = sourceBehaviours + destBehaviours
        
        behaviourAnimationsCompleted = 0
        
        allBehaviours.forEach { behaviour in
            behaviour.isPresenting = self.isPresenting
            behaviour.isInteractive = self.isInteractive
            behaviour.transitionDuration = self.transitionDuration
            behaviour.animationCompleted = {
                self.behaviourAnimationCompleted(context)
            }
        }
        
        sourceBehaviours.forEach { behaviour in
            behaviour.setup(
                container,
                destinationBehaviour: destBehaviours.filter { behaviour.behaviourIdentifier == $0.behaviourIdentifier}.first
            )
        }
        
        destBehaviours.forEach { behaviour in
            behaviour.setup(container, destinationBehaviour: nil)
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
    
    func behaviourAnimationCompleted(context: UIViewControllerContextTransitioning) {
        behaviourAnimationsCompleted += 1
        if behaviourAnimationsCompleted == allBehaviours.count {
            allBehavioursCompleted(context)
        }
    }

    func allBehavioursCompleted(context: UIViewControllerContextTransitioning) {
        guard 
            let toController = context.viewControllerForKey(UITransitionContextToViewControllerKey),
            let fromController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)
            else { return }
        
        allBehaviours.forEach { $0.transitionCompleted(context.transitionWasCancelled()) }
        
        if context.transitionWasCancelled() {
            if isPresenting {
                toController.dismissViewControllerAnimated(false, completion: nil)
                sourceViewControllerSuperview?.addSubview(fromController.view)
            }
            context.completeTransition(false)
            
            toController.viewDidDisappearByTransition(withIdentifier: transitionIdentifier)
            fromController.viewDidAppearByTransition(withIdentifier: transitionIdentifier)
        } else {
            if !isPresenting {
                sourceViewControllerSuperview?.addSubview(toController.view)
            }
            context.completeTransition(true)
            
            fromController.viewDidDisappearByTransition(withIdentifier: transitionIdentifier)
            toController.viewDidAppearByTransition(withIdentifier: transitionIdentifier)
        }
    }
    
}
