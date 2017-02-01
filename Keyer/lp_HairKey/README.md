#lp_HairKey

A keyless Keyer for fine detail like hair which is hard to come by with a matte.
Extracts the information with the help of a Cleanplate; a Constant can also be utilized with perfectly even screens.
Alongside this description, please also mind the tooltips inside the tool :)

### HOW TO USE IT
bg, img and cleanplate-inputs are mandatory, the use of a mask is strongly suggested though.
The tool should already work without much setup; basic inputs should be the hair type and and screen colour (the latter becomes obsolete if you set the 'despill' to none). Adjust intensity and saturation as needed, use the intensity non-uniform if you need to adjust the colour of the output.

### HOW DOES IT WORK
In all modes but 'universal', this tool with subtract the cleanplate from the original image and either add, screen or multiply it on top. 'dark', the mode that multiplies, is also treated by a few operations for this to work out right (inverting and shifting the hue 180°, for instace). 'intensity' adjusts the output of the subtraction by adjusting the gain. 'universal' also multiplies on top of the background, but in this case the img and cleanplate get divided, not subtracted from each other.
In many cases, it makes a lot of sense to despill the inputs before the operation; as a SeExprSimple-node is used, you may find the operation a bit slow so despill manually before and setting the operation to 'none' might benefit the performance (lp_Despill works faster because of the setup, the same tech is not implemented here for the sake simplicity)

![Screenshot](Resources/Screenshot.jpg)

HairKey in Action (look for the sublte detail, this really shines when moving)
