CardEngine for Godot Engine
==========

Currently under development, do not expect it to work.

**Everything is work in progress.**


## Glossary

* **Card**: card data with id, name, categories, values and texts
* **Database**: persistent card data storage
* **Container**: UI element to display cards in a given layout using a card visual 
* **Store**: in memory card data storage (deck, pile, hand)
* **Animation**: a sequence of values linked together by transition, defined by a duration and an easing curve
* **Effect**: modifiers on cards data that can be applied and cancelled at anytime


## What is implemented

* Creating, modifying and deleting databases
* Creating, modifying and deleting cards
* Creating, modifying and deleting containers
* Containers layouting as a grid or along a path
* Fine tuning containers layout with linear/symmetric interpolation or random position, scale and rotation
* Container transition animation (card re-order, card added, card removed)
* Container event animation (idle, focused)
* Animation editor
* Drag and drop support
* Card effects
* Filters on DropArea
* Saving store interface
* Container to container drag and drop


## What is not implemented

* Manual sorting
* Drop placeholder
* Add animation loop when card is focused or active
* More modifiers to come
* Other features to be defined...


## Important folders

* _private: contains the generated code and data file, none of this file should be edited manually
* addons/cardengine: contains the code for the in editor plugin and for the core elements
* containers: contains the public code for your custom containers
* cards: contains the public code for your custom cards
* effects: contains the code for the effects


## Documentation

### Getting started

[Open page](https://www.braindead.bzh/page/getting-started)


### Detailed usage

[Open page](https://www.braindead.bzh/page/documentation)
