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
            
            var context: MockTransitionContext!
            var fromController: MockTransitionableViewController!
            var toController: MockTransitionableViewController!
            var container: UIView!
            
            beforeEach {
                context = MockTransitionContext()
                fromController = MockTransitionableViewController()
                toController = MockTransitionableViewController()
                container = UIView()
                
                context.container = container
                context.fromViewController = fromController
                context.toViewController = toController
            }
            
            it("should tell the from controller it will disappear") {
                transition.animateTransition(context)
                
                expect(fromController.willDisappearTransitionIdentifier) == "Test"
            }
            
            it("should tell the to controller it will appear") {
                transition.animateTransition(context)
                
                expect(toController.willAppearTransitionIdentifier) == "Test"
            }
            
        }
        
    }
    
}
