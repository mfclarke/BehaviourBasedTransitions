//
//  BehaviourBasedTransition.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/16.
//  Copyright (c) 2016 Max Dev Ltd. All rights reserved.
//

import UIKit

class BehaviourBasedTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    @IBInspectable var transitionIdentifier: String = ""
    @IBInspectable var segueIdentifier: String = ""
    @IBInspectable var duration: Double = 0.5
    
    private var isPresenting = false
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let
            container = transitionContext.containerView(),
            fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            transitionSource = (self.isPresenting ? fromController : toController)  as? BehaviourTransitionable,
            transitionDestination = (self.isPresenting ? toController : fromController) as? BehaviourTransitionable
            else { return }
        
        if isPresenting {
            container.addSubview(toController.view)
        } else {
            container.insertSubview(toController.view, belowSubview: fromController.view)
        }
        
        let sourceBehaviourCollection = transitionSource.transitionBehaviourCollections.filter { $0.transitionIdentifier == self.transitionIdentifier }.first
        let destBehaviourCollection = transitionDestination.transitionBehaviourCollections.filter { $0.transitionIdentifier == self.transitionIdentifier }.first
        
        let behaviours = (sourceBehaviourCollection?.behaviours ?? []) + (destBehaviourCollection?.behaviours ?? [])
        
        sourceBehaviourCollection?.behaviours.forEach { behaviour in
            behaviour.setup(presenting: self.isPresenting,
                container: container,
                destinationBehaviour: destBehaviourCollection?.behaviours.filter { destBehaviour in
                    behaviour.behaviourIdentifier == destBehaviour.behaviourIdentifier
                }.first)
        }
        
        destBehaviourCollection?.behaviours.forEach { behaviour in
            behaviour.setup(presenting: self.isPresenting, container: container)
        }
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            animations: {
                behaviours.forEach { $0.animate() }
            },
            completion: { finished in
                behaviours.forEach { $0.complete() }
                
                transitionContext.completeTransition(true)
            }
        )
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}
