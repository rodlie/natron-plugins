#lp_ChillSpill

Advanced, yet easy to use despill with a variety of algorithms, working in R, G and B.

INPUTS

img = connect the main plate you want to despill

bg = connect a background image to use its colourinformation in the despill-process

mask = masks the effect by a connected alpha-channel

HOW TO USE IT
Connect an image and set the appropriate screen-colour, the tool defaults to green. To get the best out of your material, you can try to alter the algorithm or replacement-method; the default luma restore tries to give the most neutral result (yet might be a bit bright, too). You can weight the average-operation towards one of the replacement channels (e.g. either red or blue for a greenscreen). You can also amp the replacement channels up or down before the algorithm, this can help tackling some nasty edges and other shortcomings of the technique.
You can connect the background-image to apply the colours of it to the despilled areas, adjusting the pre-blur might be important. A handful correcting-parameters are build-in too.
Last but not least, the tool enables you to shuffle a spillmatte into the alpha channel, in case you need it for further adjustments (or for an entire key).

HOW DOES IT WORK
Pure, boring math of channels.
