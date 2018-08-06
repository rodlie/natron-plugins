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
// Code original : crok_blush Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_blush Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Source,filter=linear,wrap=clamp
// iChannel1: Mask,filter=nearest,wrap=clamp
// BBox: format


uniform int channelChoice = 3; // Channel : , min=0, max=3


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y);
	vec3 f = texture2D(iChannel0, uv).rgb;

	float m = texture2D(iChannel1, uv).a;

	if(channelChoice == 0)
		m = texture2D(iChannel1, uv).r;

	if(channelChoice == 1)
		m = texture2D(iChannel1, uv).g;

	if(channelChoice == 2)
		m = texture2D(iChannel1, uv).b;

	if(channelChoice == 3)
		m = texture2D(iChannel1, uv).a;

	fragColor = vec4(f, m);
}
