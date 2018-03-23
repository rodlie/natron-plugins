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
// iChannel0: Map, filter = linear, wrap=clamp
// BBox: iChannel0

// Pass 1: make the vectors
// lewis@lewissaunders.com
// TODO:
//  o Pre-blur input in case of kinks?




uniform float ksize = 0.5; // Sobel kernel size : (Size of Sobel kernels used to detect gradients; increase to remove artifacts at the expense of accuracy), min=0.5, max=1024

uniform bool radial = fasle; // Rotate 90 : (Blur into and out of the contours instead of along the edges.)
uniform bool directvectors = false; // Use map as vectors directly : (Enable to use the map input red and green channels as XY vectors directly, instead of calulating gradients.)





void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;

	// Factor to convert pixels to [0,1] texture coords
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	vec2 d = vec2(0.0);

	if(directvectors == true) {
		// iChannel0 input is already vectors, yay!
		d = texture2D(iChannel0, xy * px).xy;
		if(radial) {
			// Rotate 90 degrees
			d = vec2(-d.y, d.x);
		}
		fragColor = vec4(d.x, d.y, 0.0, 1.0);
		return;
	}

	// Convolve by x and y Sobel matrices to get gradient vector
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

	if(!radial) {
		// Rotate 90 degrees
		d = vec2(-d.y, d.x);
	}

	// Bit of a bodge factor right here
	d *= 32.0 / ksize;

	// Output vectors for second pass
	fragColor = vec4(d.x, d.y, 0.0, 1.0);
}
