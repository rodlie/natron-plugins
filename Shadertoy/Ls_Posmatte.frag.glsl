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
// Code original : Ls_Posmatte Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Posmatte Matchbox for Autodesk Flame

// Pick an ellipsoidal area matte from an XYZ position pass
// lewis@lewissaunders.com
// TODO:
//  o Rotation
//  o Skew
//  o Cube-shaped matte - with rounded corners?


// iChannel0: Source, filter = linear, wrap0 = clamp
// iChannel1: Mask, filter = nearest, wrap1 = clamp
// iChannel2: Position pass, filter = nearest, wrap1 = clamp



uniform vec3 pick; // Pick centre : 

uniform float tolerance = 0.1; // Tolerance : , min=0.0, max=10000
uniform float softness = 1.0; // Softness : , min=0.001, max=1000000
uniform float falloffswoop = 1.0; // Edge swoop : , min=0.0, max=1.0

uniform float offsetx = 0.0; // X offset : , min=-10000, max=10000
uniform float offsety = 0.0; // Y offset : , min=-10000, max=10000
uniform float offsetz = 0.0; // Z offset : , min=-10000, max=10000

uniform float scalex = 1.0; // X scale :  , min=-10000, max=10000
uniform float scaley = 1.0; // Y scale :  , min=-10000, max=10000
uniform float scalez = 1.0; // Z scale :  , min=-10000, max=10000

uniform bool overlay = false; // Overlay : 
uniform vec3 overlaycol = vec3(0.98,0.0,0.43); // Overlay color : 

uniform bool hatch = false; // Crosshatch : 


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 coords = fragCoord.xy / vec2(iResolution.x, iResolution.y);
	vec3 o, frontpix, pospix, mattepix, centered, diff = vec3(0.0);
	float m = 0.0;

	frontpix = texture2D(iChannel0, coords).rgb;
	mattepix = texture2D(iChannel1, coords).rgb;
	pospix = texture2D(iChannel2, coords).rgb;

	// Center coordinate space about the picked colour so we can scale easily
	centered = pospix - pick - vec3(offsetx, offsety, offsetz);
	diff = centered / vec3(scalex, scaley, scalez);

	m = length(diff);
	if(m < tolerance) {
		m = 0.0;
	} else {
		m = (m - tolerance) / softness;
	}
	m = clamp(1.0 - m, 0.0, 1.0);
	m = mix(m, smoothstep(0.0, 1.0, m), falloffswoop);
	m *= mattepix.b;

	o = frontpix;
	if(overlay) {
		o += m * overlaycol;
		if(hatch) {
			// Cheap-ass diagonal lines
			float h = mod(fragCoord.x - fragCoord.y, 20.0);
			h = h > 10.0 ? 0.0 : 1.0;
			o = mix(o, frontpix, h);
		}
	}

	fragColor = vec4(o, m);
}
