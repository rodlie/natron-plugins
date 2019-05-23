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
// Code original : crok_deband Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_deband Matchbox for Autodesk Flame

// based on: http://media.steampowered.com/apps/valve/2015/Alex_Vlachos_Advanced_VR_Rendering_GDC2015.pdf


// iChannel0: Source, filter = linear, wrap = clamp
// iChannel1: Mask, filter = linear, wrap = clamp
// BBox: iChannel0



float time = iTime *.05;

uniform float amount = 100.0; // Amount : (amount), min=0, max=100000
uniform bool useMask = false; // Mask : (Use mask.)
uniform int maskChannel = 3; // Channel : (channel used as mask.), min=0, max=3

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 image = texture2D(iChannel0, uv);
	vec4 mask = texture2D(iChannel1, uv);

	if(maskChannel ==0)
		mask.a = mask.r;
	if(maskChannel ==1)
		mask.a = mask.g;
	if(maskChannel ==2)
		mask.a = mask.b;

	if(useMask == false)
		mask.a =1;
	
    vec3 dither = vec3(dot(vec2( 171.0, 231.0 ), fragCoord.xy + vec2(time)));
    dither.rgb = fract( dither.rgb / vec3(103.0,71.0,97.0)) - vec3(0.5);
	vec4 col = vec4(( dither.rgb / 255.0 * amount * mask.a * image.a ), 1.0 ) + image;
	col.a = image.a;
	fragColor = col;
}