//
//  BehaviourViewProvideable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Use this protocol to provide a specific subview to a TransitionBehaviour. You can use this for example to provide
/// a view inside a UICollectionViewCell
protocol BehaviourViewProvideable {
    
    /// Returns the view to be used by the attached TransitionBehaviour
    func viewForBehaviour() -> UIView?
    
}

/// Default implementation to simply return the same view
extension UIView: BehaviourViewProvideable {
    func viewForBehaviour() -> UIView? {
        return self
    }
}
