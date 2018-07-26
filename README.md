![Image](Resources/community-plugins-logo.png)
# Natron Community Plugins
### A collection of Natron plugins made by the community
## Installation
### Upgradable Install

The plugins can be installed by simply cloning the github repository at the righht location, for example on Linux:

    cd /usr/share/Natron/Plugins
    git clone https://github.com/NatronGitHub/natron-plugins.git

Later, the plugins can be updated at any time by pulling updates:
  
    cd /usr/share/Natron/Plugins/natron-plugins
    git pull
 
### One-Time Install

To install a snapshot of the repository, download it as a ZIP file via https://github.com/NatronGitHub/natron-plugins/archive/master.zip
 
Unzip into any PyPlug folder but the recommended locations are...
 
    Windows: "C:\Program Files\Common Files\Natron\Plugins"
    
    OSX:     "/Library/Application Support/Natron/Plugins"
    
    Linux:   "/usr/share/Natron/Plugins"
    

Finally edit the plugins location in Natron preferences to allow it to find them during startup, if it's not already.
If you want a particular folder only you can use http://kinolien.github.io/gitzip/ and put the URL to the folder you want there. Also you can install individual .py files (and their accompanied png icon files).


## Available Plugins

### BL/Color
- <img src='/BL/Color/bl_Bytes/bl_Bytes.png' width='24'> **[bl_Bytes](/BL/Color/bl_Bytes/README.md)** : Converts the picture in another byte space. This is of course a simple simulation as Natron works only in 32 floating point color space.

- <img src='/BL/Color/bl_Compress/bl_Compress.png' width='24'> **[bl_Compress](/BL/Color/bl_Compress/README.md)** : A common color correction function that pushes the low color to a value and the high color to one another. While tempting to made a color matching between 2 picture this PyPlug might be really usefull.

- <img src='/BL/Color/bl_Expand/bl_Expand.png' width='24'> **[bl_Expand](/BL/Color/bl_Expand/README.md)** : Does the exact reverse of the Compress node. It stretches the color between to low and high color values.

- <img src='/BL/Color/bl_Monochrome/bl_Monochrome.png' width='24'> **[bl_Monochrome](/BL/Color/bl_Monochrome/README.md)** : Same as the Shake's Monochrome node. You can play independently with the 3 color components.

- <img src='/BL/Color/bl_Slice/bl_Slice.png' width='24'> **[bl_Slice](/BL/Color/bl_Slice/README.md)** : Cut a color slice of the picture and create a mask of the result.

- <img src='/BL/Color/bl_Threshold/bl_Threshold.png' width='24'> **[bl_Threshold](/BL/Color/bl_Threshold/README.md)** : Thresholds the image using a color value, a range of thresholding and a replacement color.

### BL/Image
- <img src='/BL/Image/bl_Arc/bl_Arc.png' width='24'> **[bl_Arc](/BL/Image/bl_Arc/README.md)** : A circle drawer.

### BL/Keyer
- <img src='/BL/Keyer/bl_HSVKeyer/bl_HSVKeyer.png' width='24'> **[bl_HSVKeyer](/BL/Keyer/bl_HSVKeyer/README.md)** : Creates a mask using the hue saturation and value of the color range.

### BL/Warp
- <img src='/BL/Warp/bl_Bulge/bl_Bulge.png' width='24'> **[bl_Bulge](/BL/Warp/bl_Bulge/README.md)** : The Bulge function is a copy of the Bulge inside AfterEffect. This PyPlug is basicaly creating a drop/buble effect on a picture.

### Channel
- <img src='/Channel/ChannelOffset/ChannelOffset.png' width='32'> **[ChannelOffset](/Channel/ChannelOffset/README.md)** : Easier to use than the basic TransformMasked node, with additional blur option, and auto-edge extension feature.

- <img src='/Channel/ChannelMerge/ChannelMerge.png' width='32'> **[ChannelMerge](/Channel/ChannelMerge/README.md)** : ChannelMerge that mimics Nuke's one.

- <img src='/Channel/Copy_Layer/Copy_Layer.png' width='32'> **[Copy_Layer](/Channel/Copy_Layer/README.md)** : Copy RGBA channels from the A input to any layer of the B branch.

- <img src='/Channel/Copy_N/Copy_N.png' width='32'> **[Copy_N](/Channel/Copy_N/README.md)** : Nuke Copy node.

- <img src='/Channel/L_ChannelSolo/L_ChannelSolo.png' width='32'> **[L_ChannelSolo](/Channel/L_ChannelSolo/README.md)** : Easy to use channel selector.

- <img src='/Channel/Shuffle_N/Shuffle_N.png' width='32'> **[Shuffle_N](/Channel/Shuffle_N/README.md)** : Inverted Shuffle node.

- <img src='/Channel/Zmatte/Zmatte.png' width='32'> **[Zmatte](/Channel/Zmatte/README.md)** : Creates a smooth matte from z-depth pass.

### Color
- <img src='/Color/L_Icolor/L_Icolor.png' width='32'> **[L_Icolor](/Color/L_Icolor/README.md)** : Tint an image from the A input using another one from the B input.

- <img src='/Color/lp_Tweaky/lp_Tweaky.png' width='32'> **[lp_Tweaky](/Color/lp_Tweaky/README.md)** : Provides a variety of little tweaking-options, like Vibrance, WB-Slider, Tint, etc.

### Draw
- <img src='/Draw/FrameStamp/FrameStamp.png' width='32'> **[FrameStamp](/Draw/FrameStamp/README.md)** : A very simple stamp that show the current frame in the corner of the image.

- <img src='/Draw/Gradient/Gradient.png' width='32'> **[Gradient](/Draw/Gradient/README.md)** : A 3-4 Way gradient.

- <img src='/Draw/LightWrap_Simple/LightWrap_Simple.png' width='32'> **[LightWrap_Simple](/Draw/LightWrap_Simple/README.md)** : An alternative to built-in LightWrap plugin, simpler to use, also it as an option to dilate wrap to get a bigger effect.

- <img src='/Draw/Vignette/Vignette.png' width='32'> **[Vignette](/Draw/Vignette/README.md)** : This effect reduce the images brightness at the peripherie compared to the image center.

### Filter
- <img src='Filter/Light%20Sweep/lighsweep_icon.png' width='32'> **[Light Sweep](/Filter/Light%20Sweep/README.md)** : Creates Light Sweep.

- <img src='/Filter/Beauty/Beauty.png' width='32'> **[Beauty](/Filter/Beauty/README.md)** : Tool designed to achieve skin cleaning jobs.

- <img src='/Filter/Antialiasing/AntiAliasing.png' width='32'> **[AntiAliasing](/Filter/Antialiasing/README.md)** : Antialiasing filter based on FXAA

- <img src='/Filter/ChromaticAberrationPP/ChromaticAberrationPP.png' width='32'> **[ChromaticAberrationPP](/Filter/ChromaticAberrationPP/README.md)** : A filter designed to match real camera chromatic aberration 

- <img src='/Filter/Chromatic_Aberration/Chromatic_Aberration.png' width='32'> **[Chromatic_Aberration](/Filter/Chromatic_Aberration/README.md)** : Create a stylised Chromatic Aberration effect, similar to the one found in Blender.

- <img src='/Filter/DePepper/DePepper.png' width='32'> **[DePepper](/Filter/DePepper/README.md)** : Remove Salt and Pepper noise 

- <img src='/Filter/Defocus/Defocus.png' width='32'> **[Defocus](/Filter/Defocus/README.md)** : Add a bokeh blur to the image. You can use an image to guide blur size, note that it's not intended to act as a ZBlur plugin.

- <img src='/Filter/FireflyKiller/FireflyKiller.png' width='32'> **[FireflyKiller](/Filter/FireflyKiller/README.md)** : Removes fireflies, very bright, nervously jumping around pixels.

- <img src='/Filter/Mosaic/Mosaic.png' width='32'> **[Mosaic](/Filter/Mosaic/README.md)** : A basic mosaic effect.

- <img src='/Filter/Orton/Orton.png' width='32'> **[Orton](/Filter/Orton/README.md)** : Orton Effect.

- <img src='/Filter/PM_VectorBlur/PM_VectorBlur.png' width='32'> **[PM_VectorBlur](/Filter/PM_VectorBlur/README.md)** : Poor Man's Vector Blur. Blur an image according to a Vector/Motion Pass, read the doc to know more about limitation

- <img src='/Filter/Refraction/Refraction.png' width='32'> **[Refraction](/Filter/Refraction/README.md)** : Glass distorsion using a UV pass.

- <img src='/Filter/SharpenPlus/SharpenPlus.png' width='32'> **[SharpenPlus](/Filter/SharpenPlus/README.md)** : Image sharper.

- <img src='/Filter/Volume_Rays/Volume_Rays.png' width='32'> **[Volume_Rays](/Filter/Volume_Rays/README.md)** : Enhanced version of Natron's native GodRays, featuring advanced options.

- <img src='/Filter/fxT_Glowy/fxT_Glowy.png' width='32'> **[fxT_Glowy](/Filter/fxT_Glowy/README.md)** : This is an alternative glow effect that mimics the feature of the same gizmo in Nuke.

- <img src='/Filter/L_BlurHue/L_BlurHue.png' width='32'> **[L_BlurHue](/Filter/L_BlurHue/README.md)** : A simple hue blur filter.

- <img src='/Filter/lp_ColourSmear/lp_ColourSmear.png' width='32'> **[lp_ColourSmear](/Filter/lp_ColourSmear/README.md)** : Smears the colors around a given Alpha.

- <img src='/Filter/lp_Despot/lp_Despot.png' width='32'> **[lp_Despot](/Filter/lp_Despot/README.md)** : Despots for black or white pixels.

- <img src='/Filter/lp_Feather/lp_Feather.png' width='32'> **[lp_Feather](/Filter/lp_Feather/README.md)** : Feathers your alpha channel

- <img src='/Filter/lp_fakeDefocus/lp_fakeDefocus.png' width='32'> **[lp_fakeDefocus](/Filter/lp_fakeDefocus/README.md)** : A very faky Defocus. Very faky. Not very good. Might work for tiny things.

- <img src='/Filter/lp_roughenEdges/lp_roughenEdges.png' width='32'> **[lp_roughenEdges](/Filter/lp_roughenEdges/README.md)** : Roughens the edges of a given alpha channel based on an adjustable noise.

### Filter/Duck
- <img src='/Filter/DUCK_Alpha_Edge/DUCK_Alpha_Edge.png' width='32'> **[DUCK_Alpha_Edge](/Filter/DUCK_Alpha_Edge/README.md)** : It gives edge of a roto or a key, you have the possibility to dilate or erode, blur or multiply the edge differently inside and outside. Simply the best alpha edge you can find for free.

- <img src='/Filter/DUCK_Denoise/DUCK_Denoise.png' width='32'> **[DUCK_Denoise](/Filter/DUCK_Denoise/README.md)** : It helps to denoise a footage, since it is  not based on analisys: it just provides a denoise for black/white and coloured dots.

- <img src='/Filter/DUCK_Skin_Cleaner/DUCK_Skin_Cleaner.png' width='32'> **[DUCK_Skin_Cleaner](/Filter/DUCK_Skin_Cleaner/README.md)** : A tool developped to clean up models skin in common beauty/fashion shots.

- <img src='/Filter/DUCK_Smart_Blur/DUCK_Smart_Blur.png' width='32'> **[DUCK_Smart_Blur](/Filter/DUCK_Smart_Blur/README.md)** : Smart Blur isn't a common blur, it helps to blur images with heavy grain, surface imperfections, noises, render problems, etc. keeping the boundary and the edges, and restoring details in highlights and dark regions of the image.

### Filter/Pixelfudger
- <img src='/Filter/PxF_Bandpass/PxF_Bandpass.png' width='32'> **[PxF_Bandpass](/Filter/PxF_Bandpass/README.md)** : Extract detail from an image. Useful to make plates easier to track.

- <img src='/Filter/PxF_ChromaBlur/PxF_ChromaBlur.png' width='32'> **[PxF_ChromaBlur](/Filter/PxF_ChromaBlur/README.md)** : Blur chrominance without affecting luminance. Useful to repair some chroma artifacts in digital video.

### GLSL/Blur
- <img src='/GLSL/Blur/Barrel_Blur_Chroma_GL/Barrel_Blur_Chroma_GL.png' width='24'> **[Barrel_Blur_Chroma_GL](/GLSL/Blur/BlurBarrel_Blur_Chroma_GL/README.md)** : GPU accelerated Barrel chroma blur effect for Shadertoy.

- <img src='/GLSL/Blur/Bilateral_GL/Bilateral_GL.png' width='24'> **[Bilateral_GL](/GLSL/Blur/BlurBilateral_GL/README.md)** : GPU accelerated Bilateral blur for Shadertoy.

- <img src='/GLSL/Blur/Bloom_GL/Bloom_GL.png' width='24'> **[Bloom_GL](/GLSL/Blur/BlurBloom_GL/README.md)** : GPU accelerated Bloom effect for Shadertoy.

- <img src='/GLSL/Blur/BokehCircular_GL/BokehCircular_GL.png' width='24'> **[BokehCircular_GL](/GLSL/Blur/BokehCircular_GL/README.md)** : GPU accelerated circular defocus blur for Shadertoy.

- <img src='/GLSL/Blur/BokehDisc_GL/BokehDisc_GL.png' width='24'> **[BokehDisc_GL](/GLSL/Blur/BlurBokehDisc_GL/README.md)** : GPU accelerated defocus blur for Shadertoy.

- <img src='/GLSL/Blur/BokehOctagon_GL/BokehOctagon_GL.png' width='24'> **[BokehOctagon_GL](/GLSL/Blur/BokehOctagon_GL/README.md)** : GPU accelerated octagon defocus blur for Shadertoy.

- <img src='/GLSL/Blur/Crok_bloom_GL/Crok_bloom_GL.png' width='24'> **[Crok_bloom_GL](/GLSL/Blur/BlurCrok_bloom_GL/README.md)** : Simulates bloom.

- <img src='/GLSL/Blur/Crok_convolve_GL/Crok_convolve_GL.png' width='24'> **[Crok_convolve_GL](/GLSL/Blur/BlurCrok_convolve_GL/README.md)** : Simulates a convolve blur.

- <img src='/GLSL/Blur/Crok_diffuse_GL/Crok_diffuse_GL.png' width='24'> **[Crok_diffuse_GL](/GLSL/Blur/BlurCrok_diffuse_GL/README.md)** : Creates a noisy blur.

- <img src='/GLSL/Blur/Crok_dir_blur_GL/Crok_dir_blur_GL.png' width='24'> **[Crok_dir_blur_GL](/GLSL/Blur/BlurCrok_dir_blur_GL/README.md)** : Creates a directional blur.

- <img src='/GLSL/Blur/Crok_reskin_GL/Crok_reskin_GL.png' width='24'> **[Crok_reskin_GL](/GLSL/Blur/Crok_reskin_GL/README.md)** : Creates skin type textures.

- <img src='/GLSL/Blur/Ls_Ash_GL/Ls_Ash_GL.png' width='24'> **[Ls_Ash_GL](/GLSL/Blur/BlurLs_Ash_GL/README.md)** : Sharpen without ringing edges, or sharpen edges without increasing texture.

- <img src='/GLSL/Blur/Mipmap_Blur_GL/Mipmap_Blur_GL.png' width='24'> **[Mipmap_Blur_GL](/GLSL/Blur/BlurMipmap_Blur_GL/README.md)** : GPU accelerated Mipmap blur for Shadertoy.

- <img src='/GLSL/Blur/Monte_Carlo_Blur_GL/Monte_Carlo_Blur_GL.png' width='24'> **[Monte_Carlo_Blur_GL](/GLSL/Blur/BlurMonte_Carlo_Blur_GL/README.md)** : GPU accelerated Monte-Carlo blur for Shadertoy.

### GLSL/Channel
- <img src='/GLSL/Channel/JB_multiMatteManager_GL/JB_multiMatteManager_GL.png' width='24'> **[JB_multiMatteManager_GL](/GLSL/Channel/JB_multiMatteManager_GL/README.md)** : Manages up to four inputs RGB to output one combined mulitmatte with alpha.

- <img src='/GLSL/Channel/K_RgbcmyMatte_GL/K_RgbcmyMatte_GL.png' width='24'> **[K_RgbcmyMatte_GL](/GLSL/Channel/K_RgbcmyMatte_GL/README.md)** : Separates Red, Green, Blue, Cyan, Magenta, Yellow and White from a matte pass.

- <img src='/GLSL/Channel/Shuffle_AtoRGB_GL/Shuffle_AtoRGB_GL.png' width='24'> **[Shuffle_AtoRGB_GL](/GLSL/Channel/Shuffle_AtoRGB_GL/README.md)** : Copy the alpha to the RGB.

### GLSL/Color
- <img src='/GLSL/Color/AFX_Grade_GL/AFX_Grade_GL.png' width='24'> **[AFX_Grade_GL](/GLSL/Color/AFX_Grade_GL/README.md)** : Based off the Nuke grade node.

- <img src='/GLSL/Color/Crok_2color_GL/Crok_2color_GL.png' width='24'> **[Crok_2color_GL](/GLSL/Color/Crok_2color_GL/README.md)** : Simulates a 2 color look.

- <img src='/GLSL/Color/Crok_exposure_GL/Crok_exposure_GL.png' width='24'> **[Crok_exposure_GL](/GLSL/Color/Crok_exposure_GL/README.md)** : Simulates an exposure node.

- <img src='/GLSL/Color/JB_colorRemap_GL/JB_colorRemap_GL.png' width='24'> **[JB_colorRemap_GL](/GLSL/Color/JB_colorRemap_GL/README.md)** : Remaps RGB of input1 using RGB of input 2.

- <img src='/GLSL/Color/K_BW_GL/K_BW_GL.png' width='24'> **[K_BW_GL](/GLSL/Color/K_BW_GL/README.md)** : Creates black and white images with adjustable RGB values.

- <img src='/GLSL/Color/Ls_Colourmatrix_GL/Ls_Colourmatrix_GL.png' width='24'> **[Ls_Colourmatrix_GL](/GLSL/Color/Ls_Colourmatrix_GL/README.md)** : Apply 3x3 matrices to RGB for white balance, colourspace conversion or well disco grades.

- <img src='/GLSL/Color/Ls_NaNfix_GL/Ls_NaNfix_GL.png' width='24'> **[Ls_NaNfix_GL](/GLSL/Color/Ls_NaNfix_GL/README.md)** : Fixes pixels which are stuck at NaN.

- <img src='/GLSL/Color/Ls_RndmGrade_GL/Ls_RndmGrade_GL.png' width='24'> **[Ls_RndmGrade_GL](/GLSL/Color/Ls_RndmGrade_GL/README.md)** : Generates random grades. Works best on log footage or low-contrast ungraded video.

### GLSL/Distort
- <img src='/GLSL/Distort/Crok_heathaze_GL/Crok_heathaze_GL.png' width='24'> **[Crok_heathaze_GL](/GLSL/Distort/Crok_heathaze_GL/README.md)** : Creates a heat haze effect.

- <img src='/GLSL/Distort/Crok_noise_blur_GL/Crok_noise_blur_GL.png' width='24'> **[Crok_noise_blur_GL](/GLSL/Distort/Crok_noise_blur_GL/README.md)** : Creates a noise texture similar to the popular Genarts Texture.

- <img src='/GLSL/Distort/Crok_pixelsort_GL/Crok_pixelsort_GL.png' width='24'> **[Crok_pixelsort_GL](/GLSL/Distort/Crok_pixelsort_GL/README.md)** : Creates a pixel sort type effect.

- <img src='/GLSL/Distort/Crok_pixelstretch_GL/Crok_pixelstretch_GL.png' width='24'> **[Crok_pixelstretch_GL](/GLSL/Distort/Crok_pixelstretch_GL/README.md)** : Creates a Pixelspread type stretch effect.

- <img src='/GLSL/Distort/JB_pixelDisplace_GL/JB_pixelDisplace_GL.png' width='24'> **[JB_pixelDisplace_GL](/GLSL/Distort/JB_pixelDisplace_GL/README.md)** : Image displace effect for Shadertoy.

- <img src='/GLSL/Distort/JB_timeDisplace_GL/JB_timeDisplace_GL.png' width='24'> **[JB_timeDisplace_GL](/GLSL/Distort/JB_timeDisplace_GL/README.md)** : Tries to emulate the Sapphire s_TimeDisplace node.

- <img src='/GLSL/Distort/JT_SyLens_GL/JT_SyLens_GL.png' width='24'> **[JT_SyLens_GL](/GLSL/Distort/JT_SyLens_GL/README.md)** : Straightens and distorts footage according to the Syntheyes lens distortion model.

- <img src='/GLSL/Distort/K_Chroma_GL/K_Chroma_GL.png' width='24'> **[K_Chroma_GL](/GLSL/Distort/K_Chroma_GL/README.md)** : GPU accelerated chroma abberation effect for Shadertoy.

- <img src='/GLSL/Distort/Ls_Advect_GL/Ls_Advect_GL.png' width='24'> **[Ls_Advect_GL](/GLSL/Distort/Ls_Advect_GL/README.md)** : Pushes an image along the contours of another.

- <img src='/GLSL/Distort/Ls_nail_GL/Ls_nail_GL.png' width='24'> **[Ls_nail_GL](/GLSL/Distort/Ls_nail_GL/README.md)** : Warp an area of the Source and Mask to follow a track.

- <img src='/GLSL/Distort/Ls_Posmatte_GL/Ls_Posmatte_GL.png' width='24'> **[Ls_Posmatte_GL](/GLSL/Distort/Ls_Posmatte_GL/README.md)** : Pulls a spherical matte from an XYZ position pass.

- <img src='/GLSL/Distort/Ls_Splineblur_GL/Ls_Splineblur_GL.png' width='24'> **[Ls_Splineblur_GL](/GLSL/Distort/Ls_Splineblur_GL/README.md)** : Directional blur along the edges of a shape.

- <img src='/GLSL/Distort/Ls_UVewa_GL/Ls_UVewa_GL.png' width='24'> **[Ls_UVewa_GL](/GLSL/Distort/Ls_UVewa_GL/README.md)** : UV mapping with EWA filtering.

### GLSL/Draw
- <img src='/GLSL/Draw/Crok_blue_noise_GL/Crok_blue_noise_GL.png' width='24'> **[Crok_blue_noise_GL](/GLSL/Draw/Crok_blue_noise_GL/README.md)** : Generates a blue noise texture from a still plate.

- <img src='/GLSL/Draw/Crok_fast_grain_GL/Crok_fast_grain_GL.png' width='24'> **[Crok_fast_grain_GL](/GLSL/Draw/Crok_fast_grain_GL/README.md)** : Simulates a film like grain.

- <img src='/GLSL/Draw/Crok_regrain_GL/Crok_regrain_GL.png' width='24'> **[Crok_regrain_GL](/GLSL/Draw/Crok_regrain_GL/README.md)** : Simulates film grain.

- <img src='/GLSL/Draw/Guides_GL/Guides_GL.png' width='24'> **[Guides_GL](/GLSL/Draw/Guides_GL/README.md)** : Draws simple adjustable horizontal and vertical guides for centering reference, measuring, etc...

### GLSL/Effect
- <img src='/GLSL/Effect/Anaglyphic_GL/Anaglyphic_GL.png' width='32'> **[Anaglyphic_GL](/GLSL/Effect/Anaglyphic_GL/README.md)** : GPU accelerated Anaglyphic effect for Shadertoy.

- <img src='/GLSL/Effect/Crok_6567_GL/Crok_6567_GL.png' width='32'> **[Crok_6567_GL](/GLSL/Effect/Crok_6567_GL/README.md)** : Simulates the color palette of a VIC-2 or better known as on of the famous C64 chips.

- <img src='/GLSL/Effect/Crok_ascii_art_GL/Crok_ascii_art_GL.png' width='32'> **[Crok_ascii_art_GL](/GLSL/Effect/Crok_ascii_art_GL/README.md)** : Generates ascii art.

- <img src='/GLSL/Effect/Crok_beer_GL/Crok_beer_GL.png' width='32'> **[Crok_beer_GL](/GLSL/Effect/Crok_beer_GL/README.md)** : Creates a beer like structure.

- <img src='/GLSL/Effect/Crok_bleachbypass_GL/Crok_bleachbypass_GL.png' width='32'> **[Crok_bleachbypass_GL](/GLSL/Effect/Crok_bleachbypass_GL/README.md)** : GPU accelerated bleachbypass effect for Shadertoy.

- <img src='/GLSL/Effect/Crok_cel_shading_GL/Crok_cel_shading_GL.png' width='32'> **[Crok_cel_shading_GL](/GLSL/Effect/Crok_cel_shading_GL/README.md)** : Simulates cel shading.

- <img src='/GLSL/Effect/Crok_cmyk_halftone_GL/Crok_cmyk_halftone_GL.png' width='32'> **[Crok_cmyk_halftone_GL](/GLSL/Effect/Crok_cmyk_halftone_GL/README.md)** : GPU accelerated CMYK halftone effect for Shadertoy.

- <img src='/GLSL/Effect/Crok_contour_GL/Crok_contour_GL.png' width='32'> **[Crok_contour_GL](/GLSL/Effect/Contour_GL/README.md)** : Creates a handdrawn style edge detect.

- <img src='/GLSL/Effect/Crok_crosshatch_GL/Crok_crosshatch_GL.png' width='32'> **[Crok_crosshatch_GL](/GLSL/Effect/Crok_crosshatch_GL/README.md)** : Simulates a simple pencil sketch.

- <img src='/GLSL/Effect/Crok_crt_GL/Crok_crt_GL.png' width='32'> **[Crok_crt_GL](/GLSL/Effect/Crt_GL/README.md)** : Creates a CRT style scan-line effect with additional shadowmasking.

- <img src='/GLSL/Effect/Crok_deband_GL/Crok_deband_GL.png' width='32'> **[Crok_deband_GL](/GLSL/Effect/Crok_deband_GL/README.md)** : Reduces banding.

- <img src='/GLSL/Effect/Crok_digital_glitch_GL/Crok_digital_glitch_GL.png' width='32'> **[Crok_digital_glitch_GL](/GLSL/Effect/Crok_digital_glitch_GL/README.md)** : Simulates digital glitches.

- <img src='/GLSL/Effect/Crok_dithering_GL/Crok_dithering_GL.png' width='32'> **[Crok_dithering_GL](/GLSL/Effect/Crok_dithering_GL/README.md)** : Creates a dithering effect.

- <img src='/GLSL/Effect/Crok_emboss_GL/Crok_emboss_GL.png' width='32'> **[Crok_emboss_GL](/GLSL/Effect/Crok_emboss_GL/README.md)** : Simulates an emboss effect.

- <img src='/GLSL/Effect/Crok_flicker_GL/Crok_flicker_GL.png' width='32'> **[Crok_flicker_GL](/GLSL/Effect/Crok_flicker_GL/README.md)** : Creates a flickering effect.

- <img src='/GLSL/Effect/Crok_hexagon_GL/Crok_hexagon_GL.png' width='32'> **[Crok_hexagon_GL](/GLSL/Effect/Crok_hexagon_GL/README.md)** : Generates hexagon patterns.

- <img src='/GLSL/Effect/Crok_highpass_GL/Crok_highpass_GL.png' width='32'> **[Crok_highpass_GL](/GLSL/Effect/Crok_highpass_GL/README.md)** : GPU accelerated highpass filter for Shadertoy.

- <img src='/GLSL/Effect/Crok_kuwahara_GL/Crok_kuwahara_GL.png' width='32'> **[Crok_kuwahara_GL](/GLSL/Effect/Crok_kuwahara_GL/README.md)** : Simulates anisotropic kuwahara filtering.

- <img src='/GLSL/Effect/Crok_lowfi_GL/Crok_lowfi_GL.png' width='32'> **[Crok_lowfi_GL](/GLSL/Effect/Crok_lowfi_GL/README.md)** : Simulates NES, EGA and Gameboy video out.

- <img src='/GLSL/Effect/Crok_nightvision_GL/Crok_nightvision_GL.png' width='32'> **[Crok_nightvision_GL](/GLSL/Effect/Croknight_vision_GL/README.md)** : Creates a nightvision effect.

- <img src='/GLSL/Effect/Crok_oil_paint_GL/Crok_oil_paint_GL.png' width='32'> **[Crok_oil_paint_GL](/GLSL/Effect/Crok_oil_paint_GL/README.md)** : Applies a painterly effet to the image.

- <img src='/GLSL/Effect/Crok_parallax_GL/Crok_parallax_GL.png' width='32'> **[Crok_parallax_GL](/GLSL/Effect/Crok_parallax_GL/README.md)** : Simulates a typical Amiga style parallax effect.

- <img src='/GLSL/Effect/Crok_pixelate_GL/Crok_pixelate_GL.png' width='32'> **[Crok_pixelate_GL](/GLSL/Effect/Crok_pixelate_GL/README.md)** : GPU accelerated mosaic effect for Shadertoy.

- <img src='/GLSL/Effect/Crok_scanlines_GL/Crok_scanlines_GL.png' width='32'> **[Crok_scanlines_GL](/GLSL/Effect/Crok_scanlines_GL/README.md)** : Simulates CRT phosphor / shadow mask arrangements.

- <img src='/GLSL/Effect/Crok_separation_GL/Crok_separation_GL.png' width='32'> **[Crok_separation_GL](/GLSL/Effect/Crok_separation_GL/README.md)** : Creates a low pass and high pass filter sometimes called frequency separation.

- <img src='/GLSL/Effect/Crok_tv_rgb_dots_GL/Crok_tv_rgb_dots_GL.png' width='32'> **[Crok_tv_rgb_dots_GL](/GLSL/Effect/Crok_tv_rgb_dots_GL/README.md)** : Simulates the typical RGB dots of old TVs.

- <img src='/GLSL/Effect/Crok_vein_GL/Crok_vein_GL.png' width='32'> **[Crok_vein_GL](/GLSL/Effect/Crok_vein_GL/README.md)** : Generates veins.

- <img src='/GLSL/Effect/Crok_vhs_GL/Crok_vhs_GL.png' width='32'> **[Crok_vhs_GL](/GLSL/Effect/Crok_vhs_GL/README.md)** : Simulates an old VHS player.

- <img src='/GLSL/Effect/EWA_GL/EWA_GL.png' width='32'> **[EWA_GL](/GLSL/Effect/EWA_GL/README.md)** : GPU accelerated EWA antialiasing effect for Shadertoy.

- <img src='/GLSL/Effect/FXAA_GL/FXAA_GL.png' width='32'> **[FXAA_GL](/GLSL/Effect/FXAA_GL/README.md)** : GPU accelerated FXAA antialiasing effect for Shadertoy.

- <img src='/GLSL/Effect/JB_lidar_GL/JB_lidar_GL.png' width='32'> **[JB_lidar_GL](/GLSL/Effect/JB_lidar_GL/README.md)** : This node tries to emulate a fake point cloud data provided by a lidar.

- <img src='/GLSL/Effect/Ls_Dollface_GL/Ls_Dollface_GL.png' width='32'> **[Ls_Dollface_GL](/GLSL/Effect/Ls_Dollface_GL/README.md)** : Blend similar colours with a bilateral filter whilst preserving edges, to remove grain or wrinkles.

- <img src='/GLSL/Effect/Ls_FXAA_GL/Ls_FXAA_GL.png' width='32'> **[Ls_FXAA_GL](/GLSL/Effect/Ls_FXAA_GL/README.md)** : Fast cheap antialiasing.

- <img src='/GLSL/Effect/Ls_wireless_GL/Ls_wireless_GL.png' width='32'> **[Ls_wireless_GL](/GLSL/Effect/Ls_wireless_GL/README.md)** : Fast cheap antialiasing.

- <img src='/GLSL/Effect/Money_Filter_GL/Money_Filter_GL.png' width='32'> **[Money_Filter_GL](/GLSL/Effect/Money_Filter_GL/README.md)** : GPU accelerated Money filter effect for Shadertoy.

### GLSL/Keying
- <img src='/GLSL/Keying/AFX_Despill_GL/AFX_Despill_GL.png' width='32'> **[AFX_Despill_GL](/GLSL/Keying/AFX_Despill_GL/README.md)** : GPU accelerated After Effects despill for Shadertoy.

- <img src='/GLSL/Keying/Crok_chromakey_GL/Crok_chromakey_GL.png' width='32'> **[Crok_chromakey_GL](/GLSL/Keying/Crok_chromakey_GL/README.md)** : This shader does a fast chroma key.

- <img src='/GLSL/Keying/Crok_despill_GL/Crok_despill_GL.png' width='32'> **[Crok_despill_GL](/GLSL/Keying/Crok_despill_GL/README.md)** : Combines multiple LogicOps to streamline your keying node graph.

- <img src='/GLSL/Keying/Crok_difference_GL/Crok_difference_GL.png' width='32'> **[Crok_difference_GL](/GLSL/Keying/Crok_difference_GL/README.md)** : Creates a diference matte.

- <img src='/GLSL/Keying/Crok_edge_matte_GL/Crok_edge_matte_GL.png' width='32'> **[Crok_edge_matte_GL](/GLSL/Keying/Crok_edge_matte_GL/README.md)** : GPU accelerated edge detect effect for Shadertoy.

- <img src='/GLSL/Keying/Cryptomatte_GL/Cryptomatte_GL.png' width='24'> **[Cryptomatte_GL](/GLSL/Keying/Cryptomatte_GL/README.md)** : Extract up to four mattes from the ID/coverage pairs generated by Arnold/Clarisse/Mantra's Cryptomatte shaders.

- <img src='/GLSL/Keying/JB_autoMatte_GL/JB_autoMatte_GL.png' width='32'> **[JB_autoMatte_GL](/GLSL/Keying/JB_autoMatte_GL/README.md)** : Creates a RGB multimattes of an input which can be useful to mockup quick keys.

- <img src='/GLSL/Keying/JB_erodematte_GL/JB_erodematte_GL.png' width='32'> **[JB_erodematte_GL](/GLSL/Keying/JB_erodematte_GL/README.md)** : Simple erode node.

### GLSL/Merge
- <img src='/GLSL/Merge/Add_GL/Add_GL.png' width='32'> **[Add_GL](/GLSL/Merge/Add_GL/README.md)** : GPU accelerated additive merge for Shadertoy.

- <img src='/GLSL/Merge/Crok_uncomp_GL/Crok_uncomp_GL.png' width='32'> **[Crok_uncomp_GL](/GLSL/Merge/Crok_uncomp_GL/README.md)** : Uncompose a compositing scene into its original layer.

- <img src='/GLSL/Merge/Ls_Contacts_GL/Ls_Contacts_GL.png' width='32'> **[Ls_Contacts_GL](/GLSL/Merge/Ls_Contacts_GL/README.md)** : Tile inputs into a grid for impressing clients, choosing versions or checking continuity.

- <img src='/GLSL/Merge/Merge_GL/Merge_GL.png' width='32'> **[Merge_GL](/GLSL/Merge/Merge_GL/README.md)** : GPU accelerated merge node for Shadertoy.

- <img src='/GLSL/Merge/Screen_GL/Screen_GL.png' width='32'> **[Screen_GL](/GLSL/Merge/Screen_GL/README.md)** : GPU accelerated screen merge for Shadertoy.

### GLSL/Source
- <img src='/GLSL/Source/Bleepy_Blocks_GL/Bleepy_Blocks_GL.png' width='24'> **[Bleepy_Blocks_GL](/GLSL/Source/Bleepy_Blocks_GL/README.md)** : GPU accelerated bleepy blocks generator for Shadertoy.

- <img src='/GLSL/Source/Bubbles_GL/Bubbles_GL.png' width='24'> **[Bubbles_GL](/GLSL/Source/Bubbles_GL/README.md)** : GPU accelerated bubbles generator for Shadertoy.

- <img src='/GLSL/Source/Cellular_GL/Cellular_GL.png' width='24'> **[Cellular_GL](/GLSL/Source/Cellular_GL/README.md)** : GPU accelerated cell generator for Shadertoy.

- <img src='/GLSL/Source/cr2_HEX_GL/cr2_HEX_GL.png' width='24'> **[cr2_HEX_GL](/GLSL/Source/cr2_HEX_GL/README.md)** : Creates a Hexagon Pattern.

- <img src='/GLSL/Source/Crok_3d_grid_GL/Crok_3d_grid_GL.png' width='24'> **[Crok_3d_grid_GL](/GLSL/Source/Crok_3d_grid_GL/README.md)** : Creates a 3D Grid.

- <img src='/GLSL/Source/Crok_blobs_GL/Crok_blobs_GL.png' width='24'> **[Crok_blobs_GL](/GLSL/Source/Crok_blobs_GL/README.md)** : Creates blob like sturctures.

- <img src='/GLSL/Source/Crok_box_GL/Crok_box_GL.png' width='32'> **[Crok_box_GL](/GLSL/Source/Crok_box_GL/README.md)** : Creates an antialiased square with rounded corners.

- <img src='/GLSL/Source/Crok_block_noise_GL/Crok_block_noise_GL.png' width='32'> **[Crok_block_noise_GL](/GLSL/Source/Crok_block_noise_GL/README.md)** : Creates blocky textures.

- <img src='/GLSL/Source/Crok_cameraflash_GL/Crok_cameraflash_GL.png' width='32'> **[Crok_cameraflash_GL](/GLSL/Source/Crok_cameraflash_GL/README.md)** : Creates simple camera flashs.

- <img src='/GLSL/Source/Crok_cells_GL/Crok_cells_GL.png' width='32'> **[Crok_cells_GL](/GLSL/Source/Crok_cells_GL/README.md)** : Creates a cell pattern.

- <img src='/GLSL/Source/Crok_cellular_GL/Crok_cellular_GL.png' width='32'> **[Crok_cellular_GL](/GLSL/Source/Crok_cellular_GL/README.md)** : Creates tons of cellular like looking patterns.

- <img src='/GLSL/Source/Crok_checkerboard_GL/Crok_checkerboard_GL.png' width='32'> **[Crok_checkerboard_GL](/GLSL/Source/Crok_checkerboard_GL/README.md)** : Creates a checkerboard pattern.

- <img src='/GLSL/Source/Crok_fbmPixels_GL/Crok_fbmPixels_GL.png' width='32'> **[Crok_fbmPixels_GL](/GLSL/Source/Crok_fbmPixels_GL/README.md)** : Creates a fbm style pattern.

- <img src='/GLSL/Source/Crok_flow_GL/Crok_flow_GL.png' width='32'> **[Crok_flow_GL](/GLSL/Source/Crok_flow_GL/README.md)** : Creates a perlin noise pattern.

- <img src='/GLSL/Source/Crok_fractal_GL/Crok_fractal_GL.png' width='32'> **[Crok_fractal_GL](/GLSL/Source/Crok_fractal_GL/README.md)** : Creates a fractal pattern.

- <img src='/GLSL/Source/Crok_fractal_soup_GL/Crok_fractal_soup_GL.png' width='32'> **[Crok_fractal_soup_GL](/GLSL/Source/Crok_fractal_soup_GL/README.md)** : Creates a mandelbrot pattern.

- <img src='/GLSL/Source/Crok_gradient_GL/Crok_gradient_GL.png' width='32'> **[Crok_gradient_GL](/GLSL/Source/Crok_gradient_GL/README.md)** : Creates a simple gradient effect.

- <img src='/GLSL/Source/Crok_lava_GL/Crok_lava_GL.png' width='32'> **[Crok_lava_GL](/GLSL/Source/Crok_lava_GL/README.md)** : Creates flame / fluid like patterns.

- <img src='/GLSL/Source/Crok_lines_GL/Crok_lines_GL.png' width='32'> **[Crok_lines_GL](/GLSL/Source/Crok_lines_GL/README.md)** : Creates lines.

- <img src='/GLSL/Source/Crok_maze_GL/Crok_maze_GL.png' width='32'> **[Crok_maze_GL](/GLSL/Source/Crok_maze_GL/README.md)** : Creates a maze like structure.

- <img src='/GLSL/Source/Crok_ocean_noise_GL/Crok_ocean_noise_GL.png' width='32'> **[Crok_ocean_noise_GL](/GLSL/Source/Crok_ocean_noise_GL/README.md)** : Creates an ocean / water like noise pattern.

- <img src='/GLSL/Source/Crok_patterns_GL/Crok_patterns_GL.png' width='32'> **[Crok_patterns_GL](/GLSL/Source/Crok_patterns_GL/README.md)** : Creates different patterns.

- <img src='/GLSL/Source/Crok_perlin_GL/Crok_perlin_GL.png' width='32'> **[Crok_perlin_GL](/GLSL/Source/Crok_perlin_GL/README.md)** : Creates a perlin noise like pattern.

- <img src='/GLSL/Source/Crok_plasnoid_GL/Crok_plasnoid_GL.png' width='32'> **[Crok_plasnoid_GL](/GLSL/Source/Crok_plasnoid_GL/README.md)** : Creates tons of different plasma patterns.

- <img src='/GLSL/Source/Crok_puffy_noise_GL/Crok_puffy_noise_GL.png' width='32'> **[Crok_puffy_noise_GL](/GLSL/Source/Crok_puffy_noise_GL/README.md)** : Simulates puffy noise.

- <img src='/GLSL/Source/Crok_snow_GL/Crok_snow_GL.png' width='32'> **[Crok_snow_GL](/GLSL/Source/Crok_snow_GL/README.md)** : Creates snow.

- <img src='/GLSL/Source/Crok_stars_GL/Crok_stars_GL.png' width='32'> **[Crok_stars_GL](/GLSL/Source/Crok_stars_GL/README.md)** : Simulates stars.

- <img src='/GLSL/Source/Crok_tesla_GL/Crok_tesla_GL.png' width='24'> **[Crok_tesla_GL](/GLSL/Source/Crok_tesla_GL/README.md)** : Creates tesla lightning bolts.

- <img src='/GLSL/Source/Crok_turbulence_GL/Crok_turbulence_GL.png' width='32'> **[Crok_turbulence_GL](/GLSL/Source/Crok_turbulence_GL/README.md)** : Creates a water turbulence texture.

- <img src='/GLSL/Source/Crok_voronoi_GL/Crok_voronoi_GL.png' width='32'> **[Crok_voronoi_GL](/GLSL/Source/Crok_voronoi_GL/README.md)** : Creates voronoi noises.

- <img src='/GLSL/Source/Crok_wave_lines_GL/Crok_wave_lines_GL.png' width='32'> **[Crok_wave_lines_GL](/GLSL/Source/Crok_wave_lines_GL/README.md)** : Creates a wave line pattern.

- <img src='/GLSL/Source/Crok_wrinkle_GL/Crok_wrinkle_GL.png' width='32'> **[Crok_wrinkle_lines_GL](/GLSL/Source/Crok_wrinkle_GL/README.md)** : Creates wrinkled paper like sturctures.

- <img src='/GLSL/Source/JB_fractal_GL/JB_fractal_GL.png' width='32'> **[JB_fractal_GL](/GLSL/Source/JB_fractal_GL/README.md)** : Simple fractal generator.

- <img src='/GLSL/Source/L_Molten_GL/L_Molten_GL.png' width='32'> **[L_Molten_GL](/GLSL/Source/L_Molten_GL/README.md)** : Molten Metal Texture Gradient shader.

- <img src='/GLSL/Source/Magma_GL/Magma_GL.png' width='32'> **[Magma_GL](/GLSL/Source/Magma_GL/README.md)** : Generates a magma style effect.

- <img src='/GLSL/Source/Noise_GL/Noise_GL.png' width='32'> **[Noise_GL](/GLSL/Source/Noise_GL/README.md)** : GPU accelerated noise generator for Shadertoy.

### GLSL/Transform
- <img src='/GLSL/Transform/Crok_seamless_GL/Crok_seamless_GL.png' width='24'> **[Crok_seamless_GL](/GLSL/Transform/Crok_seamless_GL/README.md)** : Creates seamless textures.

- <img src='/GLSL/Transform/Crop_GL/Crop_GL.png' width='24'> **[Crop_GL](/GLSL/Transform/Crop_GL/README.md)** : A simple image cropper with built-in 2D texture offset and borders.

### Keyer
- <img src='/Keyer/AdditiveKeyer/AdditiveKeyer.png' width='32'> **[AdditiveKeyer](/Keyer/AdditiveKeyer/README.md)** : This is not a keyer, It is very good for separating translucent fine details (such as motion blur, dust or hair) that a keyers with mattes might have difficulties extracting.

- <img src='/Keyer/BS_AlphaGrainEdge/BS_AlphaGrainEdge.png' width='32'> **[BS_AlphaGrainEdge](/Keyer/BS_AlphaGrainEdge/README.md)** : This basic PyPlug simply adds some noise to your alphas around the areas that aren't solid.

- <img src='/Keyer/CoveragePass/CoveragePass.png' width='32'> **[CoveragePass](/Keyer/CoveragePass/README.md)** : Extract Coverage Pass from render in Arnold and Renderman.

- <img src='/Keyer/EdgeMatteDetect/EdgeMatteDetect.png' width='32'> **[EdgeMatteDetect](/Keyer/EdgeMatteDetect/README.md)** : Description to be written

- <img src='/Keyer/IDKeyer/IDKeyer.png' width='32'> **[IDKeyer](/Keyer/IDKeyer/README.md)** : Extract an alpha matte from a ID-Pass to be used as a mask.

- <img src='/Keyer/lp_ChannelContactsheet/lp_ChannelContactsheet.png' width='32'> **[lp_ChannelContactsheet](/Keyer/lp_ChannelContactsheet/README.md)** : Generate a Contactsheet to find a suitable channel for keying.

- <img src='/Keyer/lp_ChillSpill/lp_ChillSpill.png' width='32'> **[lp_ChillSpill](/Keyer/lp_ChillSpill/README.md)** : An alternative to buit-in Despill node that is quick and easy to setup.

- <img src='/Keyer/lp_CleanScreen/lp_CleanScreen.png' width='32'> **[lp_CleanScreen](/Keyer/lp_CleanScreen/README.md)** : Evens out your Chroma-Screen with the help of a Cleanplate.

- <img src='/Keyer/lp_HairKey/lp_HairKey.png' width='32'> **[lp_HairKey](/Keyer/lp_HairKey/README.md)** : A keyless Keyer for fine detail like hair which is hard to come by with a matte.

- <img src='/Keyer/lp_SimpleKeyer/lp_SimpleKeyer.png' width='32'> **[lp_SimpleKeyer](/Keyer/lp_SimpleKeyer/README.md)** : A very simple Keyer for a wide variety of operations. Inspired by Nukes Keyer-Node.

- <img src='/Keyer/OverRange_Alpha/OverRange_Alpha.png' width='32'> **[OverRange_Alpha](/Keyer/OverRange_Alpha/README.md)** : Generates an alpha channel based on overranged values.

- <img src='/Keyer/PositionMask/PositionMask.png' width='32'> **[PositionMask](/Keyer/PositionMask/README.md)** : Take a world position pass and generate a rounded mask from it.

- <img src='/Keyer/PushPixel/PushPixel.png' width='32'> **[PushPixel](/Keyer/PushPixel/README.md)** : Pushes pixels of the RGB on the edges of the alpha channel.

### Lens Flare Presets
- <img src='/Lens_Flare_Presets/flareicon.png' width='32'> **[Lens Flare Presets](/Lens_Flare_Presets)** : Various Lens Flare presets to use and make new presets.

### Merge
- <img src='/Merge/Linear%20wipe/linearWipe_icon.png' width='32'> **[Linear Wipe](/Merge/Linear%20wipe/README.md)** : Perform Linear wipe.

- <img src='/Merge/Radial%20Wipe/radialWipe_icon.png' width='32'> **[Radial Wipe](/Merge/Radial%20Wipe/README.md)** : Perform Radial wipe.

- <img src='/Merge/L_Fuse/L_Fuse.png' width='24'> **[L_Fuse](/Merge/L_Fuse/README.md)** : Fuse is a replacement for the merge(over) node.

- <img src='/Merge/ZCombine/ZCombine.png' width='32'> **[ZCombine](/Merge/ZCombine/README.md)** : Mix two images according to their Zbuffer.

### mS
- <img src='/mS/mS_MarkerRemoval_Advanced/mS_MarkerRemoval_Advanced.png' width='32'> **[mS_MarkerRemoval_Advanced](/mS/mS_MarkerRemoval_Advanced/README.md)** : This PyPlug lets you easily remove tracking markers from backing screens without the hassle of painting, even when they intersect with the foreground elements.

- <img src='/mS/mS_RestoreGrain/mS_RestoreGrain.png' width='32'> **[mS_RestoreGrain](/mS/mS_RestoreGrain/README.md)** : This PyPlug lets you preserve the original grain from your plate after keying.

### Relight
- <img src='/Relight/Vector_Tools/Luma_to_Normals/Luma_to_Normals.png' width='32'> **[Luma_to_Normals](/Relight/Vector_Tools/Luma_to_Normals/README.md)** : Converts any image to normals, using it's Luma Channel. Provides most accurate results used on displacement maps or Zdepth passes.

- <img src='/Relight/ReFlect/ReFlect.png' width='32'> **[ReFlect](/Relight/ReFlect/README.md)** : Take a Normal pass and an image and map it to reflection, similar to matcap in 3D render.

- <img src='/Relight/ReShade/ReShade.png' width='32'> **[ReShade](/Relight/ReShade/README.md)** : GPU Relighting of 3D renders using a normal pass.

- <img src='/Relight/SSAO/SSAO.png' width='32'> **[SSAO](/Relight/SSAO/README.md)** : Generate an AO pass from a Z pass.

- <img src='/Relight/Vector_Tools/UV_Map_Generator/UV_Map_Generator.png' width='32'> **[UV_Map_Generator](/Relight/Vector_Tools/UV_Map_Generator/README.md)** : Generates a default UV map at any resolution. Can be used to run through a lens distortion in another software or any sort of distorion that can then be re-applied with an STMap node.

- <img src='/Relight/Vector_Tools/UV_to_Vectors/UV_to_Vectors.png' width='32'> **[UV_to_Vectors](/Relight/Vector_Tools/UV_to_Vectors/README.md)** : Converts a distorted UV map to motion vectors.

- <img src='/Relight/Vector_Tools/Vectors_Direction/Vectors_Direction.png' width='32'> **[Vectors_Direction](/Relight/Vector_Tools/Vectors_Direction/README.md)** : An utility to rotate 2D vectors such as motion vectors, and flip them if necessary.

- <img src='/Relight/Vector_Tools/Vectors_Magnitude/Vectors_Magnitude.png' width='32'> **[Vectors_Magnitude](/Relight/Vector_Tools/Vectors_Magnitude/README.md)** : An utility to see the magnitude of motion vectors, usually simply as information for the artist.

- <img src='/Relight/Vector_Tools/Vectors_Normalize/Vectors_Normalize.png' width='32'> **[Vectors_Normalize](/Relight/Vector_Tools/Vectors_Normalize/README.md)** : Will scale every vector in a vector pass so that each vctor's magnitude is 1, while keeping the direction. Works on 2D and 3D vectors.

- <img src='/Relight/Vector_Tools/Vectors_to_UV/Vectors_to_UV.png' width='32'> **[Vectors_to_UV](/Relight/Vector_Tools/Vectors_to_UV/README.md)** : Converts Motion Vectors to an UV map.

- <img src='/Relight/Z2Normal/Z2Normal.png' width='32'> **[Z2Normal](/Relight/Z2Normal/README.md)** : Generate a Normal Pass from a Z pass

### SB
- <img src='/SB/sb_AlphaFromMax/sb_AlphaFromMax.png' width='24'> **[sb_AlphaFromMax](/SB/sb_AlphaFromMax/README.md)** : This PyPlug creates an alpha channel based on the max color value of each pixel in any of the RGB channels.

- <img src='/SB/sb_Erode/sb_Erode.png' width='24'> **[sb_Erode](/SB/sb_Erode/README.md)** : This PyPlug wraps several erode types into a single gizmo, giving you simple control of which method that works best for your shot.

- <img src='/SB/sb_LumaKey/sb_LumaKey.png' width='24'> **[sb_LumaKey](/SB/sb_LumaKey/README.md)** : This PyPlug will perform a luminance key of your footage, based on a chosen color space.

- <img src='/SB/sb_MatteEdge/sb_MatteEdge.png' width='24'> **[sb_MatteEdge](/SB/sb_MatteEdge/README.md)** : This PyPlug creates an edge matte with control of both the outer and inner radius.

### Time
- <img src='/Time/TimeLoop/TimeLoop.png' width='32'> **[TimeLoop](/Time/TimeLoop/README.md)** : generate loops from input image

### Transform
- <img src='/Transform/PM_Camera/PM_Camera.png' width='32'> **[PM_Camera](/Transform/PM_Camera/README.md)** : Poor's Man 3D Camera, can import .chan data to be used with the PM_Card3D

- <img src='/Transform/Crop_N/Crop_N.png' width='32'> **[Crop_N](/Transform/Crop_N/README.md)** : Crop node similar to Nuke's one

- <img src='/Transform/3D_Card/PM_Card3D.png' width='32'> **[PM_Card3D](/Transform/3D_Card/README.md)** : Poor's Man Card3D, create a 3D plane, to be used with PM_Camera

- <img src='/Transform/Repeat/Repeat.png' width='32'> **[Repeat](/Transform/Repeat/README.md)** : Tiling effect that extends image size.

- <img src='/Transform/Shaker/Shaker.png' width='32'> **[Shaker](/Transform/Shaker/README.md)** : Adds a shaking effect to the input image. It's based on an expression similar to wiggle expression in After Effects

- <img src='/Transform/lp_NoiseDistort/lp_NoiseDistort.png' width='32'> **[lp_NoiseDistort](/Transform/lp_NoiseDistort/README.md)** : Distorts an image based on two different noise-layer for a more dynamic feel.

### Utility
- <img src='/Utility/Onion_S/Onion_S.png' width='32'> **[Onion_S](/Utility/Onion_S/README.md)** : This is a simple Onion Skin utility node. It supports 5 fames of fixed interval onion skin in the forward and backward directions with user selectable colors, and two blending modes.

- <img src='/Utility/WaveForm/WaveForm.png' width='32'> **[WaveForm](/Utility/WaveForm/README.md)** : Draw a Luminance Waveform of the input image

### Views
- <img src='/Views/L_AspectMask/L_AspectMask.png' width='32'> **[L_AspectMask](/Views/L_AspectMask/README.md)** : Apply standard formats overlay over an image.

## How to Contribute to this repository ?
We'd love to add your own Pyplugs to this repository so everyone can benefit from them.

You can make a Pull Request or if you're not comfortable with git just tell us here :

https://discuss.pixls.us/t/all-about-natron-community-plugins/8433


Also you can look at our guidelines for Pyplug submission :

https://github.com/NatronGitHub/natron-plugins/wiki/Guidelines-for-plugins


![Image](Resources/community-plugins-logo.png)
