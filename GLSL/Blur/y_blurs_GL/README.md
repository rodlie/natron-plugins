# y_blurs_GL

Blur a thing. Options include the abilty to constrain the blur within an optional matte input. This shader also provides the means to drive the amount of blur with the optional black and white strength channel. The blur algorithm is the artistry of Lewis Saunders.

### INPUTS :
- Source : source input (RGBA)
- Matte : mask (A)
- Strength : blur strength driving input (A)


### PARAMETERS :
- Colorspace : choose input colorspace
- Blur : blur intensity
- Blur X : additional horizontal blur intensity
- Blur Y : additional vertical blur intensity

- Red Bias : red channel blur intensity
- Green Bias : green channel blur intensity
- Blue Bias : blue channel blur intensity

## OPTIONS :
- Invert Matte : invert mask
- Constraint Blur to Matte : bound the effect within the mask
- Matte is Strength : use mask as strength
