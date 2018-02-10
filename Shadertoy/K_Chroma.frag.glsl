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
//                 MM.  .MMM            	   M        MMM.  .MM
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
// Code original : K_Chroma v1.1 Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : K_Chroma v1.1 Matchbox for Autodesk Flame

// Shader written by:   Kyle Obley (kyle.obley@gmail.com) & Ivar Beer
// Shader adapted from: https://www.shadertoy.com/view/XssGz8
//


// iChannel0: Source, filter = linear
// BBox: iChannel0



uniform float chromatic_abb = 0; // chromatic abberation : (chromatic abberation), min=0., max=100.
uniform int num_iter = 15; // iterations : (iterations), min=3., max=200.

uniform float d_amount; // distorsion amount : (distorsion amount), min=0., max=100.
uniform bool add_distortion;
uniform vec2 center =vec2(0.5,0.5);



vec2 barrelDistortion(vec2 coord, float amt) {
	
	vec2 cc = (((gl_FragCoord.xy/iResolution.xy) - center ));
	float distortion = dot(cc * d_amount * .3, cc);

    if ( add_distortion )
		return coord + cc * distortion * -1. * amt;
	else
		return coord + cc * amt * -.05;
}

float sat( float t )
{
	return clamp( t, 0.0, 1.0 );
}

float linterp( float t ) {
	return sat( 1.0 - abs( 2.0*t - 1.0 ) );
}

float remap( float t, float a, float b ) {
	return sat( (t - a) / (b - a) );
}

vec3 spectrum_offset( float t ) {
	vec3 ret;
	float lo = step(t,0.5);
	float hi = 1.0-lo;
	float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
	ret = vec3(lo,1.0,hi) * vec3(1.0-w, w, 1.0-w);

	return pow( ret, vec3(1.0/2.2) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{	
	vec2 uv=fragCoord.xy / iResolution.xy;
	vec3 sumcol = vec3(0.0);
	vec3 sumw = vec3(0.0);	
	for ( int i=0; i<num_iter;++i )
	{
		float t = float(i) * (1.0 / float(num_iter));
		vec3 w = spectrum_offset( t );
		sumw += w;
		sumcol += w * texture2D( iChannel0, barrelDistortion(uv, chromatic_abb * t ) ).rgb;
	}
		
	fragColor = vec4(sumcol.rgb / sumw, 1.0);
}