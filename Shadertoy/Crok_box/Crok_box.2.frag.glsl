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
// Code original : crok_box Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_box Matchbox for Autodesk Flame

// pass2 : scale box

// based on https://www.shadertoy.com/view/Xs33DN

// iChannel0: result_pass1, filter = linear, wrap=clamp
// BBox: iChannel0


vec2 resolution = vec2(iResolution.x, iResolution.y);



uniform float scale = 0.75; // Scale : ,min=0.0016, max=1.0
uniform vec3 color = vec3(1.0,1.0,1.0); // Color
uniform vec2 offset = vec2(0.5,0.5);



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 sq = vec2(0.);
	vec2 uv = vec2(0.0);
	uv = (((fragCoord.xy / resolution.xy) - offset + 0.5));
	uv -= 0.5;
	uv /= scale;
	uv += 0.5;
	
	float mask = texture2D( iChannel0, uv).r;
	vec4 col = vec4(clamp(mask, 0.0, 1.0));
    fragColor = vec4(color.rgb*col.a,col.a);
}