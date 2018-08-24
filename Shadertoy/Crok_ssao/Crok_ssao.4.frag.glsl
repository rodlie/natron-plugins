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
// Code original : crok_ssao Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_ssao Matchbox for Autodesk Flame


// iChannel0: pass3_result,filter=nearest,wrap=clamp
// iChannel1: Source,filter=nearest,wrap=clamp
// iChannel2: Bg,filter=nearest,wrap=clamp
// iChannel3: Mask,filter=nearest,wrap=clamp
// BBox: iChannel0


uniform float Gamma = 1.0; // Gamma : (gamma), min=0.0, max=100.0
uniform bool ssao_matte_switch = false; // SSAO only : (SSAO only)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
    vec3 org_color = texture2D(iChannel1, uv.st).rgb;
    vec3 bg_color = texture2D(iChannel2, uv.st).rgb;
    vec3 Matte_col = texture2D(iChannel3, uv.st).rgb;
	vec3 color = texture2D(iChannel0, uv).rgb;

	vec3 gamma_col = pow(color, vec3(1.0 / Gamma));
	vec3 ssao_col = org_color * gamma_col;

	vec3 fin_col = vec3((ssao_col + (1.0 - Matte_col) * bg_color));
	
	if ( ssao_matte_switch== true )
		fin_col = gamma_col + (1.0 - Matte_col) * 1.0;

	fragColor = vec4(fin_col, Matte_col);
}
