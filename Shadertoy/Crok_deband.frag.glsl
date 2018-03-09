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
// BBox: iChannel0



float time = iTime *.05;

uniform float amount = 1; // Amount : (amount), min=0, max=100

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 image = texture2D(iChannel0, uv);
	
    vec3 dither = vec3(dot(vec2( 171.0, 231.0 ), fragCoord.xy + vec2(time)));
    dither.rgb = fract( dither.rgb / vec3(103.0,71.0,97.0)) - vec3(0.5);
	vec4 col = vec4(( dither.rgb / 255.0 * amount ), 1.0 ) + image;
	
	fragColor = col;
}



