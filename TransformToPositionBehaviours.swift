//
//  TransformToPositionSourceBehaviour.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

class TransformToPositionSourceBehaviour: TransitionBehaviour {
    
    var destinationFrame: CGRect?
    @IBInspectable var shouldBeOnTop: Bool = false
    
    var snapshotView: UIView!
    
    override func setup(presenting presenting: Bool, container: UIView, destinationBehaviour: TransitionBehaviour? = nil) {
        super.setup(presenting: presenting, container: container, destinationBehaviour: destinationBehaviour)
        destinationFrame = destinationBehaviour?.viewForTransition?.frame
        
        guard let viewForTransition = viewForTransition, destinationFrame = destinationFrame else { return }
        
        snapshotView = viewForTransition.snapshotViewAfterScreenUpdates(true)
        snapshotView.frame = viewForTransition.frame
        if shouldBeOnTop {
            container.addSubview(snapshotView)
        } else {
            viewForTransition.addSubview(snapshotView)
        }
        
        viewForTransition.hidden = true
        
        let destTransform = destinationTransform(viewForTransition.frame, destinationFrame: destinationFrame)
        snapshotView.transform = isPresenting ? CGAffineTransformIdentity : destTransform
    }
    
    override func animate() {
        guard let destinationFrame = destinationFrame else { return }
        
        let destTransform = destinationTransform(snapshotView.frame, destinationFrame: destinationFrame)
        snapshotView.transform = isPresenting ? destTransform : CGAffineTransformIdentity
    }
    
    override func complete() {
        snapshotView.removeFromSuperview()
        viewForTransition?.hidden = false
    }
    
    func destinationTransform(sourceFrame: CGRect, destinationFrame: CGRect) -> CGAffineTransform {
        let posDelta = CGPoint(
            x: sourceFrame.origin.x - destinationFrame.origin.x,
            y: sourceFrame.origin.y - destinationFrame.origin.y)
        
        let scale = CGPoint(
            x: destinationFrame.size.width / sourceFrame.size.width,
            y: destinationFrame.size.height / sourceFrame.size.height)
        
        let translateTransform = CGAffineTransformMakeTranslation(posDelta.x, posDelta.y)
        let sizeTransform = CGAffineTransformMakeScale(scale.x, scale.y)
        
        return CGAffineTransformConcat(translateTransform, sizeTransform)
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
