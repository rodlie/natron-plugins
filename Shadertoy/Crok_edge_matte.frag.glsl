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
// Code original : croc_edge_matte Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : croc_edge_matte Matchbox for Autodesk Flame


// iChannel0: rgba, filter=linear, wrap=clamp
// BBox: iChannel0

uniform float gamma = 1; // gamma : (gamma), min=0., max=10.
uniform float gain = 1; // gain : (gamma), min=0., max=10.
uniform float offset = 0; // offset : (gamma), min=0., max=20.
uniform float texScale = 1; // scale :, min=1, max=20.


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 uv2 = (fragCoord.xy / iResolution.xy)/texScale;
	vec4 col = clamp(texture2D(iChannel0, uv2).rgba, 0.0, 1.0);

	col.r=col.a;
	col.g=col.a;
	col.b=col.a;

	vec4 source = texture2D(iChannel0, uv);

	// matte offset 
	col = pow(col, vec4(1.0 / (offset + 1.0)));
	
	// invert original matte
	vec4 col_inv = 1.0 - col;
	
	// multiply original matte with inverted matte to get the outline
	col *= col_inv;
	
	// apply some gamma correction to the matte
	col = pow(col, vec4(1.0 / gamma));
	
	// apply some gain to brighten up the matte
	col *= col * gain *10.;
	source.a = col.r;
	


	fragColor = vec4(source.rgb, col.r);
}