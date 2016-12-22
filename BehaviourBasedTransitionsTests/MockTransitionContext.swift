//
//  MockTransitionContext.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 28/10/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class MockTransitionContext: NSObject, UIViewControllerContextTransitioning {
    
    var container: UIView?
    var containerView : UIView { return container ?? UIView() }
    
    var _isAnimated = true
    var isAnimated : Bool { return _isAnimated }
    
    var _isInteractive = false
    var isInteractive : Bool { return _isInteractive }
    
    var cancelled = false
    var transitionWasCancelled : Bool { return cancelled }
    
    var fromViewController: UIViewController?
    var toViewController: UIViewController?
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        switch key {
        case UITransitionContextViewControllerKey.from:
            return fromViewController
        case UITransitionContextViewControllerKey.to:
            return toViewController
        default:
            return nil
        }
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }
    
    var transitionFinished = false
    func finishInteractiveTransition() {
        transitionFinished = true
    }
    
    var transitionCancelled = false
    func cancelInteractiveTransition() {
        transitionCancelled = true
    }
    
    var transitionCompleted: Bool?
    func completeTransition(_ didComplete: Bool) {
        transitionCompleted = didComplete
    }
    
    
    // Stubbing out the rest of the protocol
    
    var presentationStyle : UIModalPresentationStyle { return .custom }
    func updateInteractiveTransition(_ percentComplete: CGFloat) {}
    func pauseInteractiveTransition() {}
    var targetTransform : CGAffineTransform { return CGAffineTransform.identity }
    func initialFrame(for vc: UIViewController) -> CGRect { return CGRect.zero }
    func finalFrame(for vc: UIViewController) -> CGRect { return CGRect.zero }
    
}
