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
// Code original : y_mult_div Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_mult_div Matchbox for Autodesk Flame


// iChannel0:RGB,filter=nearest,wrap=clamp
// iChannel1:Alpha,filter=nearest,wrap=clamp
// BBox: iChannel0

vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;

uniform bool divide = false; // Divide : (Divide.)
uniform bool invert = false; // Invert Matte : (Invert the matte.)
uniform int channelChoice = 3; // Channel : ,min=0, max=3

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec3 front = texture2D(iChannel0, st).rgb;
	vec4 alpha = texture2D(iChannel1, st);
	float matte = texture2D(iChannel1, st).r;

	if (channelChoice == 1)
	{
		matte = alpha.g;
	}

	if (channelChoice == 2)
	{
		matte = alpha.b;
	}

	if (channelChoice == 3)
	{
		matte = alpha.a;
	}

	if (invert == true)
	{
		matte = 1.0 - matte;
	}

	if (divide == true)
	{
		front = front / max(matte, .00001);
	} else {
		front *= matte;
	}

	fragColor = vec4(front, matte);
}
