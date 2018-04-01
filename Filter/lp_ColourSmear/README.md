# lp_ColourSmear

This PyPlug is a feature-rich step-up of the EdgeExtend-Node introduced in v2.1.5 
Smeares/spreads out (or in) pixels around a given matte. Useful for the creation of cleanplates, giving edge-detail to (motion) blurred objects, and more.
Alongside this description, please also mind the tooltips inside the tool :)

### INPUTS

img = connect the main plate you want to smear pixel on

matte = connect an alpha channel to pull the smear from (optional, alternatively you can use the alpha of your img)

mask = masks the effect by a connected alpha-channel

### HOW TO USE IT

Only mandatory input is img, yet to utilize the integrated alpha to smear from you need to check the option inside the tool accordingly.
To use it, you simply increase the smear to match your needs. If your matte is too big or small, you can erode/dilate the edge with the controls (note: this won't affect the alpha-channel of img, which will always passthrough untouched). You should always try to keep the smear as little as possible to keep the most detail in your smeared area.
The precision-steps are multiple smears with decreasing values to keep more detail towards the edge. An integrated SeGrain node can be set up to match the grain of your input, which is handy for retouchings.
You can also check to only apply the smear alone on black instead of the image.

This tools works great for retouching smaller details (pimples, tracking markers...) as well as creating cleanplates for greenscreens. Another big use is to extrude colour from the edge of a blurred object, for example if you need to key a heavily motionblurred object.
Another use is to "track" a colour by rendering it on black, this can be used to to retouch bigger areas or help with applying light to objects; this works great even with fast changes and multiple ramps between colours.

### HOW DOES IT WORK

Basically it works by unpremultiplying a blurred, premultiplied portion of an image. You can read more about this on Richard Frazers blog, which was also the inspiration for this tool: http://richardfrazer.com/tools-tutorials/colour-smear-for-nuke/
The precision-mode works by stacking multiple blurs on top of each other, pretty simple actually; yet Frédéric Devernay optimised this task by introducing the Plugin "EdgeExtend" which helps greatly with speed and a variable precision-mode. The rest are simply comfort-functions :)

![Screenshot](Resources/Screenshot.jpg)

Two uses of ColourSmear
