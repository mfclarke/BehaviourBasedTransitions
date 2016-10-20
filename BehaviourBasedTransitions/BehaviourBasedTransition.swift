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
public class BehaviourBasedTransition: NSObject {
    
    
    // MARK: IBInspectable vars
    
    /// Unique identifier for the transition
    @IBInspectable public var transitionIdentifier: String = ""
    
    /// Segue identifier that should use the transition
    @IBInspectable public var segueIdentifier: String = ""
    
    /// Duration of the transition
    @IBInspectable public var duration: Double = 0.5
    
    
    // MARK: Private
    
    private var isPresenting = false
    
    private var behaviourAnimationsCompleted = 0
    private var allBehaviours: [TransitionBehaviour] = []
    
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
        }
        
        let behaviours = setupBehaviours(fromController, toController: toController, container: container, context: transitionContext)
        
        behaviours.forEach { $0.addAnimations() }
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
            behaviour.transitionDuration = self.duration
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
            allBehaviours.forEach { $0.complete() }
            
            context.completeTransition(true)
        }
    }
    
}
