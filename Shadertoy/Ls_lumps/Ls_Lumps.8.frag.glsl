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

// Lumps blur vertical pass and split/scale/combine
// lewis@lewissaunders.com

// iChannel0: pass1_result, filter=linear,wrap=clamp
// iChannel1: pass2_result, filter=linear,wrap=clamp
// iChannel2: pass3_result, filter=linear,wrap=clamp
// iChannel3: pass4_result, filter=linear,wrap=clamp
// iChannel4: pass6_result, filter=linear,wrap=clamp
// iChannel5: pass7_result, filter=linear,wrap=clamp
// BBox: iChannel0

uniform float lumpsize = 20.0; // Lump size : (lump size), min=0.0

uniform bool outputcolour = true;
uniform bool outputlumps = true;
uniform bool outputdetail = true;

uniform float scolour = 1.0; // Colour : (colour)
uniform float slumps = 0.5; // Lumps : (lumps)
uniform float sdetail = 1.0; // Detail : (detail)

uniform bool recombine = false; // Recombine inputs : 
uniform bool islin = true; // Use 0.18 for mid-gray : 

const float pi = 3.141592653589793238462643383279502884197969;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	if(recombine == true) {
		vec4 colour = texture2D(iChannel1, xy * px);
		vec4 lumps = texture2D(iChannel2, xy * px);
		vec4 detail = texture2D(iChannel3, xy * px);
		if(islin == true) {
			lumps -= vec4(0.18);
			detail -= vec4(0.18);
		} else {
			lumps -= vec4(0.5);
			detail -= vec4(0.5);
		}
		colour /= scolour;
		lumps /= slumps;
		detail /= sdetail;
		fragColor = colour + lumps + detail;
		return;
	}

	float sigma = lumpsize;
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
	vec4 a = g.x * texture2D(iChannel5, xy * px);
	float energy = g.x;
	g.xy *= g.yz;

	// The rest
	for(int i = 1; i <= support; i++) {
		a += g.x * texture2D(iChannel5, (xy - vec2(0.0, float(i))) * px);
		a += g.x * texture2D(iChannel5, (xy + vec2(0.0, float(i))) * px);
		energy += 2.0 * g.x;
		g.xy *= g.yz;
	}
	a /= energy;

	vec4 front = texture2D(iChannel0, xy * px);
	vec4 colour = texture2D(iChannel4, xy * px);
	vec4 lumps = a - colour;
	vec4 detail = front - a;

	colour *= scolour;
	lumps *= slumps;
	detail *= sdetail;

	vec4 o = vec4(0.5);
	if(islin == true) o = vec4(0.18);

	if(outputcolour == true) o = colour;
	if(outputlumps == true) o += lumps;
	if(outputdetail == true) o += detail;

	fragColor = o;
}
