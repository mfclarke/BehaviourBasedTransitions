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
            toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            else { return }
        
        layoutDestinationViewControllerWithoutFlicker(toController)
        
        if isPresenting {
            container.addSubview(toController.view)
        } else {
            container.insertSubview(toController.view, belowSubview: fromController.view)
        }
        
        let sourceBehaviours = isPresenting ? behavioursFromController(fromController) : behavioursFromController(toController)
        let destBehaviours = isPresenting ? behavioursFromController(toController) : behavioursFromController(fromController)
        let behaviours = sourceBehaviours + destBehaviours
        
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
        
        unhideDestinationViewControllerAfterBehaviourSetup(toController)
        
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
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}

extension BehaviourBasedTransition {
    
    // The toController's subviews are laid out incorrectly when presenting until we call layoutIfNeeded(). But,
    // this can cause a flicker, when UIKit lays out the view before a sourceBehaviour has a chance to hide it. So,
    // until I find a better solution, we hide it before laying out, then show it after the behaviours are set up
    func layoutDestinationViewControllerWithoutFlicker(toController: UIViewController) {
        if isPresenting {
            toController.view.hidden = true
            toController.view.layoutIfNeeded()
        }
    }
    
    func unhideDestinationViewControllerAfterBehaviourSetup(toController: UIViewController) {
        if isPresenting {
            toController.view.hidden = false
        }
    }
    
    func behavioursFromController(controller: UIViewController) -> [TransitionBehaviour] {
        if let transitionable = controller as? BehaviourTransitionable {
            return transitionable.transitionBehaviours
        }
        
        if let multiTransitionable = controller as? BehaviourMultiTransitionable {
            return multiTransitionable.transitionBehaviourCollections
                .filter { $0.transitionIdentifier == self.transitionIdentifier }
                .flatMap { $0.behaviours }
        }
        
        return []
    }
    
}
