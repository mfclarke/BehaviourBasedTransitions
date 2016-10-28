//
//  MockTransitionableViewController.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 28/10/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit
import BehaviourBasedTransitions

class MockTransitionableViewController: UIViewController, BehaviourTransitionable {
    
    var transitions: [BehaviourBasedTransition] = []
    var transitionBehaviourCollections: [TransitionBehaviourCollection] = []

    var willAppearTransitionIdentifier: String?
    var didAppearTransitionIdentifier: String?
    var willDisappearTransitionIdentifier: String?
    var didDisappearTransitionIdentifier: String?
    
    override func viewWillAppearByTransition(withIdentifier identifier: String) {
        willAppearTransitionIdentifier = identifier
    }
    
    override func viewDidAppearByTransition(withIdentifier identifier: String) {
        didAppearTransitionIdentifier = identifier
    }
    
    override func viewWillDisappearByTransition(withIdentifier identifier: String) {
        willDisappearTransitionIdentifier = identifier
    }
    
    override func viewDidDisappearByTransition(withIdentifier identifier: String) {
        didDisappearTransitionIdentifier = identifier
    }
    
}
