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
// Code original : crok_digital_glitch Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_digital_glitch Matchbox for Autodesk Flame

// iChannel0: pass1_result, filter = nearest
// BBox: iChannel0



uniform float bias = 0.7; // Bias : , min=0.0, max=10.0
uniform float scale = 1.0; // Size : , min=0.01, max=10
uniform float rgb_offset = 5.0; // RGB offset : ,min=-10000, max=10000
uniform float opacity = 1.0; // Blend : ,min=0.0, max=1.0
uniform float l_threshold = 0.5; // Green lines : ,min=0.0, max=1000.0
uniform float b_threshold = 1.0; // Black and White : ,min=0.0, max=1000.0


uniform bool floyd_steinberg = true; // Enable floyd : 
uniform float bw_bias = 0.3; // BW bias : , min=0.0, max=10000
uniform float errorCarry = 0.4; // BW look : ,min=-10000, max=10000


uniform bool drunk_fx = false; // Enable drunk : 
uniform float drunk_bias = 0.5; // Drunk bias : ,min=0.0, max=10.0


uniform float g_noise;





vec2 resolution = vec2(iResolution.x, iResolution.y);

float time = iTime *.05;

const int lookupSize = 64;


float getGrayscale(vec2 coords)
{
	vec2 uv = coords / resolution.xy;
	vec3 sourcePixel = texture2D(iChannel0, uv).rgb;
	return length(sourcePixel*vec3(0.2126,0.7152,0.0722));
}


vec3 difference( vec3 s, vec3 d )
{
	return abs(d - s);
}

float rand2(vec2 co)
{
	return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 rand1(vec2 uv) {
	time = 1.0;
	vec2 c = ((.01)*resolution.x)*vec2(1.,(resolution.y/resolution.x));
	vec3 col = vec3(0.0);

   	float r = rand2(vec2((2.+time) * floor(uv.x*c.x)/c.x, (2.+time) * floor(uv.y*c.y)/c.y ));
   	float g = rand2(vec2((5.+time) * floor(uv.x*c.x)/c.x, (5.+time) * floor(uv.y*c.y)/c.y ));
   	float b = rand2(vec2((9.+time) * floor(uv.x*c.x)/c.x, (9.+time) * floor(uv.y*c.y)/c.y ));

	col = vec3(r,g,b);

	return col;
}


// Using Ashima's simplex noise
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}


float n_scale = clamp(rand2(vec2((time), (time) * floor(2.0)))* 5.0, 0.0, scale);
float n_g_noise = rand2(vec2((time), (5.+time) * floor(300.0))) * 3123.0;


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / resolution.xy;
	vec3 original = texture2D(iChannel0, uv).rgb;
	vec2 block = floor(fragCoord.xy / vec2(n_scale));
	vec2 uv_noise = block / vec2(n_g_noise);
	uv_noise += floor(vec2(time) * vec2(1234.0, 3543.0)) / vec2(64);
	vec3 d_noise = rand1(uv_noise);
	float block_thresh = pow(fract(time * 1236.0453), b_threshold);
	float line_thresh = pow(fract(time * 2236.0453), l_threshold);

	vec3 col = vec3(0.0);
	vec3 f_col = original;


	if ( floyd_steinberg )
	{
		float blend_bw_fx = snoise(vec2(iTime*100.0));
	    blend_bw_fx = clamp((blend_bw_fx-(1.0-bw_bias))*999999.0, 0.0, 1.0);

		float xError = 0.0;
		for(int xLook=0; xLook<lookupSize; xLook++)
		{
			float grayscale = getGrayscale(fragCoord.xy + vec2(-lookupSize+xLook,0));
			grayscale += xError;
			float bit = grayscale >= 0.5 ? 1.0 : 0.0;
			xError = (grayscale - bit)*errorCarry;
		}

		float yError = 0.0;
		for(int yLook=0; yLook<lookupSize; yLook++)
		{
			float grayscale = getGrayscale(fragCoord.xy + vec2(0,-lookupSize+yLook));
			grayscale += yError;
			float bit = grayscale >= 0.5 ? 1.0 : 0.0;
			yError = (grayscale - bit)*errorCarry;
		}

		float finalGrayscale = getGrayscale(fragCoord.xy);
		finalGrayscale += xError*0.5 + yError*0.5;
		float finalBit = finalGrayscale >= 0.5 ? 1.0 : 0.0;
		f_col = mix(original, vec3(finalBit), blend_bw_fx);
	}


	vec2 uv_r = uv, uv_g = uv, uv_b = uv;

	if (d_noise.r < block_thresh ||
		rand1(vec2(uv_noise.y, 0.0)).g < line_thresh)
	{
		vec2 dist = (fract(uv_noise) - 0.5) * 0.3;
		uv_r += dist * 0.01 * rgb_offset;
		uv_g += dist * 0.02 * rgb_offset;
		uv_b += dist * 0.0125 * rgb_offset;
	}
	fragColor.r = texture2D(iChannel0, uv_r).r;
	fragColor.g = texture2D(iChannel0, uv_g).g;
	fragColor.b = texture2D(iChannel0, uv_b).b;
	col = fragColor.rgb;

	//col = mix(fragColor.rgb, f_col, 1.0);

	if (d_noise.g < block_thresh)
		col.rgb = col.ggg;

	if (rand1(vec2(uv_noise.y, 0.0)).b * 3.5 < line_thresh)
		col.rgb = vec3(0.0, dot(col.rgb, vec3(1.0)), 0.0);

	if (d_noise.g * 1.5 < block_thresh ||
		rand1(vec2(uv_noise.y, 0.0)).g * 2.5 < line_thresh )
	{
		float line = fract(fragCoord.y / 3.0);
		vec3 mask = vec3(3.0, 0.0, 0.0);
		if (line > 0.333)
			mask = vec3(0.0, 3.0, 0.0);
		if (line > 0.666)
			mask = vec3(0.0, 0.0, 3.0);
		col = col.rgb * mask;
	}

  float blend = snoise(vec2(iTime*200.));
  blend = clamp((blend-(1.0-bias))*999999.0, 0.0, opacity);
	col = mix(f_col, col, blend);


	if ( drunk_fx )
	{
		float blend_drunk_fx = snoise(vec2(iTime*150.0));
	  blend_drunk_fx = clamp((blend_drunk_fx-(1.0-drunk_bias))*999999.0, 0.0, 1.0);
	  vec3 tc = texture2D(iChannel0,uv).rgb;
	  vec3 tl = texture2D(iChannel0, uv - vec2(sin(.05 *n_scale),0.)).rgb;
	  vec3 tR = texture2D(iChannel0,uv + vec2(sin(.082 *n_g_noise),0.)).rgb;
	  vec3 tD = texture2D(iChannel0,uv - vec2(0.,sin(0.03*n_scale))).rgb;
	  vec3 tU = texture2D(iChannel0,uv + vec2(0.,sin(0.02*n_g_noise))).rgb;
	  vec3 compo = (tc + tl + tR + tD + tU)/5.;
		col = mix(col, compo, blend_drunk_fx);
	}


	vec3 matte = difference( original, col );

	fragColor = vec4(col, matte);
}
