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
// Code original : y_blurs Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_blurs Matchbox for Autodesk Flame


// iChannel0: result_pass1,filter=linear,wrap=clamp
// BBox: iChannel0




vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 st = fragCoord.xy / res;
	vec4 front = texture2D(iChannel0, st);

	fragColor = vec4(front.rgb * front.a, front.a);
}
