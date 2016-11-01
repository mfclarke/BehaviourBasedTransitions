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
        var transitionContext: MockTransitionContext!
        var sourceController: MockTransitionableViewController!
        var sourceControllerSuperview: UIView!
        var destinationController: MockTransitionableViewController!
        var container: UIView!
        
        var behaviour1: MockTransitionBehaviour!
        var behaviour2: MockTransitionBehaviour!
        var behaviour3: MockTransitionBehaviour!
        var allBehaviours: [MockTransitionBehaviour]!
        
        var sourceCollection: TransitionBehaviourCollection!
        var destinationCollection: TransitionBehaviourCollection!
        
        func setupTransitionAndContext(forPresenting presenting: Bool) {
            transition.isPresenting = presenting
            transitionContext.fromViewController = presenting ? sourceController : destinationController
            transitionContext.toViewController = presenting ? destinationController : sourceController
        }
        
        beforeEach {
            transition = BehaviourBasedTransition()
            transition.transitionIdentifier = "Test"
            transitionContext = MockTransitionContext()
            sourceController = MockTransitionableViewController()
            destinationController = MockTransitionableViewController()
            container = UIView()
            
            transitionContext.container = container
            
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
            
            sourceControllerSuperview = UIView()
            sourceControllerSuperview.addSubview(sourceController.view)
            
            setupTransitionAndContext(forPresenting: true)
        }
        
        describe("animateTransition") {
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
        
        describe("transitioning delegate") {
            it("sets presenting true when animationControllerForPresentedController called") {
                transition.isPresenting = false
                transition.animationControllerForPresentedController(
                    destinationController,
                    presentingController: sourceController,
                    sourceController: sourceController)
                
                expect(transition.isPresenting) == true
            }
            
            it("sets presenting false when animationControllerForDismissed called") {
                transition.animationControllerForDismissedController(destinationController)
                
                expect(transition.isPresenting) == false
            }
            
            context("when isInteractive true") {
                beforeEach {
                    transition.isInteractive = true
                }
                
                it("returns itself when interactionControllerForPresentation called") {
                    let returnVal = transition.interactionControllerForPresentation(transition)
                    
                    expect(returnVal === transition) == true
                }
                
                it("returns itself when interactionControllerForPresentation called") {
                    let returnVal = transition.interactionControllerForPresentation(transition)
                    
                    expect(returnVal === transition) == true
                }
            }
            
            context("when isInteractive false") {
                beforeEach {
                    transition.isInteractive = false
                }
                
                it("returns nil when interactionControllerForPresentation called") {
                    let returnVal = transition.interactionControllerForPresentation(transition)
                    
                    expect(returnVal).to(beNil())
                }
                
                it("returns nil when interactionControllerForPresentation called") {
                    let returnVal = transition.interactionControllerForPresentation(transition)
                    
                    expect(returnVal).to(beNil())
                }
            }
        }
        
        describe("transition completion") {
            context("when behaviours haven't completed animation") {
                it("shouldn't tell behaviours the transition completed") {
                    transition.animateTransition(transitionContext)
                    
                    allBehaviours.forEach { expect($0.completedPresentation).to(beNil()) }
                }
            }
            
            context("when some behaviours have completed but not all") {
                it("shouldn't tell behaviours the transition completed") {
                    transition.animateTransition(transitionContext)
                    
                    behaviour1.animationCompleted?()
                    behaviour2.animationCompleted?()
                    
                    allBehaviours.forEach { expect($0.completedPresentation).to(beNil()) }
                }
            }
            
            context("when all behaviours have completed") {
                context("when presenting and transition completed") {
                    beforeEach {
                        setupTransitionAndContext(forPresenting: true)
                        transition.animateTransition(transitionContext)
                        allBehaviours.forEach { $0.animationCompleted?() }
                    }
                    
                    it("should tell behaviours the transition completed with presentation") {
                        allBehaviours.forEach { expect($0.completedPresentation) == true }
                    }
                    
                    it("should tell the context the transition completed") {
                        expect(transitionContext.transitionCompleted) == true
                    }
                    
                    it("should tell the from controller it did disappear") {
                        expect(sourceController.didDisappearTransitionIdentifier) == "Test"
                    }
                    
                    it("should tell the to controller it did appear") {
                        expect(destinationController.didAppearTransitionIdentifier) == "Test"
                    }
                }
                
                context("when presenting and transition cancelled") {
                    beforeEach {
                        setupTransitionAndContext(forPresenting: true)
                        transition.animateTransition(transitionContext)
                        transitionContext.cancelled = true
                        allBehaviours.forEach { $0.animationCompleted?() }
                    }
                    
                    it("should tell behaviours the transition completed with dismissal") {
                        allBehaviours.forEach { expect($0.completedPresentation) == false }
                    }
                    
                    it("should tell the context the transition didn't complete") {
                        expect(transitionContext.transitionCompleted) == false
                    }
                    
                    it("should tell the from controller it did appear") {
                        expect(sourceController.didAppearTransitionIdentifier) == "Test"
                    }
                    
                    it("should tell the to controller it did disappear") {
                        expect(destinationController.didDisappearTransitionIdentifier) == "Test"
                    }
                    
                    it("should dismiss the destination view controller") {
                        expect(destinationController.dismissCalled) == true
                    }
                    
                    it("re-adds the source controller back to it's original superview") {
                        expect(sourceControllerSuperview.subviews.first) == sourceController.view
                    }
                }
                
                context("when dismissing and transition completed") {
                    beforeEach {
                        // At the moment, it requires the controller to have been presented with a
                        // BehaviourBasedTransition to be dismissed correctly
                        setupTransitionAndContext(forPresenting: true)
                        transition.animateTransition(transitionContext)
                        allBehaviours.forEach { $0.animationCompleted?() }
                        
                        setupTransitionAndContext(forPresenting: false)
                        transition.animateTransition(transitionContext)
                        allBehaviours.forEach { $0.animationCompleted?() }
                    }
                    
                    it("should tell behaviours the transition completed with dismissal") {
                        allBehaviours.forEach { expect($0.completedPresentation) == false }
                    }
                    
                    it("should tell the context the transition did complete") {
                        expect(transitionContext.transitionCompleted) == true
                    }
                    
                    it("should tell the from controller it did appear") {
                        expect(sourceController.didAppearTransitionIdentifier) == "Test"
                    }
                    
                    it("should tell the to controller it did disappear") {
                        expect(destinationController.didDisappearTransitionIdentifier) == "Test"
                    }
                    
                    it("re-adds the source controller back to it's original superview") {
                        expect(sourceControllerSuperview.subviews.first) == sourceController.view
                    }
                }
                
                context("when dismissing and transition cancelled") {
                    beforeEach {
                        // At the moment, it requires the controller to have been presented with a 
                        // BehaviourBasedTransition to be dismissed correctly
                        setupTransitionAndContext(forPresenting: true)
                        transition.animateTransition(transitionContext)
                        allBehaviours.forEach { $0.animationCompleted?() }
                        
                        setupTransitionAndContext(forPresenting: false)
                        transition.animateTransition(transitionContext)
                        transitionContext.cancelled = true
                        allBehaviours.forEach { $0.animationCompleted?() }
                    }
                    
                    it("should tell behaviours the transition completed with presentation") {
                        allBehaviours.forEach { expect($0.completedPresentation) == true }
                    }
                    
                    it("should tell the context the transition didn't complete") {
                        expect(transitionContext.transitionCompleted) == false
                    }
                    
                    it("should tell the from controller it did disappear") {
                        expect(sourceController.didDisappearTransitionIdentifier) == "Test"
                    }
                    
                    it("should tell the to controller it did appear") {
                        expect(destinationController.didAppearTransitionIdentifier) == "Test"
                    }
                }

            }
        }
    }
    
}
