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
            var sourceController: MockTransitionableViewController!
            var destinationController: MockTransitionableViewController!
            var container: UIView!
            
            beforeEach {
                transitionContext = MockTransitionContext()
                sourceController = MockTransitionableViewController()
                destinationController = MockTransitionableViewController()
                container = UIView()
                
                transitionContext.container = container
            }
            
            func setupTransitionAndContext(forPresenting presenting: Bool) {
                transition.isPresenting = presenting
                transitionContext.fromViewController = presenting ? sourceController : destinationController
                transitionContext.toViewController = presenting ? destinationController : sourceController
            }
            
            describe("notifications") {
                beforeEach {
                    setupTransitionAndContext(forPresenting: true)
                }
                
                it("should tell the from controller it will disappear") {
                    transition.animateTransition(transitionContext)
                    
                    expect(sourceController.willDisappearTransitionIdentifier) == "Test"
                }
                
                it("should tell the to controller it will appear") {
                    transition.animateTransition(transitionContext)
                    
                    expect(destinationController.willAppearTransitionIdentifier) == "Test"
                }
            }
            
            describe("container view setup") {
                context("when presenting") {
                    beforeEach {
                        setupTransitionAndContext(forPresenting: true)
                    }
                    
                    it("places the source controller in the container at the bottom") {
                        transition.animateTransition(transitionContext)
                        
                        expect(container.subviews.indexOf(sourceController.view)) == 0
                    }
                    
                    it("places the destination controller in the container on the top") {
                        transition.animateTransition(transitionContext)
                        
                        expect(container.subviews.indexOf(destinationController.view)) == 1
                    }
                }
                
                context("when dismissing") {
                    beforeEach {
                        setupTransitionAndContext(forPresenting: false)
                    }
                    
                    it("places the source controller in the container at the bottom") {
                        transition.animateTransition(transitionContext)
                        
                        expect(container.subviews.indexOf(sourceController.view)) == 0
                    }
                    
                    it("places the destination controller in the container on the top") {
                        transition.animateTransition(transitionContext)
                        
                        expect(container.subviews.indexOf(destinationController.view)) == 1
                    }
                }
            }
            
            describe("behaviours") {
                var behaviour1: MockTransitionBehaviour!
                var behaviour2: MockTransitionBehaviour!
                var behaviour3: MockTransitionBehaviour!
                var allBehaviours: [MockTransitionBehaviour]!
                
                var sourceCollection: TransitionBehaviourCollection!
                var destinationCollection: TransitionBehaviourCollection!
                
                beforeEach {
                    behaviour1 = MockTransitionBehaviour()
                    behaviour2 = MockTransitionBehaviour()
                    behaviour2.behaviourIdentifier = "LinkTest"
                    behaviour3 = MockTransitionBehaviour()
                    behaviour3.behaviourIdentifier = "LinkTest"
                    allBehaviours = [behaviour1, behaviour2, behaviour3]
                    
                    sourceCollection = TransitionBehaviourCollection()
                    sourceCollection.transitionIdentifier = "Test"
                    sourceCollection.behaviours = [behaviour1, behaviour2]
                    sourceController.transitionBehaviourCollections = [sourceCollection]
                    sourceController.transitions = [transition]
                    
                    destinationCollection = TransitionBehaviourCollection()
                    destinationCollection.transitionIdentifier = "Test"
                    destinationCollection.behaviours = [behaviour3]
                    destinationController.transitionBehaviourCollections = [destinationCollection]
                    
                    setupTransitionAndContext(forPresenting: true)
                }
                
                describe("setup") {
                    it("configures isPresenting for all behaviours") {
                        transition.animateTransition(transitionContext)
                        
                        allBehaviours.forEach { expect($0.isPresenting) == true }
                    }
                    
                    it("configures isInteractive for all behaviours") {
                        transition.isInteractive = true
                        transition.animateTransition(transitionContext)
                        
                        allBehaviours.forEach { expect($0.isInteractive) == true }
                    }
                    
                    it("configures duration for all behaviours") {
                        transition.transitionDuration = 2
                        transition.animateTransition(transitionContext)
                        
                        allBehaviours.forEach { expect($0.transitionDuration) == 2 }
                    }
                    
                    it("calls setup callback for all behaviours") {
                        transition.animateTransition(transitionContext)
                        
                        allBehaviours.forEach { expect($0.didSetup) == true }
                    }
                    
                    it("links source to destination behaviours") {
                        transition.animateTransition(transitionContext)
                        
                        expect(behaviour2.destinationBehaviour) == behaviour3
                    }
                    
                    context("when dismissing") {
                        it("still links source to destination behaviours") {
                            setupTransitionAndContext(forPresenting: false)
                            
                            transition.animateTransition(transitionContext)
                            
                            expect(behaviour2.destinationBehaviour) == behaviour3
                        }
                    }
                }
                
                describe("adding animations") {
                    it("should call addAnimations callback on all behaviours") {
                        transition.animateTransition(transitionContext)
                        
                        allBehaviours.forEach { expect($0.didAddAnimations) == true }
                    }
                }
            }
            
            
        }
    }
    
}
