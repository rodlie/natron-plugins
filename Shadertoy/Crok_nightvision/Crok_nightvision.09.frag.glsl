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
// Code original : crok_nightvision Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : crok_nightvision Matchbox for Autodesk Flame
//
// iChannel0: pass6_result, filter=linear, wrap=clamp
// iChannel1: pass8_result, filter=linear, wrap=clamp

//loading front



vec3 screen( vec3 s, vec3 d )
{
	return s + d - s * d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
	vec3 col = texture2D(iChannel0, uv).rgb;
	vec3 col_glow = texture2D(iChannel1, uv).rgb;
	
	col = screen(col, col_glow);
	
	fragColor = vec4(col, 1.0);
}