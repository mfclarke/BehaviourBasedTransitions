//
//  BehaviourTransitionable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

protocol BehaviourTransitionable {
    var transitionBehaviours: [TransitionBehaviour] { get set }
}
