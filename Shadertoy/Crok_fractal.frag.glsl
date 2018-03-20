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
// Code original : crok_fractal Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_fractal Matchbox for Autodesk Flame

// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
// original created by JoshP in 7/5/2013



uniform int resolution = 23; // Resolution : (resolution), min=1.0, max=50.0
uniform float offsetx = -10.0; // Offset x : (offset x), min=-10.0, max=10.0
uniform float offsety = 10.0; // Offset y : (offset y), min=-10.0, max=10.0
uniform float p3;
uniform float seed = 4000; // Seed : (seed), min=1.0, max=10000
uniform float zoom = 26.80; // Zoom : (zoom), min=1.0, max=100.0
uniform float gain = 10.0; // Gain : (gain), min=0.1, max=1000.0
uniform vec3 color = vec3(0.7,0.7,0.7); // Colour : (colour)

float myGlobalTime = iTime;


float field(in vec3 p) {
	float strength = 9. + .00003 * log(1.e-6 + fract(sin(myGlobalTime) * 4373.11));
	float accum = 0.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < resolution; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.3));
		tw += w;
		prev = mag;
	}
	return max(0., 4.3 * accum / tw - 0.7);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 uv = 2. * fragCoord.xy / iResolution.xy - 1.;
	vec2 uvs = uv * iResolution.xy / max(iResolution.x, iResolution.y);
	vec3 p = vec3(uvs / zoom, 0) + vec3(1., -1.3, 0.);
	p += .2 * vec3(offsetx, offsety, myGlobalTime / seed);
	float t = field(p);
    fragColor = mix(0.1, 1.0, gain) * vec4(color.r * t * t * t, color.g *t * t, color.b * t, 1.0);
}