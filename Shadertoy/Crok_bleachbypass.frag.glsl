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
// Code original : crok_bleachbypas Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_bleachbypas Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest
// BBox: iChannel0


uniform float Exposure = 1; // exposure : (exposure), min=-10., max=10.
uniform float Amount = 1; // amount : (amount), min=-10., max=10.
const vec4 one = vec4(1.0);	
const vec4 two = vec4(2.0);
const vec4 lumcoeff = vec4(0.2125,0.7154,0.0721,0.0);

vec4 overlay(vec4 source, vec4 src, vec4 amount)

{
	float luminance = dot(src,lumcoeff);
	float mixamount = clamp((luminance - 0.45) * 10., 0., 1.);
	vec4 branch1 = two * src * source;
	vec4 branch2 = one - (two * (one - src) * (one - source));
	vec4 result = mix(branch1, branch2, vec4(mixamount) );
	return mix(src, result, amount);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{ 		
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 tc = texture2D(iChannel0, uv);
	vec4 luma = vec4(dot(tc,lumcoeff));
	luma = clamp(luma, 0.0, 1.0);
	vec4 col = overlay(luma, tc, vec4(Amount)) * Exposure;
	fragColor = col;
		
} 
