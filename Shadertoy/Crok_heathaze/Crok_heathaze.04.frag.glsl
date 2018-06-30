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
// iChannel0: pass3_result, filter = linear,wrap=clamp
// iChannel1: displace_map, filter = linear,wrap=clamp
// BBox: iChannel0

// Pass 1: make the  low frequency vectors
// lewis@lewissaunders.com


uniform bool external_matte = false; // External matte : (use an external matte instead of the internal matte for the displacement)

const float ksize = 1.0;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 xy = fragCoord.xy;

	// Factor to convert pixels to [0,1] texture coords
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);
	vec2 d = vec2(0.0);

	if ( external_matte )
	{
		// Convolve by x and y Sobel matrices to get gradient vector
		d.x  =  1.0 * texture2D(iChannel1, (xy + ksize * vec2(-1.0, -1.0)) * px).g;
		d.x +=  2.0 * texture2D(iChannel1, (xy + ksize * vec2(-1.0,  0.0)) * px).g;
		d.x +=  1.0 * texture2D(iChannel1, (xy + ksize * vec2(-1.0, +1.0)) * px).g;
		d.x += -1.0 * texture2D(iChannel1, (xy + ksize * vec2(+1.0, -1.0)) * px).g;
		d.x += -2.0 * texture2D(iChannel1, (xy + ksize * vec2(+1.0,  0.0)) * px).g;
		d.x += -1.0 * texture2D(iChannel1, (xy + ksize * vec2(+1.0, +1.0)) * px).g;
		d.y +=  1.0 * texture2D(iChannel1, (xy + ksize * vec2(-1.0, -1.0)) * px).g;
		d.y +=  2.0 * texture2D(iChannel1, (xy + ksize * vec2( 0.0, -1.0)) * px).g;
		d.y +=  1.0 * texture2D(iChannel1, (xy + ksize * vec2(+1.0, -1.0)) * px).g;
		d.y += -1.0 * texture2D(iChannel1, (xy + ksize * vec2(-1.0, +1.0)) * px).g;
		d.y += -2.0 * texture2D(iChannel1, (xy + ksize * vec2( 0.0, +1.0)) * px).g;
		d.y += -1.0 * texture2D(iChannel1, (xy + ksize * vec2(+1.0, +1.0)) * px).g;
	}	
	else
	{
		d.x  =  1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, -1.0)) * px).g;
		d.x +=  2.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0,  0.0)) * px).g;
		d.x +=  1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, +1.0)) * px).g;
		d.x += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, -1.0)) * px).g;
		d.x += -2.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0,  0.0)) * px).g;
		d.x += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, +1.0)) * px).g;
		d.y +=  1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, -1.0)) * px).g;
		d.y +=  2.0 * texture2D(iChannel0, (xy + ksize * vec2( 0.0, -1.0)) * px).g;
		d.y +=  1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, -1.0)) * px).g;
		d.y += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, +1.0)) * px).g;
		d.y += -2.0 * texture2D(iChannel0, (xy + ksize * vec2( 0.0, +1.0)) * px).g;
		d.y += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, +1.0)) * px).g;
		
	}
		// Convolve by x and y Sobel matrices to get gradient vector
	
	// Bit of a bodge factor right here
	d *= 32.0 / ksize;

	// Output vectors for second pass
	fragColor = vec4(d.x, d.y, 0.0, 1.0);
}
