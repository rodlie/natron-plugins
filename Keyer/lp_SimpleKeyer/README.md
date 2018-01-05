# lp_SimpleKeyer

A very simple keyer with a big variety of different operations inspired by Nukes most simple Keyer-node.

INPUTS

img = Connect the image you want to key from

HOW TO USE IT
Connect an image and choose the operation you want to use to create your key. You can adjust white- and black-point as needed to key the you want. You can also enable range-controls for added functionality.

HOW DOES IT WORK
Simply put, this tool copies channels (from different colourspaces or other operations) into the alpha channel, a following Grade-node helps with adjusting the levels. The red-, green- and bluescreen operations are the most simple colour-difference setups.
The range-control is build with a 2nd yet inverted Grade-node, the difference between the two is the resulting range.
