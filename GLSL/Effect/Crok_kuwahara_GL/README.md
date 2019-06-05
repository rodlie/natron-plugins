# Crok_kuwahara_GL

Simulates anisotropic kuwahara filtering.

### INPUT(S)
* Source : Connect the image you want to apply the effect onto. (RGBA)
* Mask : Connect an image to apply the effect in a specific portion of the image. (RGBA)

### HOW TO USE IT

#### Setup

* Radius : Effect radius.

#### Options

* Source is premultiplied : Checked if source image is premultiplied.

#### Mask

* Use mask : Use mask input.
* Invert mask : Invert mask input.
* Channel : Channel used as mask.

#### Mix

* Mix : Mix result with original image.

### OUTPUT
* RGBA