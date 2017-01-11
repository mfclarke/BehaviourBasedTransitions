//
//  TransformToPositionSourceBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Takes a snapshot of the view and transforms it to the `CGRect` of the corresponding 
/// `TransformToPositionDestinationBehaviour`'s `viewForTransition`.
///
/// Typically used to provide the Photos.app style transition when you tap on a photo in the collection view.
///
/// Will only use the first view in the `views` `IBOutlet`
///
/// Note: This `TransitionBehaviour` needs a corresponding `TransformToPositionDestinationBehaviour` with the same
/// behaviourIdentifier to function correctly
open class TransformToPositionSourceBehaviour: TransitionBehaviour {
    
    @IBInspectable open var shouldBeOnTop: Bool = false
    
    var sourceFrame: CGRect?
    var destinationFrame: CGRect?
    
    var snapshotView: UIView!
    
    override open func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        guard let sourceView = viewsForTransition.first, let destinationView = destinationBehaviour?.viewsForTransition.first else { return }
        
        sourceFrame = getContainerFrame(container, view: sourceView)
        destinationFrame = getContainerFrame(container, view: destinationView)
        
        snapshotView = sourceView.resizableSnapshotView(from: sourceView.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        snapshotView.frame = sourceFrame!
        if shouldBeOnTop {
            container.addSubview(snapshotView)
        } else {
            sourceView.addSubview(snapshotView)
        }
        
        sourceView.isHidden = true
        
        let destTransform = destinationTransform(sourceFrame!, destinationFrame: destinationFrame!)
        snapshotView.transform = isPresenting ? CGAffineTransform.identity : destTransform
    }
    
    override open func addAnimations() {
        addAnimation {
            self.applyAnimation()
        }
    }
    
    func applyAnimation() {
        guard let sourceFrame = sourceFrame, let destinationFrame = destinationFrame else { return }
        
        let destTransform = destinationTransform(sourceFrame, destinationFrame: destinationFrame)
        snapshotView.transform = isPresenting ? destTransform : CGAffineTransform.identity
    }
    
    override open func complete(_ presented: Bool) {
        snapshotView.removeFromSuperview()
        viewsForTransition.first?.isHidden = false
    }
    
    func destinationTransform(_ sourceFrame: CGRect, destinationFrame: CGRect) -> CGAffineTransform {
        let offset = CGPoint(
            x: destinationFrame.midX - sourceFrame.midX,
            y: destinationFrame.midY - sourceFrame.midY)
        
        let scale = CGPoint(
            x: destinationFrame.size.width / sourceFrame.size.width,
            y: destinationFrame.size.height / sourceFrame.size.height)
        
        return CGAffineTransform(a: scale.x, b: 0, c: 0, d: scale.y, tx: offset.x, ty: offset.y)
    }
    
    func getContainerFrame(_ container: UIView, view: UIView) -> CGRect {
        if let frameInContainer = view.superview?.convert(view.frame, to: container) {
            return frameInContainer
        }
        
        assertionFailure("Expected view to have a superview to calculate it's coordinates with respect to the container")
        return CGRect.zero
    }
    
}


/// Provides the destination position for the corresponding `TransformToPositionSourceBehaviour`, via it's
/// `viewForTransition`.
///
/// Will only use the first view in the `views` `IBOutlet`
///
/// Note: This `TransitionBehaviour` isn't supposed to be used on it's own. It should be paired with a
/// `TransformToPositionSourceBehaviour` with the same behaviourIdentifier
open class TransformToPositionDestinationBehaviour: TransitionBehaviour {
    
    override open func setup(_ container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(container, destinationBehaviour: destinationBehaviour)
        viewsForTransition.first?.isHidden = true
        animationCompleted?()
    }
    
    override open func complete(_ presented: Bool) {
        viewsForTransition.first?.isHidden = false
    }
    
}
