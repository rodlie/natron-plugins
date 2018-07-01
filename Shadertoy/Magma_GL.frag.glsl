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


uniform float Speed = 1.0; // Speed : (speed of noise)
uniform vec3 NoiseAnim = vec3(0, 0, 0); // Direction : (noise animation direction)
uniform float Zoom = 2.0; // Zoom : (zoom)

uniform float Noise = 1.0; // Noise : (detail of the noise structure)
uniform vec2 NoiseAmpFreq = vec2(5.0,1.0); // Noise amplitude / frequency : 


uniform int VolumeSteps = 20; // Volume steps : (volume steps)
uniform float StepSize = 0.25; // Step size : (step size)
uniform float Density = 0.15; // Density : (density)
uniform float Offset = 0.0; // Offset : (offset)
uniform float Detail = 1.0; // Detail : (detail)
uniform vec2 Aspect = vec2(1.0, 1.0);


uniform vec3 tint_col = vec3(3.8, 0.8, -0.8);
uniform float tint = 0.4; // Tint : (tint)
uniform vec3 SatBriContr = vec3 (0.0,1.0,2.0); // Sat-Brightness-Contrast : 
uniform vec3 LumCoeff = vec3(1.0, 0.0, 0.0); // Luminance Coeficient : (luminance Coeficient)


uniform vec3 co0 = vec3(1.1, 2.3, 0.8); // Color 1 : 
uniform vec3 co1 = vec3(2.1, 0.5, 0.5); // Color 2 : 
uniform vec3 co2 = vec3(0.0, 0.0, 0.0); // Color 3 : 
uniform vec3 co3 = vec3(1.5, -1.2, -1.3); // Color 4 : 
uniform vec3 co4 = vec3(3.0, 0.0, 0.0); // Color 5 : 





vec2 resolution = vec2(iResolution.x, iResolution.y);
float time = iTime *.02 * Speed + Offset;

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    return f;
}

float distanceFunc(vec3 p)
{	
	float d = length(p);	// distance to sphere
	d += fbm(p*NoiseAmpFreq.g + vec3(NoiseAnim.z, NoiseAnim.y, NoiseAnim.x)*time) * NoiseAmpFreq.r;
	return d;
}

vec4 gradient(float x)
{
	x=sin(x-time);

	vec4 c0 = vec4(co0, 0.1);	// yellow
	vec4 c1 = vec4(co1, 0.9);	// red
	vec4 c2 = vec4(co2, 0); 	// black
	vec4 c3 = vec4(co3, 0.2); 	// blue
	vec4 c4 = vec4(co4, 0); 	// black
	
	x = clamp(x, 0.0, 0.999);
	float t = fract(x*4.0);
	vec4 c;
	if (x < 0.25) {
		c =  mix(c0, c1, t);
	} else if (x < 0.5) {
		c = mix(c1, c2, t);
	} else if (x < 0.75) {
		c = mix(c2, c3, t);
	} else {
		c = mix(c3, c4, t);		
	}
	return c;
}

vec4 shade(float d)
{	
	vec4 c = gradient(d);
	return c;
}


vec4 volumeFunc(vec3 p)
{
	float d = distanceFunc(p);
	return shade(d);
}

vec4 rayMarch(vec3 rayOrigin, vec3 rayStep, out vec3 pos)
{
	vec4 sum = vec4(0, 0, 0, 0);
	pos = rayOrigin;
	for(int i=0; i<VolumeSteps; i++) {
		vec4 col = volumeFunc(pos);
		col.a *= Density;
		col.rgb *= col.a;
		sum = sum + col*(1.0 - sum.a);	
		pos += rayStep;
	}
	return sum;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 q = fragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
	
    float rotx = 0.0;
    float roty = 0.0;

    vec3 ro = Detail * normalize(vec3(cos(roty), cos(rotx), sin(roty)));
    vec3 ww = normalize(vec3(0.0,0.0,0.0) - ro);
    vec3 uu = Aspect.x * normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = Aspect.y * normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + ww * Zoom );

    ro += rd * Noise;
	
    vec3 hitPos;
    vec4 col = rayMarch(ro, rd*StepSize, hitPos);
    vec3 avg_lum = vec3(0.5, 0.5, 0.5);
    vec3 intensity = vec3(dot(col.rgb, LumCoeff));

    vec3 sat_color = mix(intensity, col.rgb, SatBriContr.r);
    vec3 con_color = mix(avg_lum, sat_color, SatBriContr.b);
	vec3 brt_color = con_color - 1.0 + SatBriContr.g;
	vec3 fin_color = mix(brt_color, brt_color * tint_col, tint);

    fragColor = vec4(fin_color, 1.0);
	}