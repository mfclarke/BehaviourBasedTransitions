//
//  PanGestureInteractionHandler.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

public class PanGestureInteractionHandler: InteractionHandler {
    
    var panGestureRecognizer: UIPanGestureRecognizer! {
        return gestureRecognizer as? UIPanGestureRecognizer
    }
    
    private var maxDistance: CGFloat = 500
    
    override func setupForGestureBegin() {
        let location = panGestureRecognizer.locationInView(panGestureRecognizer.view)
        if isHandlerForPresentationTransition {
            maxDistance = location.y
        } else {
            let viewHeight = panGestureRecognizer.view?.frame.height ?? 0
            maxDistance = viewHeight - location.y
        }
    }
    
    override func calculatePercent() -> CGFloat {
        let translation = panGestureRecognizer.translationInView(panGestureRecognizer.view)
        return max((isHandlerForPresentationTransition ? -1 : 1) * translation.y / maxDistance, 0.0)
    }
    
    override func shouldBeginPresentationTransition() -> Bool {
        return panGestureRecognizer.velocityInView(panGestureRecognizer.view).y < 0
    }
    
    override func shouldBeginDismissalTransition() -> Bool {
        return panGestureRecognizer.velocityInView(panGestureRecognizer.view).y > 0
    }
}
