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
// Code original : Ls_nail Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_nail Matchbox for Autodesk Flame

// iChannel0: Source, filter = linear, wrap = clamp
// iChannel1: Mask, filter = linear, wrap = clamp
// iChannel2: Nail Mask, filter=nearest, wrap=clamp
// BBox: iChannel0

// Transforms the area inside the nail matte by the difference between two tracks
// Use to stick down floating CG, by nailing from a track on the CG to a track on the BG
// lewis@lewissaunders.com
// TODO:
//  o Anti-aliased overlay
//  o Rotate, scale, shear?
//  o Better filtering probably.  Not sure if EWA would work because no dFdx?



uniform vec2 trackfrom = vec2(0.0,0.0); // Nail from : (Nail this point...)
uniform vec2 trackto = vec2(0.0,0.0); // Nail to : (...to this point)
uniform vec2 offset = vec2(0.0,0.0); // Offset : (offset)

uniform bool tracksarepixels = true; // Tracks are pixels : 

uniform float extra = 1.0; // Extra push : 
uniform float amount = 1.0; // Nail strength : 
uniform float edgeswoop = 0.7; // Edge swoop : 

uniform bool matteistarget = true; // Matte is target, not source : 


uniform bool overlay = false; // Overlay : (overlay)

uniform vec3 areatint = vec3(0.33,0.27,0.0);

float distanceToSegment(vec2 p0, vec2 p1, vec2 p) {
	vec2 v = p1 - p0;
	vec2 w = p - p0;
	float c1 = dot(w, v);
	float c2 = dot(v, v);

	if(c1 <= 0.0)
		return length(p0 - p);
	if(c2 <= c1)
		return length(p1 - p);

	float b = c1 / c2;
	vec2 pb = p0 + b * v;
	return length(pb - p);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 res = vec2(iResolution.x, iResolution.y);
	vec2 coords = fragCoord.xy / res;

	vec2 diff = trackto - trackfrom + offset;
	diff *= extra;
	diff *= amount;

	if(tracksarepixels) {
		diff /= res;
	}

	float coeff = 0.0;
	if(matteistarget) {
		coeff = texture2D(iChannel2, coords).b;
	} else {
		coeff = texture2D(iChannel2, coords - diff).b;
	}
	coeff = mix(coeff, smoothstep(0.0, 1.0, coeff), edgeswoop);
	diff *= coeff;

	vec2 q = coords - diff;

	vec3 o = texture2D(iChannel0, q).rgb;
	float m = texture2D(iChannel1, q).b;

	if(overlay) {
		vec2 trackfromp = trackfrom;
		vec2 tracktop = trackto;
		vec2 offsetp = offset;
		vec2 coordsp = coords * res;

		if(!tracksarepixels) {
			trackfromp *= res;
			tracktop *= res;
			offsetp *= res;
		}

		if(length(coordsp - trackfromp) < 5.0)
			o = vec3(0.8, 0.2, 0.2);

		if(length(coordsp - tracktop) < 5.0)
			o = vec3(0.2, 0.8, 0.2);

		if(length(offsetp) > 0.0) {
			if(length(coordsp - (tracktop + offsetp)) < 5.0) {
				o = vec3(0.2, 0.2, 0.8);
			}
		}

		if(distanceToSegment(trackfromp, tracktop + offsetp, coordsp) < 1.0) {
			if(mod(length(trackfromp - coordsp), 8.0) < 4.0) {
				o = vec3(0.4, 0.4, 0.8);
			}
		}
		o += coeff * areatint;
	}

	fragColor = vec4(o, m);
}
