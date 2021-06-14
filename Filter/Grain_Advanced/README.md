# Grain Advanced

Grain Advanced provides a robust set of options that compositors can use to match the film grain (or sensor noise) of their plates when integrating new elements.

This node is a port of a tool originally created by Spin VFX as part of their [Spin Nuke Gizmos repository.](https://github.com/SpinVFX/spin_nuke_gizmos)  According to SpinVFX, "the defaults are setup to resemble an HD Alexa plate's grain".  Settings, defaults, and node-graph construction largely match SpinVFX's implementation however this node clamps values below zero whereas version 1.1 of their tool does not.