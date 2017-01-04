//
//  VerticalPanInteractionHandler.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 23/10/16.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

open class VerticalPanInteractionHandler: InteractionHandler {
    
    @IBInspectable var shouldUpSwipePresent: Bool = true
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    
    var panGestureRecognizer: UIPanGestureRecognizer! {
        return gestureRecognizer as? UIPanGestureRecognizer
    }
    
    fileprivate var maxDistance: CGFloat = 500
    
    override open func setupForGestureBegin() {
        let location = panGestureRecognizer.location(in: panGestureRecognizer.view)
        let viewHeight = panGestureRecognizer.view?.frame.height ?? 0
        
        if isHandlerForPresentationTransition {
            maxDistance = shouldUpSwipePresent ? location.y : viewHeight - location.y
        } else {
            maxDistance = shouldUpSwipePresent ? viewHeight - location.y : location.y
        }
    }
    
    override open func calculatePercent() -> CGFloat {
        let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        let percent = shouldUpSwipePresent ?
            (isHandlerForPresentationTransition ? -1 : 1) * translation.y / maxDistance :
            (isHandlerForPresentationTransition ? 1 : -1) * translation.y / maxDistance

        return min(1, max(percent, 0))
    }
    
    override open func shouldBeginPresentationTransition() -> Bool {
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        return (shouldUpSwipePresent ? velocity.y < 0 : velocity.y > 0) && withinInsets()
    }
    
    override open func shouldBeginDismissalTransition() -> Bool {
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        return (shouldUpSwipePresent ? velocity.y > 0 : velocity.y < 0) && withinInsets()
    }
    
    fileprivate func withinInsets() -> Bool {
        let location = panGestureRecognizer.location(in: panGestureRecognizer.view)
        let viewSize = panGestureRecognizer.view?.bounds.size ?? CGSize.zero
        return (location.y > topInset && location.y < viewSize.height - bottomInset)
    }
}
