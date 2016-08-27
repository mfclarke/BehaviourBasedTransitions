//
//  ViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 26/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, BehaviourTransitionable {
    
    @IBOutlet var transition: BehaviourBasedTransition?
    
    @IBOutlet var transitionBehaviours: [TransitionBehaviour] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        segue.destinationViewController.transitioningDelegate = transition
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue) {}

}
