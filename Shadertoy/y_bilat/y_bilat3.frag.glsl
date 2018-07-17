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
// Code original : y_bilat pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_bilat for Autodesk Flame


// iChannel0: result_pass1,filter=linear,wrap=clamp
// iChannel1: result_pass2,filter=linear,wrap=clamp
// BBox: iChannel0


#define luma(col) dot(col, vec3(0.2126, 0.7152, 0.0722))
#define PI 3.141592653589793238462643383279502884197969


vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;

#define max_detail 11


uniform int samples = 10; // Samples : (Samples.), min=1, max=50
uniform float amount = 5.0; // Strength : (Strength.),min=1.0, max=10.0
uniform int detail = 1; //Detail : (Detail.), min=1, max=10

float normpdf(float x, float sigma)
{
	return .39894 * exp(-.5 * x * x / (sigma * sigma)) / sigma;
}

float normpdf3(vec3 v, float sigma)
{
	return .39894 * exp(-.5 * dot(v, v) / (sigma * sigma)) / sigma;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec4 front = texture2D(iChannel1, st);
	vec3 orig = texture2D(iChannel0, st).rgb;
	int kernel_size = (samples - 1) / 2;
	float kernel[100];


	for (int i = 0 ; i <= kernel_size; ++i) {
		kernel[kernel_size + i] = kernel[kernel_size - i] = normpdf(float(i), amount);
	}

	float bsigma = (max_detail - detail) * .01;
	vec4 out_col = vec4(0.0);
	vec4 cc = vec4(0.0);
	float factor;
	float Z = 0.0;
	float bZ = 1.0 / normpdf(0.0, bsigma);

	for (int i = -kernel_size ; i <= kernel_size; ++i) {
		for (int j = -kernel_size ; j <= kernel_size; ++j) {
			cc = texture2D(iChannel1, st + vec2(float(i), float(j)) * texel);
			factor = normpdf3(cc.rgb - front.rgb, bsigma) * bZ * kernel[kernel_size + j] * kernel[kernel_size + i];
			Z += factor;
			out_col += factor * cc;
		}
	}

	out_col /= vec4(Z);

	out_col.rgb /= max(vec3(out_col.a), .0001);

	out_col.rgb = mix(orig, out_col.rgb, out_col.a);

	fragColor = out_col;
}
