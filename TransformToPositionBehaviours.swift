//
//  TransformToPositionSourceBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class TransformToPositionSourceBehaviour: TransitionBehaviour {
    
    var sourceFrame: CGRect!
    var destinationFrame: CGRect!
    
    @IBInspectable var shouldBeOnTop: Bool = false
    
    var snapshotView: UIView!
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        guard let sourceView = viewForTransition, destinationView = destinationBehaviour?.viewForTransition else { return }
        
        // Why do we need to do this?
        destinationView.superview?.layoutSubviews()
        
        sourceFrame = getContainerFrame(container, view: sourceView)
        destinationFrame = getContainerFrame(container, view: destinationView)
        
        snapshotView = sourceView.snapshotViewAfterScreenUpdates(true)
        snapshotView.frame = sourceFrame
        if shouldBeOnTop {
            container.addSubview(snapshotView)
        } else {
            viewForTransition!.addSubview(snapshotView)
        }
        
        sourceView.hidden = true
        
        let destTransform = destinationTransform(sourceFrame, destinationFrame: destinationFrame)
        snapshotView.transform = isPresenting ? CGAffineTransformIdentity : destTransform
    }
    
    override func animate() {
        let destTransform = destinationTransform(sourceFrame, destinationFrame: destinationFrame)
        snapshotView.transform = isPresenting ? destTransform : CGAffineTransformIdentity
    }
    
    override func complete() {
        snapshotView.removeFromSuperview()
        viewForTransition?.hidden = false
    }
    
    func destinationTransform(sourceFrame: CGRect, destinationFrame: CGRect) -> CGAffineTransform {
        let offset = CGPoint(
            x: destinationFrame.midX - sourceFrame.midX,
            y: destinationFrame.midY - sourceFrame.midY)
        
        let scale = CGPoint(
            x: destinationFrame.size.width / sourceFrame.size.width,
            y: destinationFrame.size.height / sourceFrame.size.height)
        
        return CGAffineTransformMake(scale.x, 0, 0, scale.y, offset.x, offset.y)
    }
    
    func getContainerFrame(container: UIView, view: UIView) -> CGRect {
        if let frameInContainer = view.superview?.convertRect(view.frame, toView: container) {
            return frameInContainer
        }
        
        assertionFailure("Expected view to have a superview to calculate it's coordinates with respect to the container")
        return CGRect.zero
    }
    
}

class TransformToPositionDestinationBehaviour: TransitionBehaviour {
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        viewForTransition?.hidden = true
    }
    
    override func complete() {
        viewForTransition?.hidden = false
    }
    
}
