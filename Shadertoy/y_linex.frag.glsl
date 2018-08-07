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
// Code original : y_linex Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_linex Matchbox for Autodesk Flame

// iChannel0: Front, filter=linear,wrap=clamp
// iChannel1: Back, filter=linear,wrap=clamp
// iChannel2: Alpha, filter=linear,wrap=clamp
// BBox: format

uniform float blend = 0.5; // Mix : (Mix.), min=-100.0, max=100.0
uniform bool clamp_out = false; // Clamp Output : (Clamp output.)
uniform bool strength = false; // Use Matte as Strength : (Use the matte as a strength channel to multiply onto the effect.)
uniform bool swap = false; // Swap front and back : (Swap the inputs.)
uniform int channelSelect = 0; // Channel : , min=0, max=3

vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec4 iChannel0 = texture2D(iChannel0, st);
	vec4 iChannel1 = texture2D(iChannel1, st);
	vec4 alpha = texture2D(iChannel2, st);
	float iChannel2 = alpha.r;

	if (channelSelect == 1)
	{
		iChannel2 = alpha.g;
	}

	if (channelSelect == 2)
	{
		iChannel2 = alpha.b;
	}

	if (channelSelect == 3)
	{
		iChannel2 = alpha.a;
	}

	if (swap == true)
	{
		vec4 tmp = iChannel0;
		iChannel0 = iChannel1;
		iChannel1 = tmp;
	}

	vec4 comp = vec4(1.0);
	float b = blend;
	
	if (strength == true)
	{
		b = blend * iChannel2;
	}

	comp = mix(iChannel0, iChannel1, iChannel2 * b);

	if (clamp_out == true)
	{
		comp = clamp(comp, 0.0, 1.0);
	}

	fragColor = vec4(comp.rgb, iChannel2);
	fragColor.a = mix(iChannel0.a, iChannel1.a, iChannel2);
}
