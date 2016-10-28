//
//  MockTransitionContext.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 28/10/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class MockTransitionContext: NSObject, UIViewControllerContextTransitioning {
    
    var fromViewController: UIViewController?
    var toViewController: UIViewController?
    var container: UIView?
    var interactive = false
    var wasCancelled = false
    
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
    
    func containerView() -> UIView? { return container }
    func isAnimated() -> Bool { return true }
    func isInteractive() -> Bool { return interactive }
    func transitionWasCancelled() -> Bool { return wasCancelled }
    func presentationStyle() -> UIModalPresentationStyle { return .Custom }
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    func completeTransition(didComplete: Bool) {}
    
    func viewForKey(key: String) -> UIView? { return nil }
    
    func targetTransform() -> CGAffineTransform { return CGAffineTransformIdentity }
    
    func initialFrameForViewController(vc: UIViewController) -> CGRect { return CGRect.zero }
    func finalFrameForViewController(vc: UIViewController) -> CGRect { return CGRect.zero }
    
}
