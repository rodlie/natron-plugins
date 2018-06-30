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


// setting inputs names and filtering options
// iChannel0: pass4_result, filter = linear,wrap=clamp
// iChannel1: source, filter = linear,wrap=clamp
// iChannel2: strength_map, filter = linear,wrap=clamp
// iChannel3: mask, filter = linear,wrap=clamp
// BBox: iChannel0

// Pass 2: do the displace
// lewis@lewissaunders.com


uniform float blength = 1.0; // Amount : (strength of the distortion), min=0.0, max=512.0
uniform float spacing = 1.5; // Softness : (spacing between pixel samples), min=0.0, max=10.0

uniform int oversamples = 4; // Oversampling : (number of pixel samples), min=1, max=32
uniform bool output_matte = true; // Output matte : (output matte)

const float sidestep = 0.0;


void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 xy = fragCoord.xy;
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
	
	float strength = texture2D(iChannel2, uv).r;

	// Factor to convert pixels to [0,1] texture coords
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	// Get vectors from previous pass
	vec2 d = texture2D(iChannel0, xy * px).xy;

	vec4 acc = vec4(0.0);
	for(int j = 0; j < oversamples; j++) {
		for(int k = 0; k < oversamples; k++) {
			// Starting point for this sample
			xy = fragCoord.xy + spacing * vec2(float(j) / (float(oversamples) + 1.0), float(k) / (float(oversamples) + 1.0));
			float dist = 0.0;
			// Walk along path by sampling vector image, moving, sampling, moving...
			for(float i = 0.0; i < 1.0; i++) {
				d = texture2D(iChannel0, xy * px).xy;
				if(length(d) == 0.0) {
					// No gradient at this point in the map, early out
					break;
				}
				xy += d * (blength * strength) + blength * strength * sidestep/1000.0 * vec2(-d.y, d.x) + (blength * strength /32.0);
				dist += length(d * (blength * strength));
			}
			// Sample iChannel1 image where our walk ended up
			acc.rgb += texture2D(iChannel1, xy * px).rgb;
			
			if ( output_matte )
			{
				// Sample matte image where our walk ended up
				acc.a += texture2D(iChannel3, xy * px).r;	
			}
			else
			{
				// Length we've travelled to the matte output  
				acc.a += dist * (blength * strength / 32.0);	
			}

		}
	}
	acc /= float(oversamples * oversamples);

	fragColor = acc; 
}
