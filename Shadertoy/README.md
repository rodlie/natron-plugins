# Shadertoy GLSL presets :

### Replace the original Shadertoy.txt file with the one present in this folder.

## AFX :

- <img src='icons/AFX_DeSpill.png' width='66'> **[AFX_DeSpill]** : Based on the Despill algo if green is greater than the average of the red and blue channels, then bring green down to that color... also works with blue and redscreen, this algo is excellent for maintaining skintones...

- <img src='icons/AFX_Grade.png' width='66'> **[AFX_Grade]** : This is based off the Nuke grade node, so people who are used to the math of this node will be right at home, this node can create negative values, but that's the point, so you will want to clamp if outputing for broadcast...

- <img src='icons/AFX_ReverseGrade.png' width='66'> **[AFX_ReverseGrade]** : This node is the reverse grade function found inside the Nuke Grade node. Set your black and white points from your source material (look at front view), then look at the target footage (either via the back or just a context view) and pull the blacks and whites off that plate, then look at result view and tada! they should be a pretty close match...

## CPGP :

- <img src='icons/CPGP_FractalCell.png' width='66'> **[CPGP_FractalCell]** : Generates a fractal cell texture

## Crok :

- <img src='icons/Crok_2color.png' width='66'> **[Crok_2color]** : Simulates a 2 color look.

- <img src='icons/Crok_bleachbypas.png' width='66'> **[Crok_bleachbypas]** : Simulates a bleachbypass process.

- <img src='icons/Crok_bloom.png' width='66'> **[Crok_bloom]** : Simulates blooming.

- <img src='icons/Crok_bw.png' width='66'> **[Crok_bw]** : Creates black and white images with adjustable RGB values.

- <img src='icons/Crok_cel_shading.png' width='66'> **[Crok_cel_shading]** : Simulates Cel shading.

- <img src='icons/Crok_cmyk_halftone.png' width='66'> **[Crok_cmyk_halftone]** : Simulates CMYK Halftone patterns.

- <img src='icons/Crok_convolve.png' width='66'> **[Crok_convolve]** : Simulates a Convolve Blur.

- <img src='icons/Crok_crosshatch.png' width='66'> **[Crok_crosshatch]** : Simulates a simple pencil sketch.

- <img src='icons/Crok_deband.png' width='66'> **[Crok_deband]** : Reduces banding.

- <img src='icons/Crok_diffuse.png' width='66'> **[Crok_diffuse]** : Creates a noisy blur.

- <img src='icons/Crok_dir_blur.png' width='66'> **[Crok_dir_blur]** : Creates a directional blur.

- <img src='icons/Crok_edge_matte.png' width='66'> **[Crok_edge_matte]** : Creates a simple edge matte.

- <img src='icons/Crok_exposure.png' width='66'> **[Crok_exposure]** : Simulates an exposure node, which isn't THAT precise ;) For creative use only !

- <img src='icons/Crok_fbm-pixels.png' width='66'> **[Crok_fbm-pixels]** : Creates a fbm style pattern.

- <img src='icons/Crok_flow.png' width='66'> **[Crok_flow]** :  Creates a perlin noise pattern.

- <img src='icons/Crok_highpass.png' width='66'> **[Crok_highpass]** : Simulates a HighPass filter effect.

- <img src='icons/Crok_kuwahara.png' width='66'> **[Crok_kuwahara]** : Simulates anisotropic kuwahara filtering.

- <img src='icons/Crok_pixelate.png' width='66'> **[Crok_pixelate]** : Pixelates the image.

- <img src='icons/Crok_plasnoid.png' width='66'> **[Crok_plasnoid]** : Creates tons of different plasma patterns.

- <img src='icons/Crok_voronoi.png' width='66'> **[Crok_voronoi]** : Creates voronoi noises.

## JB :

- <img src='icons/JB_colorRemap.png' width='66'> **[JB_colorRemap]** : Remaps RGB of input 1 using RGB of input 2. option to inverse the result as well.

- <img src='icons/JB_erodeMatte.png' width='66'> **[JB_erodeMatte]** : Simple erode node.

- <img src='icons/JB_fractal.png' width='66'> **[JB_fractal]** : Simple fractal generator.

- <img src='icons/JB_multiMatteManager.png' width='66'> **[JB_multiMatteManager]** : Combines up to four RGB multimatte inputs into one with combined alphas of selected channels.

## K :

- <img src='icons/K_BW.png' width='66'> **[K_BW]** : Creates a black and white image based on the dominance of R-G-B channels.

- <img src='icons/K_Chroma.png' width='66'> **[K_Chroma]** : Warps chroma channels with the ability to add barrel distortion.

- <img src='icons/K_RgbcmyMatte.png' width='66'> **[K_RgbcmyMatte]** : Separates Red, Green, Blue, Cyan, Magenta, Yellow and White from a matte pass.

## L :

- <img src='icons/L_AlexaLogCv3.png' width='66'> **[L_AlexaLogCv3]** : Linearise the AlexalogCv3 encoded input or go back out as the inverse using the Arri AlexaLogCv3 function for EI800.

- <img src='icons/L_CanonLog.png' width='66'> **[L_CanonLog]** : Linearises the Canon Clog curve.

- <img src='icons/L_Clamp.png' width='66'> **[L_Clamp]** : Clamp selected pixels to user defined minimum and maximum values.

- <img src='icons/L_Fstop.png' width='66'> **[L_Fstop]** : Adjust the linear encoded front input exposure in Stops.

- <img src='icons/L_Mult.png' width='66'> **[L_Mult]** : Multiplies the pixel values in the image.

- <img src='icons/L_Slog.png' width='66'> **[L_Sloge]** : Linearise the SLog encoded input using the Sony S-Log function.

## Ls :

- <img src='icons/Ls_NaNfix.png' width='66'> **[Ls_NaNfix]** : Fixes pixels which are stuck at NaN, like those from broken CG renders. The detected pixels are output in the matte for further treatment with PixelSpread.

- <img src='icons/Ls_Posmatte.png' width='66'> **[Ls_Posmatte]** : Pulls a spherical matte from an XYZ position pass.

- <img src='icons/Ls_RndmGrade.png' width='66'> **[Ls_RndmGrade]** : Generates random grades. Works best on log footage or low-contrast ungraded video.

- <img src='icons/Ls_Tinyplanet.png' width='66'> **[Ls_Tinyplanet]** : Stereographic reprojection of 360 panoramas.

- <img src='icons/Ls_UVewa.png' width='66'> **[Ls_UVewa]** : UV mapping with EWA filtering.

## Other :

- <img src='icons/Add_GL.png' width='66'> **[Add_GL]** : Additive merge.

- <img src='icons/Divide_GL.png' width='66'> **[Divide_GL]** : Divide merge.

- <img src='icons/Multiply_GL.png' width='66'> **[Multiply_GL]** : Multiply merge.

- <img src='icons/Screen_GL.png' width='66'> **[Screen_GL]** : Screen merge.