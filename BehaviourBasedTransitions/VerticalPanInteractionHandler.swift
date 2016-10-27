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
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    
    var panGestureRecognizer: UIPanGestureRecognizer! {
        return gestureRecognizer as? UIPanGestureRecognizer
    }
    
    private var maxDistance: CGFloat = 500
    
    override public func setupForGestureBegin() {
        let location = panGestureRecognizer.locationInView(panGestureRecognizer.view)
        let viewHeight = panGestureRecognizer.view?.frame.height ?? 0
        
        if isHandlerForPresentationTransition {
            maxDistance = shouldUpSwipePresent ? location.y : viewHeight - location.y
        } else {
            maxDistance = shouldUpSwipePresent ? viewHeight - location.y : location.y
        }
    }
    
    override public func calculatePercent() -> CGFloat {
        let translation = panGestureRecognizer.translationInView(panGestureRecognizer.view)
        let percent = shouldUpSwipePresent ?
            (isHandlerForPresentationTransition ? -1 : 1) * translation.y / maxDistance :
            (isHandlerForPresentationTransition ? 1 : -1) * translation.y / maxDistance

        return min(1, max(percent, 0))
    }
    
    override public func shouldBeginPresentationTransition() -> Bool {
        let velocity = panGestureRecognizer.velocityInView(panGestureRecognizer.view)
        return (shouldUpSwipePresent ? velocity.y < 0 : velocity.y > 0) && withinInsets()
    }
    
    override public func shouldBeginDismissalTransition() -> Bool {
        let velocity = panGestureRecognizer.velocityInView(panGestureRecognizer.view)
        return (shouldUpSwipePresent ? velocity.y > 0 : velocity.y < 0) && withinInsets()
    }
    
    private func withinInsets() -> Bool {
        let location = panGestureRecognizer.locationInView(panGestureRecognizer.view)
        let viewSize = panGestureRecognizer.view?.bounds.size ?? CGSize.zero
        return (location.y > topInset && location.y < viewSize.height - bottomInset)
    }
}
