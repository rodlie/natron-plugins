# Crok_dithering_GL

Creates a dithering effect.

### INPUT(S)
* Source : Connect the image you want to apply the effect onto. (RGBA)
* Mask : Connect an image to apply the effect in a specific portion of the image. (RGBA)

### HOW TO USE IT

#### Dithering

* Enable : Enable dithering.
* Scale : Dithering scale.
* Dithering blend : Blend with original image.

#### Pixelisation

* Enable : Enable pixelisation.
* Size : Pixelisation size.
* Pixelisation blend : Blend with original image.

#### C64

* Enable : Enable C64 effect.
* Size : Pixelisation size.
* C64 blend : Blend with original image.

#### Options

* Source is premultiplied : Checked if source image is premultiplied.

#### Mask

* Mask : Use mask input.
* Invert mask : Invert input mask.
* Channel : Channel used as mask.

#### Mix

* Mix : Mix result with original image.

### OUTPUT
* RGBA