//
//  BehaviourTransitionable.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 27/08/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import UIKit

/// Used by `BehaviourBasedTransition`s to get access to the correct `TransitionBehaviour`s for animation
public protocol BehaviourTransitionable {
    
    /// Array of transitions that this view controller is the source for
    var transitions: [BehaviourBasedTransition] { get set }
    
    /// Array of collections, which should each be assigned a unique `transitionIdentifier` that matches the
    /// `BehaviourBasedTransition` they should be used in
    var transitionBehaviourCollections: [TransitionBehaviourCollection] { get set }
}

public extension BehaviourTransitionable {
    
    /// Helper method to handle logic for assigning the correct transition for the segue
    public func prepareSegueForTransition(_ segue: UIStoryboardSegue) {
        if let transition = transitions.filter({ $0.segueIdentifier == segue.identifier }).first {
            segue.destination.modalPresentationStyle = .fullScreen
            segue.destination.transitioningDelegate = transition
            segue.destination.prepareForTransition(withIdentifier: transition.transitionIdentifier)
        }
    }
    
}

/// `BehaviourBasedTransition` calls these at the appropriate times when transitioning.
/// Default implementations are provided to propogate to child view controllers, including children of
/// `UITabBarController` and `UIPageViewController`
public protocol BehaviourAppearable {
    func prepareForTransition(withIdentifier identifier: String)
    
    func viewWillAppearByTransition(withIdentifier identifier: String)
    func viewWillDisappearByTransition(withIdentifier identifier: String)
    
    func viewDidAppearByTransition(withIdentifier identifier: String)
    func viewDidDisappearByTransition(withIdentifier identifier: String)
}

extension UIViewController: BehaviourAppearable {
    
    open func prepareForTransition(withIdentifier identifier: String) {
        childViewControllers.forEach { $0.prepareForTransition(withIdentifier: identifier) }
    }
    
    open func viewWillAppearByTransition(withIdentifier identifier: String) {
        childViewControllers.forEach { $0.viewWillAppearByTransition(withIdentifier: identifier) }
    }
    
    open func viewWillDisappearByTransition(withIdentifier identifier: String) {
        childViewControllers.forEach { $0.viewWillDisappearByTransition(withIdentifier: identifier) }
    }
    
    open func viewDidAppearByTransition(withIdentifier identifier: String) {
        childViewControllers.forEach { $0.viewDidAppearByTransition(withIdentifier: identifier) }
    }
    
    open func viewDidDisappearByTransition(withIdentifier identifier: String) {
        childViewControllers.forEach { $0.viewDidDisappearByTransition(withIdentifier: identifier) }
    }
    
}

extension UIPageViewController {
    
    override open func prepareForTransition(withIdentifier identifier: String) {
        super.prepareForTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.prepareForTransition(withIdentifier: identifier) }
    }
    
    override open func viewWillAppearByTransition(withIdentifier identifier: String) {
        super.viewWillAppearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewWillAppearByTransition(withIdentifier: identifier) }
    }
    
    override open func viewWillDisappearByTransition(withIdentifier identifier: String) {
        super.viewWillDisappearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewWillDisappearByTransition(withIdentifier: identifier) }
    }
    
    override open func viewDidAppearByTransition(withIdentifier identifier: String) {
        super.viewDidAppearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewDidAppearByTransition(withIdentifier: identifier) }
    }
    
    override open func viewDidDisappearByTransition(withIdentifier identifier: String) {
        super.viewDidDisappearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewDidDisappearByTransition(withIdentifier: identifier) }
    }
    
}

extension UITabBarController {
    
    override open func prepareForTransition(withIdentifier identifier: String) {
        super.prepareForTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.prepareForTransition(withIdentifier: identifier) }
    }
    
    override open func viewWillAppearByTransition(withIdentifier identifier: String) {
        super.viewWillAppearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewWillAppearByTransition(withIdentifier: identifier) }
    }
    
    override open func viewWillDisappearByTransition(withIdentifier identifier: String) {
        super.viewWillDisappearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewWillDisappearByTransition(withIdentifier: identifier) }
    }
    
    override open func viewDidAppearByTransition(withIdentifier identifier: String) {
        super.viewDidAppearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewDidAppearByTransition(withIdentifier: identifier) }
    }
    
    override open func viewDidDisappearByTransition(withIdentifier identifier: String) {
        super.viewDidDisappearByTransition(withIdentifier: identifier)
        viewControllers?.forEach { $0.viewDidDisappearByTransition(withIdentifier: identifier) }
    }
    
}
