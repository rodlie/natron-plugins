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
// Code original : Ls_Advect Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : Ls_Advect Matchbox for Autodesk Flame
//
// iChannel0: Source, filter = linear, wrap=clamp
// iChannel1: Pass1_result, filter = linear, wrap=clamp
// BBox: iChannel0

// Pass 2: do the displace
// TODO:
//  o Diffuse samples out along/around path direction?
// lewis@lewissaunders.com






uniform float blength = 8.0; // Length : (Distance to move by), min=-2048.0, max=2048.0
uniform float spacing = 1.5; // Softness : (Spacing between pixel samples), min=0.0, max=10.0
uniform float maxlength = 4.0; // Lifetime : (Distance by which brightness dies, as a ratio of the path length), min=0.0001, max=16.0
uniform float sidestep;

uniform vec2 offset = vec2(0.0,0.0); // Offset : , min=-10000, max=10000

uniform int samples = 32; // Samples : (Number of steps along path, increase to get correct path shape), min=0, max=32
uniform int oversamples = 4; // Oversampling : (Number of pixel samples, carefully increase for smoothness), min=1, max=64

uniform vec2 bl = vec2(0.0,0.0); // Bottom left : (Bottom left)
uniform vec2 tr = vec2(1.0,1.0); // Top right : (Top right)

uniform bool radial = false; // Rotate 90 : (Blur into and out of the contours instead of along the edges)
uniform bool vectors = false; // Output vectors : 
uniform bool normalize = false; // Output normalized : 
uniform bool adsk_degrade = false; // Degrade : (degrade image for faster render.)
uniform bool fadeout = false; // Fade in : (Darken samples the less they move)
uniform bool fadein = false; // Fade out : (Darken samples the further they move)





void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;

	// Factor to convert pixels to [0,1] texture coords
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

	// Crop
	vec2 xyn = xy * px;
	if((xyn.x < bl.x) || (xyn.x > tr.x)) {
		fragColor = texture2D(iChannel0, xyn);
		fragColor.a = 0.0;
		return;
	}
	if((xyn.y < bl.y) || (xyn.y > tr.y)) {
		fragColor = texture2D(iChannel0, xyn);
		fragColor.a = 0.0;
		return;
	}

	float sam = float(samples);
	if(adsk_degrade == true) {
		sam /= 4.0;
	}

	vec4 acc = vec4(0.0);
	for(int j = 0; j < oversamples; j++) {
		for(int k = 0; k < oversamples; k++) {
			// Starting point for this sample
			xy = fragCoord.xy + spacing * vec2(float(j) / (float(oversamples) + 1.0), float(k) / (float(oversamples) + 1.0));
			float dist = 0.0;
			// Walk along path by sampling vector image, moving, sampling, moving...
			for(float i = 0.0; i < sam; i++) {
				d = texture2D(iChannel1, xy * px).xy;
				if(length(d) == 0.0) {
					// No gradient at this point in the map, early out
					break;
				}
				xy += d * (blength/sam) + blength * sidestep/1000.0 * vec2(-d.y, d.x) + (blength/32.0) * offset;
				dist += length(d * (blength/sam));
			}
			// Sample iChannel0 image where our walk ended up
			acc.rgb += texture2D(iChannel0, xy * px).rgb;

			// Diffusion?
			/*for(float ix = 0.0; ix < diffusion; ix++) {
				for(float iy = 0.0; iy < diffusion; iy++) {
					acc.rgb += texture2D(iChannel0, (xy + vec2(ix, iy) * dist * px)).rgb * length(vec2(ix, iy)-vec2(diffusion/2.0, diffusion/2.0)) / (diffusion * diffusion * 32.0);
				}
			}*/

			// Length we've travelled to the matte output
			acc.a += dist * (blength/32.0);
		}
	}
	acc /= float(oversamples * oversamples);

	if(fadeout) {
		acc.rgb *= 1.0 - smoothstep(0.0, 1.0, abs(acc.a/(maxlength*blength+0.0001)));
	}
	if(fadein) {
		acc.rgb *= smoothstep(0.0, 1.0, abs(acc.a/(maxlength*blength)));
	}

	fragColor = acc; 
}
