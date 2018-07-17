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
// Code original : y_blurs Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_blurs Matchbox for Autodesk Flame


// iChannel0: result_pass3,filter=linear,wrap=clamp
// iChannel1: Strength,filter=linear,wrap=clamp
// BBox: iChannel0


// Change the folling 4 lines to suite
#define STRENGTH adsk_results_pass2
#define VERTICAL 
#define STRENGTH_CHANNEL 



#define PI 3.141592653589793238462643383279502884197969



#ifndef VERTICAL
	uniform float v_bias = 1.0; // Blur Y : (Set the vertical bias.), min=0.0, max=27000
	float bias = v_bias;
	const vec2 dir = vec2(0.0, 1.0);
#else
	uniform float h_bias = 1.0; // Blur X : (Set the horizontal bias.), min=0.0, max=27000
	float bias = h_bias;
	const vec2 dir = vec2(1.0, 0.0);
#endif

uniform float blur_amount = 0.0; // Blur : (Overall blur amount.), min=0.0, max=27000
uniform float blur_red = 1.0; // Red Bias : (Set the bias for the red channel.), min=0.0, max=27000
uniform float blur_green = 1.0; // Green Bias : (Set the bias for the green channel.), min=0.0, max=27000
uniform float blur_blue = 1.0; // Blue Bias : (Set the bias for the blue channel.), min=0.0, max=27000
float blur_matte = 1.0;


vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel  = vec2(1.0) / res;

vec4 gblur(vec2 fragCoord)
{
	 //The blur function is the work of Lewis Saunders.
	vec2 xy = fragCoord.xy;

	float strength = 1.0;

	//Optional texture used to weight amount of blur
	#ifdef STRENGTH_CHANNEL
		strength = texture2D(iChannel1, fragCoord.xy / res).a;
	#endif

	float br = blur_red * blur_amount * bias * strength;
	float bg = blur_green * blur_amount * bias * strength;
	float bb = blur_blue * blur_amount * bias * strength;
	float bm = blur_matte * blur_amount * bias * strength;

	float support = max(max(max(br, bg), bb), bm) * 3.0;

	vec4 sigmas = vec4(br, bg, bb, bm);
	sigmas = max(sigmas, 0.0001);

	vec4 gx, gy, gz;
	gx = 1.0 / (sqrt(2.0 * PI) * sigmas);
	gy = exp(-0.5 / (sigmas * sigmas));
	gz = gy * gy;

	vec4 a = gx * texture2D(iChannel0, xy * texel);
	vec4 energy = gx;
	gx *= gy;
	gy *= gz;

	for(float i = 1; i <= support; i++) {
        a += gx * texture2D(iChannel0, (xy - i * dir) * texel);
        a += gx * texture2D(iChannel0, (xy + i * dir) * texel);
		energy += 2.0 * gx;
		gx *= gy;
		gy *= gz;
	}

	a /= energy;

	return a;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	fragColor = gblur(fragCoord);
}
