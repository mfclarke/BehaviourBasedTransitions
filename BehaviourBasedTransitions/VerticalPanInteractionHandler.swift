//
//  VerticalPanInteractionHandler.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

public class VerticalPanInteractionHandler: InteractionHandler {
    
    @IBInspectable var shouldUpSwipePresent: Bool = true
    
    var panGestureRecognizer: UIPanGestureRecognizer! {
        return gestureRecognizer as? UIPanGestureRecognizer
    }
    
    private var maxDistance: CGFloat = 500
    
    override func setupForGestureBegin() {
        let location = panGestureRecognizer.locationInView(panGestureRecognizer.view)
        let viewHeight = panGestureRecognizer.view?.frame.height ?? 0
        
        if isHandlerForPresentationTransition {
            maxDistance = shouldUpSwipePresent ? location.y : viewHeight - location.y
        } else {
            maxDistance = shouldUpSwipePresent ? viewHeight - location.y : location.y
        }
    }
    
    override func calculatePercent() -> CGFloat {
        let translation = panGestureRecognizer.translationInView(panGestureRecognizer.view)
        return shouldUpSwipePresent ?
            max((isHandlerForPresentationTransition ? -1 : 1) * translation.y / maxDistance, 0.0) :
            max((isHandlerForPresentationTransition ? 1 : -1) * translation.y / maxDistance, 0.0)
    }
    
    override func shouldBeginPresentationTransition() -> Bool {
        return shouldUpSwipePresent ?
            panGestureRecognizer.velocityInView(panGestureRecognizer.view).y < 0 :
            panGestureRecognizer.velocityInView(panGestureRecognizer.view).y > 0
    }
    
    override func shouldBeginDismissalTransition() -> Bool {
        return shouldUpSwipePresent ?
            panGestureRecognizer.velocityInView(panGestureRecognizer.view).y > 0 :
            panGestureRecognizer.velocityInView(panGestureRecognizer.view).y < 0
    }
}
