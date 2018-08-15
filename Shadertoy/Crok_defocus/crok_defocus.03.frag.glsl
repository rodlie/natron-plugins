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


// iChannel0: pass2_result, filter=linear, wrap=clamp
// iChannel1: Bg, filter=linear, wrap=clamp
// iChannel2: Back_Strength_Map, filter=linear, wrap=clamp
// BBox: iChannel0

// Bokeh disc.
// by David Hoskins.
// https://www.shadertoy.com/view/4d2Xzw#
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.


vec2 resolution = vec2(iResolution.x, iResolution.y);

uniform float backBlur = 0.0; // Back Size : ,min=0.0, max=100.0
uniform float backGain = 0.0; // Back Gain : ,min=0.0, max=10000.0
uniform float backNUMBER = 300.0; // Back Steps : ,min=1.0, max=1000.0

uniform int backStyle = 0; // Back Style : (Back style) ,min=0, max=6
uniform bool srcIsPreMult = true; // Front is Premultiplied : 

float b_strength = 1.0;


// This is (3.-sqrt(5.0))*PI radians, which doesn't precompiled for some reason.
// The compiler is a dunce I tells-ya!!

#define ITERATIONS (GOLDEN_ANGLE * backNUMBER)
#define PI 3.141596

// This creates the 2D offset for the next point.
// (r-1.0) is the equivalent to sqrt(0, 1, 2, 3...)
vec2 Sample(in float theta, inout float r)
{
    r += 1.0 / r;
	return (r-1.0) * vec2(cos(theta), sin(theta)) * .06;
}

vec3 Bokeh(sampler2D tex, vec2 uv, float radius, float amount)
{
    float r = 1.0;
	float GOLDEN_ANGLE = 2.39996323;
	
	if ( backStyle == 0 )
		r = 0.5;
	if ( backStyle == 1 )
		r = 50.;
	if ( backStyle == 2 )
		r = 10.;
	if ( backStyle == 3 )
		GOLDEN_ANGLE *= 1.05;
	if ( backStyle == 4 )
		GOLDEN_ANGLE *= .982;
	if ( backStyle == 5 )
		GOLDEN_ANGLE *= 3.665;
	if ( backStyle == 6 )
		GOLDEN_ANGLE *= 0.873;
	
	vec3 acc = vec3(0.0);
	vec3 div = vec3(0.0);
    vec2 pixel = vec2(resolution.y/resolution.x, 1.0) * radius * .025;
	
	for (float j = 0.0; j < ITERATIONS; j += GOLDEN_ANGLE)
    {
		vec3 col = clamp(texture2D(tex, uv + pixel * Sample(j, r)).xyz, 0.0, 1000000000.0);
		vec3 bokeh = vec3(5.0) + pow(col, vec3(9.0)) * amount;
		acc += col * floor(bokeh);
		div += floor(bokeh);
	}
	return acc / div;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / resolution.xy;
	b_strength = texture2D(iChannel2, uv).a;

    vec4 frontResult = texture2D(iChannel0, uv);
	vec4 backResult = vec4(Bokeh(iChannel1, uv, backBlur * .4 * b_strength, backGain ), 1.0);
	
	if ( srcIsPreMult && frontResult.a != 0.0 )
        {
           frontResult.rgb /= vec3(frontResult.a);
        }
		
	fragColor = vec4(mix(backResult.rgb, frontResult.rgb, frontResult.a), frontResult.a);

}
    
