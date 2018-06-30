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
// Code original : crok_heathaze Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_heathaze Matchbox for Autodesk Flame


// iChannel0: pass4_result, filter = linear,wrap=clamp
// iChannel1: pass5_result, filter = linear,wrap=clamp
// iChannel2: strength_map, filter = linear,wrap=clamp
// BBox: iChannel0

// Directional blur driven by gradient vectors of front input
// lewis@lewissaunders.com


uniform float blur_length = 3.0; // Amount : (strength of applied hmotion blur), min=0.0, max=512.0
uniform int samples = 16; // Samples : (motion blur samples), min=2, max=128


void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 xy = fragCoord.xy;
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
	
	float strength = texture2D(iChannel2, uv).r;

	// Factor to convert [0,1] texture coords to pixels
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	// Get vectors from previous pass
	vec2 d = texture2D(iChannel0, xy * px).xy;

	if(length(d) == 0.0) {
		// No gradient at this point in the map, early out
		fragColor = texture2D(iChannel1, xy * px);
		return;
	}

	vec4 a = vec4(0.0);
	float sam = float(samples);
	float steps;
	bool odd = false;

	if(mod(sam, 2.0) == 1.0) {
		odd = true;
	}
	if(odd) {
		// Odd number of samples, start with a sample from the current position
		a = texture2D(iChannel1, xy * px);
		steps = (sam - 1.0) / 2.0;
	} else {
		// Even number of samples, start with nothing
		a = vec4(0.0);
		steps = (sam / 2.0) - 1.0;
	}

	// Now accumulate along the path forwards...
	if(!odd) {
		// Even number of samples, first step is half length
		xy += 0.5 * d * blur_length * strength / (sam - 1.0);
		a += texture2D(iChannel1, xy * px);
	}
	for(float i = 0.0; i < steps; i++) {
		d = texture2D(iChannel0, xy * px).xy;
		xy += d * blur_length * strength / (sam - 1.0);
		a += texture2D(iChannel1, xy * px);
	}
	
	// ...and backwards
	xy = fragCoord.xy;
	d = texture2D(iChannel0, xy * px).xy;
	if(!odd) {
		// Even number of samples, first step is half length
		xy -= 0.5 * d * blur_length * strength / (sam - 1.0);
		a += texture2D(iChannel1, xy * px);
	}
	for(float i = 0.0; i < steps; i++) {
		xy -= d * blur_length * strength / (sam - 1.0);
		a += texture2D(iChannel1, xy * px);
		d = texture2D(iChannel0, xy * px).xy;
	}

	a /= sam;
	fragColor = a;
}
