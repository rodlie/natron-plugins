Easy to use despill with a variety of algorithms, working in R, G and B.

### INPUTS
img = connect the main plate you want to despill
bg = connect a background image to use its colourinformation in the despill-process
mask = masks the effect by a connected alpha-channel

### HOW TO USE IT
Connect an image and set the appropriate screen-colour. To get the best out of your material, you can try to alter the algorithm, despill method and replacement; the default luma restore tries to give the most neutral result.
You can connect the background-image to apply its information to the despilled areas. A handful correcting-parameters are build-in too.
Last but not least, the tool enables you to shuffle a spillmatte into the alpha channel, in case you need it for further adjustments (or for an entire key).

For really problematic shots with nasty edges etc, it might be clever to make one really aggressive despill for the edges and another, normal one for the core; keymixed by a core-matte from the initial key.

### HOW DOES IT WORK
Pure, boring math of channels. 
