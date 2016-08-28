//
//  TransformToPositionSourceBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Takes a snapshot of the view and transforms it to the ```CGRect``` of the corresponding 
/// ```TransformToPositionDestinationBehaviour```'s ```viewForTransition```.
///
/// Typically used to provide the Photos.app style transition when you tap on a photo in the collection view.
///
/// Note: This ```TransitionBehaviour``` needs a corresponding ```TransformToPositionDestinationBehaviour``` with the same
/// behaviourIdentifier to function correctly
class TransformToPositionSourceBehaviour: TransitionBehaviour {
    
    var sourceFrame: CGRect?
    var destinationFrame: CGRect?
    
    @IBInspectable var shouldBeOnTop: Bool = false
    
    var snapshotView: UIView!
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        guard let destinationView = destinationBehaviour?.viewForTransition else { return }
        
        sourceFrame = getContainerFrame(container, view: viewForTransition)
        destinationFrame = getContainerFrame(container, view: destinationView)
        
        snapshotView = viewForTransition.resizableSnapshotViewFromRect(viewForTransition.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
        snapshotView.frame = sourceFrame!
        if shouldBeOnTop {
            container.addSubview(snapshotView)
        } else {
            viewForTransition.addSubview(snapshotView)
        }
        
        viewForTransition.hidden = true
        
        let destTransform = destinationTransform(sourceFrame!, destinationFrame: destinationFrame!)
        snapshotView.transform = isPresenting ? CGAffineTransformIdentity : destTransform
    }
    
    override func addAnimationKeyFrames() {
        UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1) {
            self.applyAnimation()
        }
    }
    
    func applyAnimation() {
        guard let sourceFrame = sourceFrame, destinationFrame = destinationFrame else { return }
        
        let destTransform = destinationTransform(sourceFrame, destinationFrame: destinationFrame)
        snapshotView.transform = isPresenting ? destTransform : CGAffineTransformIdentity
    }
    
    override func complete() {
        snapshotView.removeFromSuperview()
        viewForTransition.hidden = false
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


/// Provides the destination position for the corresponding ```TransformToPositionSourceBehaviour```, via it's
/// ```viewForTransition```.
///
/// Note: This ```TransitionBehaviour``` isn't supposed to be used on it's own. It should be paired with a
/// ```TransformToPositionSourceBehaviour``` with the same behaviourIdentifier
class TransformToPositionDestinationBehaviour: TransitionBehaviour {
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        viewForTransition.hidden = true
    }
    
    override func complete() {
        viewForTransition.hidden = false
    }
    
}
