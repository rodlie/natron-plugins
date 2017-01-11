# AdditiveKeyer


 This is not a keyer, as it does not create a matte that is of use. It is more of a 'relative mixer' or image blending tool. It is very good for separating translucent fine details (such as motion blur, dust or hair) that a keyers with mattes might have difficulties extracting.

 To get it to work requires a lot of prep work on the screen and reference to work with uneven screens.

 It is used in combination with normal keyer that provides the main core of the comp and the additive keyer generates only the subtle soft edges.


### INPUTS
fg = connect the bluescreen/greenscreen image.

bg = connect the background image

mask = connect the key from your bluescreen/greenscreen.


### HOW TO USE IT

User Color : select the color of your bluescreen/greenscreen.

Enable Color : enable user color.

----------------------------------------------------------------------------------------------------------------------

High Pass : boost up the low value of the fg.

Low Pass : boost up the high value of the fg.

----------------------------------------------------------------------------------------------------------------------

Adjust background : grade the input bg.

----------------------------------------------------------------------------------------------------------------------

Overall gain : grade the final result.

----------------------------------------------------------------------------------------------------------------------

Use mask : use additional mask input.

Invert mask : invert mask input.