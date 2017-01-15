# fxT_Glowy

This is an alternative glow gizmo to Nuke's standard glow node. Features include: blending modes, glow size with more realistic-looking falloff, mask input, reformat settings, anamorphic look, color tinting, tolerance, gain, saturation, and more options to control the glow look. The glow falloff is created by exponentially increasing the blur value to create the more realistic look.


### INPUTS
rgba = connect the image you want to apply the glow onto.

mask = the mask you want to apply the glow through.


### HOW TO USE IT
glow operation : choose between 'plus/screen/under' blending mode ('under' work only if input has an alpha).

------------------------------------------------------------------------------------------------------------

Color tint : glow color

------------------------------------------------------------------------------------------------------------

tolerance : a treshold that defines what range of values the glow will be applied to.

fallof : lift the white point of the source.

gain : boost the glow brightness.

------------------------------------------------------------------------------------------------------------

glow radius : speaks for itself.

saturation : glow saturation.

------------------------------------------------------------------------------------------------------------

anamorphic stretch : horizontaly stretch the glow.

------------------------------------------------------------------------------------------------------------

effect only : outputs the glow only.

preserve alpha : output the same alpha as the input image.

invert mask : inverts the mask input, if there's one.

clamp white : obvious.

clamp black : obvious.

------------------------------------------------------------------------------------------------------------

glow opacity : adjusts the glow opacity


![Screenshot](snap_fxT_Glowy.png)