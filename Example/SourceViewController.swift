//
//  SourceViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class SourceViewController: UIViewController, BehaviourTransitionable {
    
    @IBOutlet var transitions: [BehaviourBasedTransition] = []
    @IBOutlet var transitionBehaviourCollections: [TransitionBehaviourCollection] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        prepareSegueForTransition(segue)
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {}
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}


// MARK: Interactivity

extension SourceViewController: UIGestureRecognizerDelegate, PanGestureInteractable {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        // Allow interaction to start only when user pans upwards
        return panGestureRecognizer.velocityInView(panGestureRecognizer.view).y < 0
    }

    @IBAction func panGestureChanged(withGestureRecognizer gestureRecognizer: UIPanGestureRecognizer?) {
        guard let gestureRecognizer = gestureRecognizer else { return }
        updateTransitionForPanGestureChange(gestureRecognizer)
    }

}
