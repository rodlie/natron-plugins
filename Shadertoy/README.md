# Shadertoy GLSL presets :

### Replace the original Shadertoy.txt file with the one present in this folder.

## AFX :

- <img src='icons/AFX_DeSpill.frag.png' width='50'> **[AFX_DeSpill]** : Based on the Despill algo if green is greater than the average of the red and blue channels, then bring green down to that color... also works with blue and redscreen, this algo is excellent for maintaining skintones...

- <img src='icons/AFX_Grade.frag.png' width='50'> **[AFX_Grade]** : This is based off the Nuke grade node, so people who are used to the math of this node will be right at home, this node can create negative values, but that's the point, so you will want to clamp if outputing for broadcast...

- <img src='icons/AFX_ReverseGrade.frag.png' width='50'> **[AFX_ReverseGrade]** : This node is the reverse grade function found inside the Nuke Grade node. Set your black and white points from your source material (look at front view), then look at the target footage (either via the back or just a context view) and pull the blacks and whites off that plate, then look at result view and tada! they should be a pretty close match...

## CPGP :

- <img src='icons/CPGP_FractalCell.frag.png' width='50'> **[CPGP_FractalCell]** : Generates a fractal cell texture

## Crok :

- <img src='icons/Crok_2color.frag.png' width='50'> **[Crok_2color]** : Simulates a 2 color look.

- <img src='icons/Crok_bleachbypas.frag.png' width='50'> **[Crok_bleachbypas]** : Simulates a bleachbypass process.

- <img src='icons/Crok_bw.frag.png' width='50'> **[Crok_bw]** : Creates black and white images with adjustable RGB values.

- <img src='icons/Crok_cel_shading.frag.png' width='50'> **[Crok_cel_shading]** : Simulates Cel shading.

- <img src='icons/Crok_cmyk_halftone.frag.png' width='50'> **[Crok_cmyk_halftone]** : Simulates CMYK Halftone patterns.

- <img src='icons/Crok_convolve.frag.png' width='50'> **[Crok_convolve]** : Simulates a Convolve Blur.

- <img src='icons/Crok_dir_blur.frag.png' width='50'> **[Crok_dir_blur]** : Creates a directional blur.

- <img src='icons/Crok_edge_matte.frag.png' width='50'> **[Crok_edge_matte]** : Creates a simple edge matte.

- <img src='icons/Crok_exposure.frag.png' width='50'> **[Crok_exposure]** : Simulates an exposure node, which isn't THAT precise ;) For creative use only !

- <img src='icons/Crok_highpass.frag.png' width='50'> **[Crok_highpass]** : Simulates a HighPass filter effect.

## K :

- <img src='icons/K_BW.frag.png' width='50'> **[K_BW]** : Creates a black and white image based on the dominance of R-G-B channels.

- <img src='icons/K_Chroma.frag.png' width='50'> **[K_Chroma]** : Warps chroma channels with the ability to add barrel distortion.

- <img src='icons/K_RgbcmyMatte.frag.png' width='50'> **[K_RgbcmyMatte]** : Separates Red, Green, Blue, Cyan, Magenta, Yellow and White from a matte pass.

## Other :

- <img src='icons/Add_GL.frag.png' width='50'> **[Add_GL]** : Additive merge.

- <img src='icons/Divide_GL.frag.png' width='50'> **[Divide_GL]** : Divide merge.

- <img src='icons/Multiply_GL.frag.png' width='50'> **[Multiply_GL]** : Multiply merge.

- <img src='icons/Screen_GL.frag.png' width='50'> **[Screen_GL]** : Screen merge.