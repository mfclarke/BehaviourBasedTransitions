//
//  UIView+BehaviourViewProvideable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

extension UIView: BehaviourViewProvideable {
    func viewForBehaviour() -> UIView? {
        return self
    }
}
