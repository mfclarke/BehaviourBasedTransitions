//
//  BehaviourBasedTransitionSpec.swift
//  BehaviourBasedTransitions
//
//  Created by Maximilian Clarke on 28/10/2016.
//  Copyright © 2016 Maximilian Clarke. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import BehaviourBasedTransitions

class BehaviourBasedTransitionSpec: QuickSpec {
    
    override func spec() {
        var transition: BehaviourBasedTransition!
        
        beforeEach {
            transition = BehaviourBasedTransition()
            transition.transitionIdentifier = "Test"
        }

        describe("animateTransition") {
            var transitionContext: MockTransitionContext!
            var fromController: MockTransitionableViewController!
            var toController: MockTransitionableViewController!
            var container: UIView!
            
            beforeEach {
                transitionContext = MockTransitionContext()
                fromController = MockTransitionableViewController()
                toController = MockTransitionableViewController()
                container = UIView()
                
                transitionContext.container = container
                transitionContext.fromViewController = fromController
                transitionContext.toViewController = toController
            }
            
            it("should tell the from controller it will disappear") {
                transition.animateTransition(transitionContext)
                
                expect(fromController.willDisappearTransitionIdentifier) == "Test"
            }
            
            it("should tell the to controller it will appear") {
                transition.animateTransition(transitionContext)
                
                expect(toController.willAppearTransitionIdentifier) == "Test"
            }
            
            context("when presenting") {
                beforeEach {
                    transition.isPresenting = true
                }
                
                it("places the from controller in the container at the bottom") {
                    transition.animateTransition(transitionContext)
                    
                    expect(container.subviews.indexOf(fromController.view)) == 0
                }
                
                it("places the to controller in the container on the top") {
                    transition.animateTransition(transitionContext)
                    
                    expect(container.subviews.indexOf(toController.view)) == 1
                }
            }
            
            context("when dismissing") {
                beforeEach {
                    transition.isPresenting = false
                }
                
                it("places the from controller in the container at the top") {
                    transition.animateTransition(transitionContext)
                    
                    expect(container.subviews.indexOf(fromController.view)) == 1
                }
                
                it("places the to controller in the container on the bottom") {
                    transition.animateTransition(transitionContext)
                    
                    expect(container.subviews.indexOf(toController.view)) == 0
                }
            }
            
            context("when a behaviour is present in a view controller collection") {
                var mockBehaviour: MockTransitionBehaviour!
                
                beforeEach {
                    mockBehaviour = MockTransitionBehaviour()
                    let collection = TransitionBehaviourCollection()
                    collection.transitionIdentifier = "Test"
                    collection.behaviours = [mockBehaviour]
                    fromController.transitionBehaviourCollections = [collection]
                }
                
                it("sets it up") {
                    transition.animateTransition(transitionContext)
                    
                    expect(mockBehaviour.didSetup) == true
                }
                
                it("adds it's animations") {
                    transition.animateTransition(transitionContext)
                    
                    expect(mockBehaviour.didAddAnimations) == true
                }
            }
        }
    }
    
}
