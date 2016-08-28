//
//  ViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class HomeViewController: UIViewController, BehaviourTransitionable {
    
    @IBOutlet var transitions: [BehaviourBasedTransition] = []
    
    @IBOutlet var transitionBehaviourCollections: [TransitionBehaviourCollection] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        segue.destinationViewController.transitioningDelegate = transitions.filter { $0.segueIdentifier == segue.identifier }.first
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {}

}
