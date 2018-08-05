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
// Code original : crok_noise_blur Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_noise_blur Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest
// BBox: iChannel0

float myGlobalTime = iTime*.05;



uniform float p1 = 0.49; // Zoom : (zoom), min=0.0, max=10.0
uniform float p2 = 1.81; // Rotation : (rotation), min=0.0, max=5.0
uniform float p3 = 4.51; // Offset : (offset), min=0.0, max=5.0

uniform int iterations = 64; // Iterations : (iterations), min=2, max=4096

// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

float hash( float n )
{
    return fract(sin(n)*p3);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

vec2 map( vec2 p, vec2 fragCoord )
{
	p.x += 0.1*sin( myGlobalTime + 1.0*p.y ) ;
	p.y += 0.1*sin( myGlobalTime + 1.0*p.x ) ;
	
	float a = noise(p*1.5 + sin(0.1*myGlobalTime))*6.2831*p2;
	a -= myGlobalTime + fragCoord.x/iResolution.x;
	return vec2( cos(a), sin(a) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
    vec2 p = fragCoord.xy / iResolution.xy;
	vec2 uv = -1.0 + 2.0*p*p1;
	uv.x *= iResolution.x / iResolution.y;
		
	float acc = 0.0;
	vec3  col = vec3(0.0);
	for( int i=0; i<iterations; i++ )
	{
		vec2 dir = map( uv , fragCoord );
		
		float h = float(i)/iterations;
		float w = 4.0*h*(1.0-h);
		
		vec3 ttt = w*texture2D( iChannel0, uv ).xyz;
		ttt *= mix( vec3(0.6,0.7,0.7), vec3(1.0,0.95,0.9), 0.5 - 0.5*dot( reflect(vec3(dir,0.0), vec3(1.0,0.0,0.0)).xy, vec2(0.707) ) );
		col += w*ttt;
		acc += w;
		
		uv += 0.008*dir;
	}
	col /= acc;
    
	float gg = dot( col, vec3(0.333) );
	vec3 nor = normalize( vec3( dFdx(gg), 0.5, dFdy(gg) ) );
	col += vec3(0.4)*dot( nor, vec3(0.7,0.01,0.7) );

	vec2 di = map( uv , fragCoord);
	col *= 0.65 + 0.35*dot( di, vec2(0.707) );
	col *= 0.20 + 0.80*pow( 4.0*p.x*(1.0-p.x), 0.1 );
	col *= 1.7;

	fragColor = vec4( col, 1.0 );
}

