# L_Fuse

Fuse is a replacement for the merge(over) node.  

"Light Flare” : wraps a luma keyed background over the foreground.  Only the brighter parts of the image are wrapped.  

"Wrap All” : wraps all of the background values over the foreground.

"Bleed Color” : wraps hue values from the background over the foreground.  It replaces foreground hue values with background values.  

"Edge Blur” : blurs the edge areas of the composite.  This edge is determined by alpha transparency. So any parts of the alpha that are semi-transparent will be blurred.

"Apply operations in Log” : will layer the foreground over the background in a Log colorspace resulting sometimes in a preferable result.


![Screenshot](L_Fuse_snap.png)

