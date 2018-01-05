# lp_Feather

Feathers your alpha channel, with advanced control over the feather type as well as the falloff. Works only on the alpha. 


### HOW TO USE IT
It's pretty straight forward, just play with the erode- and feather-sliders as you need. The feather-type will determine if your feather goes omnidirectional or outwards/inwards of your shape (like the feather inside the Roto node). Different filters for both operations can be used.
Further, you can control the falloff. The smooth-operations work the same as in Nuke, with an added option to alter the operation manually.

### HOW DOES IT WORK
The 'omni' feather is a simple, common blur which works best with eroding the alpha before to get a nice and even feather. The 'classic' mode is enabled by an adjusted black respectively white point to maintain the original shape, so the blur only heads in one direction. This works best with roto shapes; for more detailed mattes with grey values etc you can use 'classic_detailed' which tries to bypass clipping details. This mode is a bit heavier on the machine and works not as good with roto shapes.
The falloff-operations are directly inspired from Nuke, where 'smooth0' and 'smooth1' have a bezier-curve going towards a linear black/white point ('smooth0' goes smooth from black, 'smooth1' goes smooth from white); 'smooth' has a bezier-curve for both points, forming a slight s-curve. The 'manual' option is nothing more than a simple gamma-adjustment :)


