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


// iChannel0: result_pass1,filter=linear,wrap=clamp
// iChannel1: result_pass4,filter=linear,wrap=clamp
// iChannel2: result_pass2,filter=linear,wrap=clamp
// BBox: iChannel0



// Change the folling 4 lines to suite
#define STRENGTH adsk_results_pass2
//#define VERTICAL 
#define STRENGTH_CHANNEL 




uniform bool keep_inside = true; // Constrain Blur to Matte : (Blur only the pixels that reside inside the area of the matte.)
uniform int i_colorspace = 0; // Colorspace : (Working colorspace. Set this to the current working colorspace. This insures a linear blur (no dark edges).), min=0, max=4





#define PI 3.141592653589793238462643383279502884197969

#ifdef STRENGTH_CHANNEL
	uniform sampler2D STRENGTH;
#endif

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
		strength = texture2D(iChannel2, fragCoord.xy / res).a;
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

	vec4 a = gx * texture2D(iChannel1, xy * texel);
	vec4 energy = gx;
	gx *= gy;
	gy *= gz;

	for(float i = 1; i <= support; i++) {
        a += gx * texture2D(iChannel1, (xy - i * dir) * texel);
        a += gx * texture2D(iChannel1, (xy + i * dir) * texel);
		energy += 2.0 * gx;
		gx *= gy;
		gy *= gz;
	}

	a /= energy;

	return a;
}

vec3 adjust_cgamma(vec3 col, float gamma)
{
    if (col.r >= 0.0) {
        col.r = pow(col.r, 1.0 / gamma);
    }

    if (col.g >= 0.0) {
        col.g = pow(col.g, 1.0 / gamma);
    }

    if (col.b >= 0.0) {
        col.b = pow(col.b, 1.0 / gamma);
    }

    return col;
}


vec3 to_rec709(vec3 col)
{
    if (col.r < .018) {
        col.r *= 4.5;
    } else if (col.r >= 0.0) {
        col.r = (1.099 * pow(col.r, .45)) - .099;
    }

    if (col.g < .018) {
        col.g *= 4.5;
    } else if (col.g >= 0.0) {
        col.g = (1.099 * pow(col.g, .45)) - .099;
    }

    if (col.b < .018) {
        col.b *= 4.5;
    } else if (col.b >= 0.0) {
        col.b = (1.099 * pow(col.b, .45)) - .099;
    }


    return col;
}

vec3 to_sRGB(vec3 col)
{
    if (col.r >= 0.0) {
        col.r = (1.055 * pow(col.r, 1.0 / 2.4)) - .055;
    }

    if (col.g >= 0.0) {
        col.g = (1.055 * pow(col.g, 1.0 / 2.4)) - .055;
    }

    if (col.b >= 0.0) {
        col.b = (1.055 * pow(col.b, 1.0 / 2.4)) - .055;
    }

    return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )

{
	vec2 st = fragCoord.xy / res;
	vec4 front = texture2D(iChannel0, st);
	vec4 blur = gblur(fragCoord);

	float matte = front.a;

	blur.rgb /= max(blur.a, .0001);

	if (! keep_inside) {
		matte = blur.a;
	}

	matte = clamp(matte, 0.0, 1.0);

	vec4 comp = mix(front, blur, matte);

	if (i_colorspace == 0) {
        comp.rgb = to_rec709(comp.rgb);
    } else if (i_colorspace == 1) {
        comp.rgb = to_sRGB(comp.rgb);
    } else if (i_colorspace == 2) {
        //linear
    } else if (i_colorspace == 3) {
        comp.rgb = adjust_cgamma(comp.rgb, 2.2);
    } else if (i_colorspace == 4) {
        comp.rgb = adjust_cgamma(comp.rgb, 1.8);
    }

	fragColor = vec4(comp.rgb, matte);
}
