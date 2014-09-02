Schmelda Bread RPG Engine
=========================

What is this?
-------------

Schmelda Bread was a project started by myself to try to build a game engine that fully separated code from content, to make it as extensible as possible such that designers could edit vast portions of the game without programmers having to get involved.

The game engine in this case would be an RPG, and the end-goal is to create an extremely extensible RPG engine which is fully customizable using just XML. You would have full control over graphics going into the game, enemy AI, the style of the game (overworld or not?), general settings, etc. While yes, at their core many games created this way would be similar, all the gameplay fine-tuning would, in the end, be up to the designer. 


How far along is it?
--------------------

The truth is that since coming to university I haven't had a chance to work on it. Only recently have I updated it to the newest version of Haxe and OpenFL and it should compile successfully with Haxe 3.1.3 and OpenFL 2.0.1.

With that being said, there is actually a lot done on the project. The codebase is currently decently large and ready for more updates. 

The features currently available include:
-Custom maps and tilesheets; moving in and out of different maps is supported.
-Movement, layering, map scrolling, and collision detection are all working.
-Text engine is fully completed and working. More options in the XML need to be added, however.
-Getting into and out of a battle currently works, as does battle itself.
-All animations for characters and enemies can be set.
-Enemy AI can be programmed from XML; either when the enemy is in battle or just in the area.
-The pause menu (with statistics and item menu) currently works, but is not customizable at all yet.
-Items can be at least partially customized in XML.
-Key checking is implemented and extendable.

Although this is a hefty chunk already done, many more features need to go into it, such as:
-Redesign the battle system, make it smoother and cleaner.
-Add more support for NPCs and NPC AI.
-Add support for an "overworld".
-Add general, programmable, particle effects.
-Add programmable sequence breaks. (cutscenes, etc.)
-Don't let the program crash with a cryptic error if it can't find an asset...
-Make character stats customizable.
-Make battles more customizable.
-Make everything more customizable.
-And more things... (there can always be more added, I'm sure)


How do I get started with it?
-----------------------------

Just clone the repository and use the standard OpenFL workflow. The code is currently tested under C++ (Windows) and Flash compilation. Its not guaranteed to work on other systems since I haven't tested it, however.

Sample assets are included as well to give you an idea of the structure of the XML (be wary of the cactusmen, they can say some really strange things...). Current controls are:
-Arrow Keys for Movement
-Backspace for Pause Menu
-X to run
-Z to interact
-WASD to select action in combat, Arrow Keys to select character.
-F12 for fullscreen.
-Esc to exit.


Isn't this like the popular RPGMaker?
--------------------------------------

In a way, yes. Schmelda Bread was meant to be open-source, much more bare-bones (leaving more of the game up to the designer) and letting them use whatever tools they like. RPGMaker, to my knowledge, is much more self-contained and limited, and most of all, proprietary.


Why the name Schmelda Bread???
------------------------------

When I first started this project, it was supposed to be a game I was making with some friends.  When brainstorming for the game, I wanted to give the project a development name and with one friend in particular this name came out because it sounded nice, I suppose. In short, its completely arbitrary. Anyway, the project took a turn and pretty much became a personal project. The first commit is all work completed by myself with the exception of AreaNPC.hx, which was mostly created by myself and then edited by another friend of mine, Dave Loin.
