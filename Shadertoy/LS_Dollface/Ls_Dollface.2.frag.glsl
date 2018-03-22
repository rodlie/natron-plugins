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
// Code original : Ls_Dollface Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : LS_Dollface Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest
// iChannel1: Strength map, filter = nearest
// BBox: iChannel0




// Blur only similar pixels
// Pass 2: horizontal blur
// lewis@lewissaunders.com





uniform float sigma = 40.0; // Sigma : (sigma), min=0, max=100
uniform float threshold = 40.0; // Threshold : (threshold), min=0.001, max=100
uniform int quality = 3; // Quality : (quality), min=0, max=3

uniform bool slow = false;






const float pi = 3.141592653589793238462643383279502884197969;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	float strength_here = texture2D(iChannel1, xy * px).b;
	float sigma_here = sigma * strength_here;

	int support = int(sigma_here * 3.0);

	float kernelhyp = length(vec2(support, support));
	float rgbhyp = length(vec3(1.0, 1.0, 1.0));

	if(slow) {
		// Use pass 1 results and quit
		fragColor = texture2D(iChannel0, xy * px);
		return;
	}

	// Incremental coefficient calculation setup as per GPU Gems 3
	vec3 g;
	g.x = 1.0 / (sqrt(2.0 * pi) * sigma_here);
	g.y = exp(-0.5 / (sigma_here * sigma_here));
	g.z = g.y * g.y;

	if(sigma_here == 0.0) {
		g.x = 1.0;
	}

	vec4 a, b, c;
	a = vec4(0.0);
	float fac, energy = 0.0;

	// Centre sample
	vec4 orig = texture2D(iChannel0, xy * px);
	a += g.x * orig;
	energy += g.x;
	g.xy *= g.yz;

	int inc = int(pow(2.0, 3.0 - float(quality)));

	// The rest
	for(int i = 1; i <= support; i += inc) {
		b = texture2D(iChannel0, (xy - vec2(0.0, float(i))) * px);
		c = texture2D(iChannel0, (xy + vec2(0.0, float(i))) * px);

		b.a = 1.0;
		c.a = 1.0;

		fac = 1.0 - (length(b - orig) / rgbhyp);
		fac = pow(fac, threshold);
		b *= g.x * clamp(fac, 0.001, 1.0);
		a += b;
		energy += b.a;

		fac = 1.0 - (length(c - orig) / rgbhyp);
		fac = pow(fac, threshold);
		c *= g.x * clamp(fac, 0.001, 1.0);
		a += c;
		energy += c.a;

		g.xy *= g.yz;
	}
	a /= energy;

	fragColor = a;
}
