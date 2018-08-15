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
// Code original : y_hue_ops pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_hue_ops for Autodesk Flame


// iChannel0: Source,filter=nearest, wrap=clamp
// iChannel1: Mask,filter=nearest, wrap=clamp
// BBox: iChannel0


#define PI 3.141592653589793238462643383279502884197969

vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;



uniform float angle;

uniform vec3 rgb_angle = vec3( 0.0 , 0.0 , 0.0 ); // RGB Angle : (Rotate the hue.)
uniform vec3 rgb_sat = vec3( 1.0 , 1.0 , 1.0 ); // RGB Saturation : (Adjust the saturation.)
uniform vec3 rgb_range = vec3( 1.0 , 1.0 , 1.0 ); // RGB Range : (Adjust the range that is to be effected.)

uniform vec4 cmyo_angle = vec4(  0.0 , 0.0 , 0.0 , 0.0 ); // CMYO Angle : (Rotate the hue.)
uniform vec4 cmyo_sat = vec4( 1.0 , 1.0 , 1.0 , 1.0 ); // CMYO Saturation : (Adjust the saturation.)
uniform vec4 cmyo_range = vec4( 1.0 , 1.0 , 1.0 , 1.0 ); // CMYO Range : (Adjust the range that is to be effected.)

uniform bool yuv = false; // Output YUV : (Output a YUV version of the image.)
uniform int matte_out = 0; // Matte Out : , min=0, max=7

uniform int channelSelect = 3; // Channel : ,min=0, max=3


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

float diff(vec3 a, vec3 b, float f)
{
	vec2 q = a.gb;
	vec2 r = b.gb;

	q = normalize(q);
	r = normalize(r);

	float angle = acos(dot(q, r)) / PI;
	float falloff = pow(1.0 - angle, f);

	return clamp(falloff, 0.0, 1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec3 front = texture2D(iChannel0, st).rgb;
	float matte = texture2D(iChannel1, st).a;

	if (channelSelect == 0)
	{
		matte = texture2D(iChannel1, st).r;
	}

	if (channelSelect == 1)
	{
		matte = texture2D(iChannel1, st).g;
	}

	if (channelSelect == 2)
	{
		matte = texture2D(iChannel1, st).b;
	}

	front = to_yuv(front);
	vec3 orig = front;

	vec2 uv = front.gb;
	float y = front.r;
	float u = front.g;
	float v = front.b;

	vec3 red = (vec3(y, -.09985, .61465) );
	vec3 green = (vec3(y, -.33594, -.55859) );
	vec3 blue = (vec3(y, .43579, -.05637) );
	vec3 cyan = (vec3(y, .09985, -.61475) );
	vec3 magenta = (vec3(y, .33594, .55859) );
	vec3 yellow = (vec3(y, -.43579, .05637) );
	vec3 orange = (vec3(y, -.31787, .64307) );

	float r_d = diff(red, front, rgb_range.r);
	front.gb = mix(front.gb, rotate(front.gb, rgb_angle.r) * vec2(rgb_sat.r), r_d);

	float g_d = diff(green, front, rgb_range.g);
	front.gb = mix(front.gb, rotate(front.gb, rgb_angle.g) * vec2(rgb_sat.g), g_d);

	float b_d = diff(blue, front, rgb_range.b);
	front.gb = mix(front.gb, rotate(front.gb, rgb_angle.b) * vec2(rgb_sat.b), b_d);

	float c_d = diff(cyan, front, cmyo_range.r);
	front.gb = mix(front.gb, rotate(front.gb, cmyo_angle.r) * vec2(cmyo_sat.r), c_d);

	float m_d = diff(magenta, front, cmyo_range.g);
	front.gb = mix(front.gb, rotate(front.gb, cmyo_angle.g) * vec2(cmyo_sat.g), m_d);

	float y_d = diff(yellow, front, cmyo_range.b);
	front.gb = mix(front.gb, rotate(front.gb, cmyo_angle.b) * vec2(cmyo_sat.b), y_d);

	float o_d = diff(orange, front, cmyo_range.a);
	front.gb = mix(front.gb, rotate(front.gb, cmyo_angle.a) * vec2(cmyo_sat.a), o_d);

	if (! yuv) {
		front = to_rgb(front);
		orig = to_rgb(orig);
	}

	front = mix(orig, front, matte);

	if (matte_out == 1) {
		matte = r_d;
	} else if (matte_out == 2) {
		matte = g_d;
	} else if (matte_out == 3) {
		matte = b_d;
	} else if (matte_out == 4) {
		matte = c_d;
	} else if (matte_out == 5) {
		matte = m_d;
	} else if (matte_out == 6) {
		matte = y_d;
	} else if (matte_out == 7) {
		matte = o_d;
	}


	fragColor = vec4(front, matte);
}
