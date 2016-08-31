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
