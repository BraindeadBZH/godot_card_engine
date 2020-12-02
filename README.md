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


## What is not implemented

* Card modifiers
* Saving store to disks
* Manual sorting
* Container to container drag and drop
* Filters on DropArea
* Add animation loop when card is focused or active.
* Other features to be defined...


## Important folders

* _private: contains the generated code and data file, none of this file should be edited manually
* addons/cardengine: contains the code for the in editor plugin and for the core elements
* containers: contains the public code for your custom containers
* cards: contains the public code for your custom cards


## How to use the UI

### Locating the UI

The CardEngine UI can be accessed at the bottom of the Godot Engine window.


### The Databases tab

You can use the Databases tab to manage the databases. Double clicking an item in the list allows to edit the database's name. Click "Edit database" button to edit or delete existing cards.


### The Cards tab

You can use the Cards tab to manage the cards. The "Card ID" field with the "Save to" allow you to add/edit a card in selected database. The "Card ID" field with the "Load from" allow you to search and display a specific card in the selected database. Each list allows you to manage the corresponding data, Categories, Values and Texts. Double-clicking an item in a list allows you to edit it.


### The Containers tab

You can use the Containers tab to manage the containers. When creating a container it creates a scene inside the containers folder that use can add to your scenes to use it. Using the "Edit container" button allows you to modify the layout and other parameters. Double-clicking an item in the list allows you to change the container's name.

### The Animations tab

You can use the Animations tab to manage the animations. Created animations will be available to the containers editor. You have a sequence for the position, the rotation and the scale of the card. A sequence has to be initialized first before editing. This will create a default sequence with mandatory steps so the card start and return to its initial state. For each step, you can edit the the transition and the value. Important to note that values are relative to the card intial state. You can at anytime press the preview button to see what your sequences do. No change is saved to disk until the save button is pressed. Pressing the reset button will reload the animation from disk.
