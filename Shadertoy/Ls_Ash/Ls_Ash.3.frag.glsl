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
// Code original : Ls_Ash Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Ash Matchbox for Autodesk Flame

// iChannel0: result_pass2, filter = linear, wrap=ckamp
// iChannel1: Source, filter = linear, wrap=ckamp
// iChannel2: Strength map, filter = linear, wrap=ckamp
// BBox: iChannel0

// Adaptive sharpening
// Pass 2: vertical Gaussian blur
// lewis@lewissaunders.com





uniform float sigma = 2.5; // Size : (Size of biggest details to sharpen), min=0.0, max=100.0
uniform float strength = 1.0; // Strength : (Amount of sharpening), min=0.0, max=5.0

uniform bool adaptive = true; // Adaptive : (Protect edges from ringing)
uniform bool onlyedges = false; // Sharpen edges only : (Sharpen just the edges, instead of trying to keep the sharpening away from them)
uniform bool showedges = false; // Show edges : (Output edge matte)



const float pi = 3.141592653589793238462643383279502884197969;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	float strength_here = strength * texture2D(iChannel2, xy * px).b;

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
	vec4 a = g.x * texture2D(iChannel0, xy * px);
	float energy = g.x;
	g.xy *= g.yz;

	// The rest
	for(int i = 1; i <= support; i++) {
		a += g.x * texture2D(iChannel0, (xy - vec2(0.0, float(i))) * px);
		a += g.x * texture2D(iChannel0, (xy + vec2(0.0, float(i))) * px);
		energy += 2.0 * g.x;
		g.xy *= g.yz;
	}
	a /= energy;
	vec4 unsharp = a;

	// Inflate edge pass a little
	float edginess = clamp(unsharp.a * 3.0, 0.0, 1.0);

	if(onlyedges) {
		edginess = 1.0 - edginess;
	}

	// Sharpen
	vec4 orig = texture2D(iChannel1, xy * px);
	vec4 sharp = orig + vec4(strength_here) * (orig - unsharp);

	if(adaptive){
		// Remove sharpening from edges
		sharp = edginess * orig + (1.0 - edginess) * sharp;
	}

	if(showedges) {
		sharp = vec4(edginess);
	}

	fragColor = vec4(sharp.r, sharp.g, sharp.b, 1.0);
}
