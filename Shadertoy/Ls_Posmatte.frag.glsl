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
// Code original : Ls_Postmatte Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Postmatte Matchbox for Autodesk Flame

// Pick an ellipsoidal area matte from an XYZ position pass
// lewis@lewissaunders.com
// TODO:
//  o Rotation
//  o Skew
//  o Cube-shaped matte - with rounded corners?


// iChannel0: front, filter = nearest, wrap0 = clamp
// iChannel1: matte, filter = nearest, wrap1 = clamp
// iChannel2: position, filter = nearest, wrap1 = clamp



uniform vec3 pick; // Pick color
uniform vec3 overlaycol; // Overlay color

uniform float tolerance; // Tolerance
uniform float softness; // Softness
uniform float falloffswoop; // Falloff swoop
uniform float offsetx; // X offset
uniform float offsety; // Y offset
uniform float offsetz; // Z offset
uniform float scalex; // X scale
uniform float scaley; // Y scale
uniform float scalez; // Z scale

uniform bool overlay = false; // Overlay
uniform bool hatch = false; // Hatch


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
