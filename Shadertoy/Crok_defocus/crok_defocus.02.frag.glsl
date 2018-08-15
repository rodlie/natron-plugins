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
// Code original : crok_defocus Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_defocus Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter=linear, wrap=clamp
// iChannel1: Front_Strength_Map, filter=linear, wrap=clamp
// BBox: iChannel0

// Bokeh disc.
// by David Hoskins.
// https://www.shadertoy.com/view/4d2Xzw
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.


vec2 resolution = vec2(iResolution.x, iResolution.y);

uniform float frontBlur = 0.0; // Front Size : ,min=0.0, max=100.0
uniform float frontGain = 0.0; // Front Gain : ,min=0.0, max=10000.0
uniform float frontNUMBER = 300.0; // Front Steps : ,min=1.0, max=1000.0

uniform int frontStyle = 0; // Front Style : (Front style),min=0, max=6

float f_strength = 1.0;


// This is (3.-sqrt(5.0))*PI radians, which doesn't precompiled for some reason.
// The compiler is a dunce I tells-ya!!

#define ITERATIONS (GOLDEN_ANGLE * frontNUMBER)
#define PI 3.141596

// This creates the 2D offset for the next point.
// (r-1.0) is the equivalent to sqrt(0, 1, 2, 3...)
vec2 Sample(in float theta, inout float r)
{
    r += 1.0 / r;
	return (r-1.0) * vec2(cos(theta), sin(theta)) * .06;
}

vec4 Bokeh(sampler2D tex, vec2 uv, float radius, float amount)
{
    float r = 1.0;
	float GOLDEN_ANGLE = 2.39996323;
	
	if ( frontStyle == 0 )
		r = 0.5;
	if ( frontStyle == 1 )
		r = 50.;
	if ( frontStyle == 2 )
		r = 10.;
	if ( frontStyle == 3 )
		GOLDEN_ANGLE *= 1.05;
	if ( frontStyle == 4 )
		GOLDEN_ANGLE *= .982;
	if ( frontStyle == 5 )
		GOLDEN_ANGLE *= 3.665;
	if ( frontStyle == 6 )
		GOLDEN_ANGLE *= 0.873;
	
	vec4 acc = vec4(0.0);
	vec4 div = vec4(0.0);
    vec2 pixel = vec2(resolution.y/resolution.x, 1.0) * radius * .025;
	
	for (float j = 0.0; j < ITERATIONS; j += GOLDEN_ANGLE)
    {
		vec4 col = texture2D(tex, uv + pixel * Sample(j, r));
		vec4 bokeh = vec4(5.0) + pow(col, vec4(9.0)) * vec4(amount);
		acc += col * floor(bokeh);
		div += floor(bokeh);
	}
	return acc / div;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / resolution.xy;
	f_strength = texture2D(iChannel1, uv).a;
	
    fragColor = vec4(Bokeh(iChannel0, uv, frontBlur * .4 * f_strength, frontGain));
}
    
