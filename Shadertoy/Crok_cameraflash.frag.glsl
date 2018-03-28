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
// Code original : crok_cameraflash Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_cameraflash Matchbox for Autodesk Flame



// rakesh@picovico.com : www.picovico.com
// http://glsl.heroku.com/e#15514.0

uniform int bubbles = 25; // Density : , min=1, max=1000
uniform float Seed = 12.16; // Seed : ,min=0.0, max=10000
uniform float bias = 1.5; // Flickering : ,min=1.0, max=2.0
uniform float b_size = 2.0; // Size : ,min=0.0, max=100.0



vec2 resolution = vec2(iResolution.x, iResolution.y);
float time = iTime*.05 * -25.;

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

  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);

  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float Random ( float x )
{
	return fract( sin( ((x) - 1.45) / 0.25 ) * 9999. );
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = (fragCoord.xy / resolution.xy) - 0.5;
	uv.x *=  resolution.x / resolution.y;
	
	vec2 uv2 = uv;
	
    uv.x += Random( floor (time * .11));
    uv.y += Random( floor (time * .11));
	
    uv2.x += Random( floor ((time +9.) * .1));
    uv2.y += Random( floor ((time +3.) * .1));
	
	vec3 color = vec3(0.0);

    // bubbles
	for( int i=0; i<bubbles; i++ )
	{
		vec3 col = vec3(1.0); 
		
        // bubble seeds
		float pha = sin(float(i)*5.13+1.0)*0.5 + 0.5;
		float siz = sin(float(i)*1.74+5.0)*0.5+ Seed+3.;
		
		
		float pox = sin(float(i)*3.55+4.1) * resolution.x / resolution.y;
		
        // buble size, position and color
		float rad = b_size * 0.01;
		vec2  pos1 = vec2( pox+sin(siz), -1.0-rad + (2.0+2.0*rad)*mod(pha*(0.2+0.8),1.0)) * vec2(1.0, 1.0);
		float dis1 = length( uv - pos1 );
		vec2  pos2 = vec2( pox+sin(siz), -1.0-rad + (2.0+2.0*rad)*mod(pha*(0.2+0.8),1.0)) * vec2(1.0, 1.0);
		float dis2 = length( uv2 - pos2 );
       
	    // render
		color += col.xyy *(1.- smoothstep( rad*((0.2)*sin(time)), rad, dis1 )) * (1.0 - cos(pox * time));
		color += col.xzz *(1.- smoothstep( rad*((0.26)*sin(time)), rad, dis2 )) * (1.0 - cos(pox * time));
		
		
	}
	vec3 col = color;
	float blend1 = snoise(vec2(iTime));
    blend1 = clamp((blend1-(1.0-bias)), 0.0, 1.0);
	vec3 col1 = mix(vec3(0.0), col, blend1);

	fragColor = vec4(col1,1.0);
}