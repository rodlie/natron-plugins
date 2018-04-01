# lp_NoiseDistort

Distorts an image based on two different noise-layer for a more dynamic feel.
Can bring dead background photos (plants, water, etc) to life :)

### INPUTS

img = connect the main plate you want to distort

mask = masks the effect by a connected alpha-channel (needs to be activated within the tool)

### HOW TO USE IT

After connecting a plate, it makes sense to see if the size of small and big noise is appropriate. You can check the "preview noise" box to match the small noise with fine detail (e.g. leafs on a tree) and the big noise more with general areas (e.g. branches for a tree). In the Noise-tab you can adjust the look of the noise (and therefore the distortion) even further. Set the gain of the distortion appropriate to the needed movement.
By default, the noise is animated over time, you can adjust the frequency with the motion factor. You can also erase the Expression and animate this by hand, in case you need a sudden stop or increase of the movement.  

### HOW DOES IT WORK

Basically, two noises are created from the input format - one small, one big. An IDistort uses these as UV-plate to distort the plate - a very simple approach but can have a large impact :)

![Screenshot](wald_ezgif.gif)

![Screenshot](skyline_ezgif.gif)

