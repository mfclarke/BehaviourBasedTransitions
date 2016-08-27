//
//  TransitionBehaviourCollection.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class TransitionBehaviourCollection: NSObject {
    @IBInspectable var transitionIdentifier: String = ""
    @IBOutlet var behaviours: [TransitionBehaviour] = []
}
