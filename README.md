# Behaviour Based Transitions

An experimental approach to building UIViewControllerAnimatedTransitioning transitions without having to code the detail of the transitions. Uses a generic, modular, single responsibility, IB friendly based architecture.

## How it works

The source and destination controllers conform to the ```BehaviourTransitionable``` protocol, which gives an array of ```TransitionBehaviour``` objects.

The ```BehaviourBasedTransition``` simply combines the ```TransitionBehaviour``` objects from the source and destination controllers and then just iterates through them to run setup, animate and complete callbacks. The TransitionBehaviour objects handle the actual modification of the views (alpha, transform etc) at each callback step.

The magic is in the storyboard though. By using IB objects, we can link the ```TransitionBehaviour``` outlets to the views they're animating on. And with IBInspectable properties, we can configure the parameters of each individual view transition.

Provided there is a ```TransitionBehaviour``` object that does the general animation type you need, there is no need to write a single line of code to implement complex transitions!

## Caveats

The ```TransitionBehaviour```s for the destination VC have to reside in the destination VC. So the behaviours are split over 2 VCs in the storyboard. Not such a big deal, but something to be aware of.

## TODO

* Move the animate() callback outside of the ```BehaviourBasedTransition``` animate function, and migrate ```TransitionBehaviour``` to create keyframe animations instead (with IBInspectable delay and relate start/end times)
* Add more ```TransitionBehaviour```s, and expand the existing ones to allow physics based UIView animations configurable via IBInspectables
* Allow VCs to have multiple transitions with unique identifiers (like segues), each with their own set of behaviours
* Add ```TransitionBehaviour``` protocol to allow ```TransitionBehaviour```s to ask a view for the correct view to transition, in the case of embedded controllers, table views or collection views. Eg, a collection view could offer the image in a cell as the view to transition
