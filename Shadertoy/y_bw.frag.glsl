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
// Code original : y_bw pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_bw for Autodesk Flame


// iChannel0: Source,filter=nearest,wrap=clamp
// iChannel1: Mask,filter=nearest,wrap=clamp
// BBox: iChannel1



uniform float red_mix = 1.0;     // Red :     (red mix), min=0.0, max=1.0
uniform float green_mix = 1.0;   // Green :   (green mix), min=0.0, max=1.0
uniform float blue_mix = 1.0;    // Blue :    (blue mix), min=0.0, max=1.0
uniform float cyan_mix = 1.0;    // Cyan :    (cyan mix), min=0.0, max=1.0
uniform float magenta_mix = 1.0; // Magenta : (magenta mix), min=0.0, max=1.0
uniform float yellow_mix = 1.0;  // Yellow :  (yellow mix), min=0.0, max=1.0
uniform float orange_mix = 1.0;  // Orange :  (orange mix), min=0.0, max=1.0
uniform float purple_mix = 1.0;  // Purple :  (purple mix), min=0.0, max=1.0

uniform float rt = 1.0; // Red Threshold :     (red threshold), min=0.0, max=10.0
uniform float gt = 1.0; // Green Threshold :   (green threshold), min=0.0, max=10.0
uniform float bt = 1.0; // Blue Threshold :    (blue threshold), min=0.0, max=10.0
uniform float ct = 1.0; // Cyan Threshold :    (cyan threshold), min=0.0, max=10.0
uniform float mt = 1.0; // Magenta Threshold : (magenta threshold), min=0.0, max=10.0
uniform float yt = 1.0; // Yellow Threshold :  (yellow threshold), min=0.0, max=10.0
uniform float ot = 1.0; // Orange Threshold :  (orange threshold), min=0.0, max=10.0
uniform float pt = 1.0; // Purple Threshold :  (purple threshold), min=0.0, max=10.0

uniform float sat = 1.0; // Saturation Boost : (Toggle on a matte from a given color. Useful for dialing in the matte's threshold.)
uniform int matte_out; // Matte Output : (Toggle on a matte from a given color. Useful for dialing in the matte's threshold.), min=0, max=8



vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;

vec3 rgb2hsv( vec3 c )
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb( vec3 c )
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float getLuminance( vec3 rgb )
{
	return dot(rgb, vec3(0.299, 0.587, 0.114));
}

vec2 rotate(vec2 uv, float aa)
{
	float a = radians(aa);

	mat2 rotationMatrice = mat2( cos(-a), -sin(-a),
                          sin(-a), cos(-a) );

	return uv * rotationMatrice;
}

vec3 to_yuv(vec3 col)
{
	mat3 yuv = mat3
	(
		.2126, .7152, .0722,
		-.09991, -.33609, .436,
		.615, -.55861, -.05639
	);

	return col * yuv;
}

vec3 to_rgb(vec3 col)
{
	mat3 rgb = mat3
	(
		1.0, 0.0, 1.28033,
		1.0, -.21482, -.38059,
		1.0, 2.12798, 0.0
	);
	return col * rgb;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec3 front = texture2D(iChannel0, st).rgb;
	float alpha = texture2D(iChannel0, st).a;
	float bw_front = getLuminance(front);

	front = mix(vec3(bw_front), front, sat);

	vec3 yuv_front = to_yuv(front);
	float yuv_front_sum = yuv_front.g + yuv_front.b;
	vec3 hsv_front = rgb2hsv(front);

	float i_matte = texture2D(iChannel1, st).a;

	vec3 invfront = yuv_front;
	invfront.gb = rotate(invfront.gb, 180);
	invfront = to_rgb(invfront);

	vec3 red = vec3(1.0, 0.0, 0.0);
	vec3 green = vec3(0.0, 1.0, 0.0);
	vec3 blue = vec3(0.0, 0.0, 1.0);
	vec3 cyan = vec3(1.0 - red);
	vec3 magenta = vec3(1.0 - green);
	vec3 yellow = vec3(1.0 - blue);
	vec3 orange = vec3(1.0, .5, 0);
	//orange = vec3(.631, .471, .378);
	vec3 purple = vec3(.5, .0, .5);

	float comp = bw_front;
	float m = 0.0;
	float c = 0.0;
	float t = .5;
	float o_m = i_matte;

	vec3 yuv = to_yuv(red);
	float ysum = yuv.g + yuv.b;
	float matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, rt);

	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * red_mix, matte);

	if (matte_out == 1) {
		o_m = matte;
	}

	yuv = to_yuv(orange);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, ot);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * orange_mix, matte);

	if (matte_out == 2) {
		o_m = matte;
	}

	yuv = to_yuv(yellow);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, yt);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * yellow_mix, matte);

	if (matte_out == 3) {
		o_m = matte;
	}

	yuv = to_yuv(green);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, gt);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * green_mix, matte);

	if (matte_out == 4) {
		o_m = matte;
	}

	yuv = to_yuv(cyan);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, ct);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * cyan_mix, matte);

	if (matte_out == 5) {
		o_m = matte;
	}

	yuv = to_yuv(blue);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, bt);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * blue_mix, matte);

	if (matte_out == 6) {
		o_m = matte;
	}

	yuv = to_yuv(purple);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, pt);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * purple_mix, matte);

	if (matte_out == 7) {
		o_m = matte;
	}

	yuv = to_yuv(magenta);
	ysum = yuv.g + yuv.b;
	matte = 1.0 - abs(yuv_front_sum - ysum);
	matte = pow(matte, mt);
	matte = clamp(matte, 0.0, 1.0);
	comp = mix(comp, comp * magenta_mix, matte);

	if (matte_out == 8) {
		o_m = matte;
	}

	vec3 out_col = vec3(comp);

	out_col = mix(front, out_col, i_matte);

	//out_col = lr;
	//out_col = smoothstep(.5, 1.0, lr);
	//out_col = lr / 100 * red_mix;

	fragColor= vec4(out_col, o_m);
}
