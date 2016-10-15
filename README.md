[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/mfclarke/BehaviourBasedTransitions.svg?branch=master)](https://travis-ci.org/mfclarke/BehaviourBasedTransitions)

# 🚅 The Transition Express

An experimental approach to building UIViewControllerAnimatedTransitioning transitions out of small configurable behaviour modules directly in the storyboard. A behaviour applies a single animation to a single ```UIView```, so in this way you can compose a complex transition out of small building blocks, all in the relative comfort of IB, without any code.

Hand over the transition animation implementation to your designer, and say goodbye to hundreds of lines of convoluted ```UIViewControllerAnimatedTransitioning``` implementation code!

## How to use it

The project has an example implementation of multiple transitions from one ```UIViewController``` to experiment with. All the detail is in the storyboard:

* A transition is made up of many ```TransitionBehaviour``` objects. Each of these objects is a concrete subclass of ```TransitionBehaviour```, and is used to apply a specific animation behaviour to a specific view. For example, the ```FadeOutTransitionBehaviour``` object will fade out the view it's connected to.
* Configurable properties (```IBInspectable``` of course) for every ```TransitionBehaviour```:
  * Animation curve - standard UIView animation curves: EaseIn, EaseOut, EaseInOut, Linear
  * Spring properties - using UIView animate spring velocity and damping
  * Relative start and end times, for timeline based animations
* A view can have many behaviours, so you can compose a complex animation for a single ```UIView``` out of multiple ```TransitionBehaviour``` objects.
* Each ```TransitionBehaviour``` belongs to a ```TransitionBehaviourCollection``` object. These are used to group behaviours for a single transition. In this way, one transition uses multiple ```TransitionBehaviour``` objects grouped by a ```TransitionBehaviourCollection```. This collection object has a ```transitionIdentifier```, which means you can implement multiple transitions from a single view controller. Usually you will have one of these in the source view controller and one in the destination, because you'll probably have stuff in both the source and destination you want to animate for a transition.
* Finally, your source view controller will need a ```BehaviourBasedTransition``` object, connected to the view controller's ```transitions``` collection outlet. This ```BehaviourBasedTransition``` has a ```transitionIdentifier``` (to link it with the behaviours) and a ```segueIdentifier``` to link it to the segue it should transition for.

## Including the framework
#### This is still in experimental stage, so things will likely change a lot and will change quite rapidly. You've been warned!
### Carthage
Add this repo to your Cartfile and follow standard Carthage procedure to build and link it.
### Git Submodule
Add this repo as a git submodule and then follow standard procedure to link the framework to your project.

## Advanced Behaviours

### Providing views for dynamic content
In a lot of cases, you'll want to transition views that are created dynamically (for example, a ```UIImageView``` in a ```UICollectionViewCell``` in the ```UICollectionView``` of your ```UICollectionViewController```). For this you can implement the ```TransitionBehaviourViewProvider``` protocol and connect to your ```TransitionBehaviour``` object. Use the ```viewForBehaviour(identifier:)``` method to implement logic to return the appropriate view for the behaviour. You can return nil, which will cause the behaviour to have no effect.

### Source/destination behaviour linking
There is support for linking behaviours that are situated in different view controllers. In this way, you can have a behaviour that effects a view in the source view controller, but uses the frame or other properties of a view in the destination controller for the animation. An example of this is the ```TransformToPositionSourceBehaviour``` and ```TransformToPositionDestinationBehaviour```, which via the ```behaviourIdentifier``` property are linked together to provide Photos.app style transitions (small image grows to full size in the new view controller). The combination of both behaviours handle snapshotting, movement, scale and view visibility for the whole transition effect.

## Roll your own TransitionBehaviours

To implement new ```TransitionBehaviour```s, simply subclass the ```TransitionBehaviour``` object and extend the 3 callback functions:

* ```setup``` is used to prepare your view for animation (```.alpha = 0``` it before fading in for example)
* ```addAnimations``` is used to implement the actual animation. Use the ```addAnimation``` function if want regular handling of the animation's start/duration, relative to the ```IBInspectable``` start/duration settings for free. Otherwise, feel free to do anything you want here that is animation related, as long as it's finished by the end of the ```transitionDuration```
* ```complete``` is used for clean up, to reset your views to an expected state

And don't forget to submit a PR with your fancy new behaviour ;)

## TODO

* Add more ```TransitionBehaviour```s (blur, 3D stuff, opacity), and expand the existing ones to allow physics based UIView animations configurable via IBInspectables
* Add tests
* Add Cocoapods, Carthage, Swift Package Manager support
