#lp_roughenEdges


Roughens the edges of a given alpha channel based on an adjustable noise.


### INPUTS
img = Connect the image you want to roughen the edges of.


### HOW TO USE IT
Play with the roughen and size to get a desired amount and look for your edges. You can adust the type to greatly influence the look of the roughend result. Further, you can adjust a motion-factor to let the roughen-layer animate over time.


### HOW DOES IT WORK
A simple noise hooks up to an iDistort node, so the roughen is basically a distortion of the edges.
