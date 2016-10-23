//
//  PanGestureInteractionHandler.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

public class PanGestureInteractionHandler: NSObject {
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var sourceViewController: UIViewController?
    @IBOutlet var transition: BehaviourBasedTransition?
    
    @IBOutlet var destinationViewController: UIViewController?
    
    @IBInspectable var rollback: CGFloat = 0.3333
    
    private var maxDistance: CGFloat = 500
    
    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIPanGestureRecognizer?) {
        guard gestureRecognizer == panGestureRecognizer else { return }
        
        if let sourceViewController = sourceViewController, transition = transition {
            updateTransition(transition, presenting: true)
            
            if panGestureRecognizer.state == .Began {
                sourceViewController.performSegueWithIdentifier(transition.segueIdentifier, sender: self)
            }
        }
        else if let destinationViewController = destinationViewController,
            let transition = destinationViewController.transitioningDelegate as? BehaviourBasedTransition
        {
            updateTransition(transition, presenting: false)
            
            if panGestureRecognizer.state == .Began {
                destinationViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func updateTransition(transition: BehaviourBasedTransition, presenting: Bool) {
        let translation = panGestureRecognizer.translationInView(panGestureRecognizer.view)
        let percent = max((presenting ? -1 : 1) * translation.y / maxDistance, 0.0)
        let location = panGestureRecognizer.locationInView(panGestureRecognizer.view)
        
        switch panGestureRecognizer.state {
        case .Began:
            transition.isInteractive = true
            let viewHeight = panGestureRecognizer.view?.frame.height ?? 0
            maxDistance = presenting ? location.y : viewHeight - location.y
            break
            
        case .Changed:
            transition.updateInteractiveTransition(percent)
            
        default:
            transition.isInteractive = false
            if percent > rollback {
                transition.finishInteractiveTransition()
            } else {
                transition.cancelInteractiveTransition()
            }
        }
    }
    
}

extension PanGestureInteractionHandler: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isForPresentationTransition {
            return panGestureRecognizer.velocityInView(panGestureRecognizer.view).y < 0
        } else {
            return panGestureRecognizer.velocityInView(panGestureRecognizer.view).y > 0
        }
    }
    
    private var isForPresentationTransition: Bool {
        return sourceViewController != nil
    }
    
}
