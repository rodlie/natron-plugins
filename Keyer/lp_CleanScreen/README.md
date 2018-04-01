# lp_CleanScreen

CleanScreen helps you to even out chroma-background (R, G or B) with the help of a cleanplate.

### HOW TO USE IT

Just connect your shot and the cleanplate, pick the screen colour and watch it automagically clean your screen :)
Note that while you can hook up generated cleanplates, it usually makes more sense to use the real thing.


### HOW DOES IT WORK

The colour-picker for the screen colour calculates which kinda screen (red, green or blue) needs to be used for the operation.
For both, the shot and the cleanplate, a basic colour-difference key is applied and divided from one another. The difference of a constant (in the same colour as the selected screen colour) with the cleanplate is then multiplied with that result, and finally subtracted from the original plate.

![Screenshot](Resources/Screenshot.jpg)
