//
//  TransitionBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class TransitionBehaviour: NSObject {
    
    @IBOutlet var view: UIView!
    @IBInspectable var behaviourIdentifier: String = ""
    
    var viewForTransition: UIView? {
        return view.viewForBehaviour()
    }
    
    var isPresenting = false
    
    func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        isPresenting = presenting
    }
    
    func animate() {}
    func complete() {}
    
}
