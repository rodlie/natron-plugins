# Defocus

Add a bokeh blur to the image. You can use an image to guide blur size.

It's not suited to act as a true ZBlur plugin ( to fake DOF using a Zpass ). But in some cases it can work.
If the guide image has sharp transitions the effect may not look natural.

Typicall use case can be to blur the bakground image in a composite to match the blur of the foreground.

Credits :

Orginal Shader by David Hoskins

License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

https://www.shadertoy.com/view/4d2Xzw

Adaptation to Natron : Alessandro Dalla Fontana

![Screenshot](Resources/Screenshot.jpg)
