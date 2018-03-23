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
// Code original : Ls_Splineblur Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Splineblur Matchbox for Autodesk Flame

// iChannel0: Source, filter=nearest, wrap=clamp
// iChannel1: Pass1_result, filter=nearest, wrap=clamp
// BBox: iChannel0


// Directional blur driven by gradient vectors of iChannel0 input
// Pass 2: do the blur
// lewis@lewissaunders.com
// TOOD:
//  o Adaptive sampling based on length?
//  o Figure out correct calibration of length slider to pixel lengths?
//  o Triangular or gaussian window on samples?
//  o Normalize gradient vector and use another input for length control?
//    Currently, normalizing would give a super hard edge where the iChannel0
//    image is a solid colour
//  o Variable mix between the two algorithms would be neat







uniform float blength = 8.0; // Length : (Amount to blur by), min=0.0, max=2048.0

uniform int samples = 32; // Samples : (Number of samples, increase for smoothness), min=1, max=2048


uniform bool vectors = false; // Output vectors : (Output gradient vectors from map input instead of blurring, for use with MotionBlur et al.)
uniform bool normalize = false; // Output normalized : (Normalize vector output around 0.5 instead of 0.0, for use with PixelSpread's Vector Warp mode.)
uniform bool pathy = true; // Accurate cornering : (Use a slower algorithm which gives much smoother corners.)
uniform bool img_degrade = false; // Degrade : (degrade image for faster render.)






void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;

	// Factor to convert [0,1] texture coords to pixels
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	// Get vectors from previous pass
	vec2 d = texture2D(iChannel1, xy * px).xy;

	if(vectors) {
		// Return the vectors, not the blur
		if(normalize) {
			// Bodge factor for a resonable result from PixelSpread
			d /= 4.0;
			d += 0.5;
			fragColor = vec4(d.x, d.y, 1.0, 1.0);
		} else {
			fragColor = vec4(d.x, d.y, 0.0, 1.0);
		}
		return;
	}

	if(length(d) == 0.0) {
		// No gradient at this point in the map, early out
		fragColor = texture2D(iChannel0, xy * px);
		return;
	}

	vec4 a = vec4(0.0);
	float sam = float(samples);
	float steps;
	bool odd = false;

	if(img_degrade) {
		sam /= 4.0;
	}

	if(!pathy) {
		// Do a way simpler blur along a line and get outta here
		vec2 step = d * blength / (sam - 1.0);
		for(float i = 0.0; i < sam; i++) {
			a += texture2D(iChannel0, (xy + (i - ((sam-1.0)/2.0)) * step) * px);
		}
		a /= sam;
		fragColor = a;
		return;
	}

	if(mod(sam, 2.0) == 1.0) {
		odd = true;
	}
	if(odd) {
		// Odd number of samples, start with a sample from the current position
		a = texture2D(iChannel0, xy * px);
		steps = (sam - 1.0) / 2.0;
	} else {
		// Even number of samples, start with nothing
		a = vec4(0.0);
		steps = (sam / 2.0) - 1.0;
	}

	// Now accumulate along the path forwards...
	if(!odd) {
		// Even number of samples, first step is half length
		xy += 0.5 * d * blength / (sam - 1.0);
		a += texture2D(iChannel0, xy * px);
	}
	for(float i = 0.0; i < steps; i++) {
		d = texture2D(iChannel1, xy * px).xy;
		xy += d * blength / (sam - 1.0);
		a += texture2D(iChannel0, xy * px);
	}
	
	// ...and backwards
	xy = fragCoord.xy;
	d = texture2D(iChannel1, xy * px).xy;
	if(!odd) {
		// Even number of samples, first step is half length
		xy -= 0.5 * d * blength / (sam - 1.0);
		a += texture2D(iChannel0, xy * px);
	}
	for(float i = 0.0; i < steps; i++) {
		xy -= d * blength / (sam - 1.0);
		a += texture2D(iChannel0, xy * px);
		d = texture2D(iChannel1, xy * px).xy;
	}

	a /= sam;
	fragColor = a;
}
