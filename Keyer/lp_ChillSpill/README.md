# lp_ChillSpill

Advanced, yet easy to use despill with a variety of algorithms, working in R, G and B.

### HOW TO USE IT
Connect an image and set the appropriate screen-colour. To get the best out of your material, you can try to alter the algorithm, despill method and replacement; the default luma restore tries to give the most neutral result. You can weight the average-operation towards one of the replacement channels (e.g. either red or blue for a greenscreen). You can also amp the replacement channels up or down before the algorithm, this can help tackling some nasty edges and other shortcomings of the technique. A PIK Keyer can be used for advanced adjustments which can help with nasty coloured edges; with default settings, PIK acts the same as average.
You can connect the background-image to applyits information to the despilled areas. A handful correcting-parameters are build-in too.
Last but not least, the tool enables you to shuffle a spillmatte into the alpha channel, in case you need it for further adjustments (or for an entire key).

For really problematic shots with nasty edges etc, it might be clever to make one really aggressive despill for the edges and another, normal one for the core; keymixed by a core-matte from the initial key.

### HOW DOES IT WORK
Pure, boring math of channels.
