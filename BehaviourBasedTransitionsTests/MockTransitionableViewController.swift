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
    override func viewWillAppearByTransition(withIdentifier identifier: String) {
        willAppearTransitionIdentifier = identifier
    }
    
    var didAppearTransitionIdentifier: String?
    override func viewDidAppearByTransition(withIdentifier identifier: String) {
        didAppearTransitionIdentifier = identifier
    }
    
    var willDisappearTransitionIdentifier: String?
    override func viewWillDisappearByTransition(withIdentifier identifier: String) {
        willDisappearTransitionIdentifier = identifier
    }
    
    var didDisappearTransitionIdentifier: String?
    override func viewDidDisappearByTransition(withIdentifier identifier: String) {
        didDisappearTransitionIdentifier = identifier
    }
    
    var dismissCalled = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: flag, completion: completion)
        dismissCalled = true
    }
    
}
