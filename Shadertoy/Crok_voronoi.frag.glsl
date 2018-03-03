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
// Adaptation pour Natron par F. Fernandez
// Code original : crok_voronoi Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_voronoi Matchbox for Autodesk Flame

// Voronoi noises
// by Pietro De Nicola
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.


uniform float Speed = 1.0; // speed :, min=0, max=100.
uniform float Offset = 0.0; // offset :, min=0.0, max=100.
uniform int Type = 5; // type :, min=0, max=63.
uniform int Octaves = 1; // octaves :, min=1, max=10.
uniform float Zoom = 8.0; // zoom :, min=0.1, max=100.
uniform float Detail = 2.0; // detail :, min=0.1, max=100.


float iGT = iTime *.05 * Speed + Offset;


float t = float(Type);

//
// the following parameters identify the voronoi you're watching
//
float function 			= mod(t,4.0);
bool  multiply_by_F1	= mod(t,8.0)  >= 4.0;
bool  inverse			= mod(t,16.0) >= 8.0;
float distance_type		= mod(t/16.0,4.0);



vec2 hash( vec2 p )
{
    p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) );
	return fract(sin(p)*43758.5453);
}

float voronoi( in vec2 x )
{
    vec2 n = floor( x );
    vec2 f = fract( x );

	float F1 = 8.0;
	float F2 = 8.0;
	
	
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 g = vec2(i,j);
        vec2 o = hash( n + g );

        o = 0.5 + 0.5*sin( iGT + 6.2831*o ); // animate

		vec2 r = g - f + o;

		float d = 	distance_type < 1.0 ? dot(r,r)  :				// euclidean^2
				  	distance_type < 2.0 ? sqrt(dot(r,r)) :			// euclidean
					distance_type < 3.0 ? abs(r.x) + abs(r.y) :		// manhattan
					distance_type < 4.0 ? max(abs(r.x), abs(r.y)) :	// chebyshev
					0.0;

		if( d<F1 ) 
		{ 
			F2 = F1; 
			F1 = d; 
		}
		else if( d<F2 ) 
		{
			F2 = d;
		}
    }
	
	float c = function < 1.0 ? F1 : 
			  function < 2.0 ? F2 : 
			  function < 3.0 ? F2-F1 :
			  function < 4.0 ? (F1+F2)/2.0 : 
			  0.0;
		
	if( multiply_by_F1 )	c *= F1;
	if( inverse )			c = 1.0 - c;
	
    return c;
}

float fbm( in vec2 p )
{
	float s = 0.0;
	float m = 0.0;
	float a = 0.5;
	
	for( int i=0; i<Octaves; i++ )
	{
		s += a * voronoi(p);
		m += a;
		a *= 0.5;
		p *= Detail;
	}
	return s/m;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = fragCoord.xy / iResolution.xy;
	vec2 center = (2.0*(p-.5));
    float c = fbm( Zoom * center );
	
    fragColor = vec4( c,c,c, 1.0 );
}