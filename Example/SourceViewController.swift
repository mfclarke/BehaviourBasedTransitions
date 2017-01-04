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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        prepareSegueForTransition(segue)
    }
    
    @IBAction func unwindToViewController(withSender sender: UIStoryboardSegue) {}
    
    @IBAction func dismiss(withSender sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
