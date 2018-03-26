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
// Code original : Ls_Ash Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Ash Matchbox for Autodesk Flame

// iChannel0: Source, filter = linear, wrap=clamp
// BBox: iChannel0

// Adaptive sharpening
// Pass 1: edge detection
// lewis@lewissaunders.com



uniform float ksize;
uniform float threshold = 0.13; // Edge threshold : (Increase to sharpen more edges), min=0.001, max=1.0



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 xy = fragCoord.xy;
	vec2 px = vec2(1.0) / vec2(iResolution.x, iResolution.y);

	vec4 orig = texture2D(iChannel0, xy * px);

	float ksize = 1.0;

	// Find gradients of iChannel0 with X/Y Sobel convolution
	vec2 d;
	d.x  =  1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, -1.0)) * px).g;
	d.x +=  2.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0,  0.0)) * px).g;
	d.x +=  1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, +1.0)) * px).g;
	d.x += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, -1.0)) * px).g;
	d.x += -2.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0,  0.0)) * px).g;
	d.x += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, +1.0)) * px).g;
	d.y  =  1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, -1.0)) * px).g;
	d.y +=  2.0 * texture2D(iChannel0, (xy + ksize * vec2( 0.0, -1.0)) * px).g;
	d.y +=  1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, -1.0)) * px).g;
	d.y += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(-1.0, +1.0)) * px).g;
	d.y += -2.0 * texture2D(iChannel0, (xy + ksize * vec2( 0.0, +1.0)) * px).g;
	d.y += -1.0 * texture2D(iChannel0, (xy + ksize * vec2(+1.0, +1.0)) * px).g;

	// Magnitude of gradients finds edges
	float mag = length(d);
	float edginess = mag;

	// Threshold removes minor edges
	edginess *= 1.0 - threshold;
	edginess -= threshold;

	fragColor = vec4(orig.r, orig.g, orig.b, edginess);
}
