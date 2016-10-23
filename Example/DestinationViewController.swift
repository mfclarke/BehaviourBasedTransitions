//
//  DestinationViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class DestinationViewController: UIViewController, BehaviourTransitionable {
    
    @IBOutlet var transitions: [BehaviourBasedTransition] = []
    @IBOutlet var transitionBehaviourCollections: [TransitionBehaviourCollection] = []
    
}


// MARK: Interactivity

extension DestinationViewController: UIGestureRecognizerDelegate, PanGestureInteractable {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        // Allow interaction to start only when user pans downwards
        return panGestureRecognizer.velocityInView(panGestureRecognizer.view).y > 0
    }
    
    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIPanGestureRecognizer?) {
        guard let gestureRecognizer = gestureRecognizer else { return }
        updateTransitionForPanGestureChange(gestureRecognizer)
    }
    
}
