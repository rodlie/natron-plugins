//
//
//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM
//                        MM.                          .MM
//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM
//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM
//                     MM.  .MMMM        MMMMMMM    MMM.  .MM
//                    MM.  .MMM           MMMMMM     MMM.  .MM
//                   MM.  .MmM              MMMM      MMM.  .MM
//                  MM.  .MMM                 MM       MMM.  .MM
//                 MM.  .MMM                   M        MMM.  .MM
//                MM.  .MMM                              MMM.  .MM
//                 MM.  .MMM                            MMM.  .MM
//                  MM.  .MMM       M                  MMM.  .MM
//                   MM.  .MMM      MM                MMM.  .MM
//                    MM.  .MMM     MMM              MMM.  .MM
//                     MM.  .MMM    MMMM            MMM.  .MM
//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM
//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM
//                        MM.                          .MM
//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM
//
//
//
//
// Adaptation pour Natron par F. Fernandez
// Code original : crok_blue_noise Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_blue_noise Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=repeat
// iChannel1: pass1_result,filter=linear,wrap=clamp
// BBox: iChannel0


// based on www.shadertoy.com/view/4sKBWR by demofox
/*
This shadertoy was adapted from paniq's at https://www.shadertoy.com/view/MsGfDz
He is on twitter at: https://twitter.com/paniq
Paniq is truly a king among men.

He totally didn't demand i put that here when i credited him, I promise (;

Items of note!

* The blue noise texture sampling should be set to "nearest" (not mip map!) and repeat

* you should calculate the uv to use based on the pixel coordinate and the size of the blue noise texture.
 * aka you should tile the blue noise texture across the screen.
 * blue noise actually tiles really well unlike white noise.

* A blue noise texture is "low discrepancy over space" which means there are fewer visible patterns than white noise
 * it also gives more even coverage vs white noise. no clumps or voids.

* In an attempt to make it also blue noise over time, you can add the golden ratio and frac it.
 * that makes it lower discrepancy over time, but makes it less good over space.
 * thanks to r4unit for that tip! https://twitter.com/R4_Unit

* Animating the noise in this demo makes the noise basically disappear imo, it's really nice!

For more information:

What the heck is blue nois:
https://blog.demofox.org/2018/01/30/what-the-heck-is-blue-noise/

Low discrepancy sequences:
https://blog.demofox.org/2017/05/29/when-random-numbers-are-too-random-low-discrepancy-sequences/

You can get your own blue noise textures here:
http://momentsingraphics.de/?p=127
*/

vec2 res = vec2(iResolution.x, iResolution.y);
uniform float time = 1.0; // Speed : (speed of animated noise), min=0.1, max=100

float MyTime = iTime *.05 * time;
const float c_goldenRatioConjugate = 0.61803398875;

uniform bool ANIMATE_NOISE = false; // Animated Noise : (speed of animated noise)
uniform int TARGET_BITS = 3; // Bit Depth : (amount of bit depth reduction), min=1, max=8
uniform bool DITHER_IN_LINEAR_SPACE = false; // Dither in Linear : (dither in linear)
uniform bool show_only_noise; // Noise Only : (outputs just the blue noise)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy/res.xy;
    vec3 fg = texture2D( iChannel0, uv ).rgb;
    vec3 col = vec3(0.0);
    // get blue noise "random" number
    vec2 blueNoiseUV = fragCoord.xy / vec2(1024.0);
    vec3 blueNoise = texture2D(iChannel1, blueNoiseUV).rgb;
    if ( ANIMATE_NOISE )
      blueNoise = fract(blueNoise + float(MyTime) * c_goldenRatioConjugate);

    // dither to the specified number of bits, using sRGB conversions if desired
    if( DITHER_IN_LINEAR_SPACE )
    	fg = pow(fg, vec3(2.2));

    float scale = exp2(float(TARGET_BITS)) - 1.0;
    col = floor(fg*scale + blueNoise)/scale;

    if( DITHER_IN_LINEAR_SPACE )
    	col = pow(col, 1.0/vec3(2.2));

    if ( show_only_noise )
      col = blueNoise;

    fragColor = vec4(col,1.0);
}
