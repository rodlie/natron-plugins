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
// Code original : Ls_Lumps Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Lumps Matchbox for Autodesk Flame

// Colour blur vertical pass
// lewis@lewissaunders.com

// iChannel0: pass1_result, filter=linear,wrap=clamp
// iChannel1: pass5_result, filter=linear,wrap=clamp
// BBox: iChannel0

#extension GL_ARB_shader_texture_lod : enable

uniform float coloursize = 50.0; // Colour Size : (colour size), min=0.0

uniform bool recombine = false; // Recombine inputs : 
uniform bool mipmapcolour = false; // Use average for colour : 

const float pi = 3.141592653589793238462643383279502884197969;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	if(recombine == true) discard;
	
	vec2 xy = fragCoord.xy;
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	if(mipmapcolour == true) {
		fragColor = texture2DLod(iChannel0, xy * px, 99.0);
		return;
	}
	
	float sigma = coloursize;
	int support = int(sigma * 3.0);

	// Incremental coefficient calculation setup as per GPU Gems 3
	vec3 g;
	g.x = 1.0 / (sqrt(2.0 * pi) * sigma);
	g.y = exp(-0.5 / (sigma * sigma));
	g.z = g.y * g.y;

	if(sigma == 0.0) {
		g.x = 1.0;
	}

	// Centre sample
	vec4 a = g.x * texture2D(iChannel1, xy * px);
	float energy = g.x;
	g.xy *= g.yz;

	// The rest
	for(int i = 1; i <= support; i++) {
		a += g.x * texture2D(iChannel1, (xy - vec2(0.0, float(i))) * px);
		a += g.x * texture2D(iChannel1, (xy + vec2(0.0, float(i))) * px);
		energy += 2.0 * g.x;
		g.xy *= g.yz;
	}
	a /= energy;

	fragColor = a;
}
