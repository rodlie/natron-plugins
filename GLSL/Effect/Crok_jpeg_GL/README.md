# Crok_jpeg_GL

This shader simulates JPEG compression.

### INPUT(S)
* Source : Connect the image you want to apply the effect onto. (RGBA)
* Mask : Connect an image to apply the effect in a specific portion of the image. (RGBA)

### HOW TO USE IT

#### Setup

* Resolution : Overall image resolution.
* Quality : Amount of applied compression.

#### Options

* Source is premultiplied : Checked if source image is premultiplied.

#### Options

* Use mask : Use mask input.
* Invert mask : Invert mask input.
* Channel : Channel used as mask.

#### Mix

* Mix : Mix result with original image.

### OUTPUT
* RGBA