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
    func containerView() -> UIView? { return container }
    
    var animated = true
    func isAnimated() -> Bool { return animated }
    
    var interactive = false
    func isInteractive() -> Bool { return interactive }
    
    var cancelled = false
    func transitionWasCancelled() -> Bool { return cancelled }
    
    var fromViewController: UIViewController?
    var toViewController: UIViewController?
    func viewControllerForKey(key: String) -> UIViewController? {
        switch key {
        case UITransitionContextFromViewControllerKey:
            return fromViewController
        case UITransitionContextToViewControllerKey:
            return toViewController
        default:
            return nil
        }
    }
    
    func viewForKey(key: String) -> UIView? {
        return nil
    }
    
    
    // Stubbing out the rest of the protocol
    
    func presentationStyle() -> UIModalPresentationStyle { return .Custom }
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    func completeTransition(didComplete: Bool) {}
    func targetTransform() -> CGAffineTransform { return CGAffineTransformIdentity }
    func initialFrameForViewController(vc: UIViewController) -> CGRect { return CGRect.zero }
    func finalFrameForViewController(vc: UIViewController) -> CGRect { return CGRect.zero }
    
}
