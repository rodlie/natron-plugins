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
// Code original : crok_nightvision Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : crok_nightvision Matchbox for Autodesk Flame
//
// iChannel0: pass4_result, filter=linear, wrap=clamp



uniform float chromatic_abb = 1.0; // Abberations : ,min=0.0, max=10000.0
uniform float d_amount = 0.3; // Distorsion : ,min=0.0, max=10000.0

vec2 center = vec2(0.5); // Center : 
int num_iter = 24; // Iterations : 

vec2 res = vec2(iResolution.x, iResolution.y);

vec2 barrelDistortion(vec2 coord, float amt, vec2 fragCoord) 
{
	
	vec2 cc = (fragCoord.xy/res.xy) - center;
	float distortion = dot(cc * d_amount * .3, cc);

	return coord + cc * distortion * -1. * amt;
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
	vec2 uv= fragCoord.xy/res.xy;
	vec3 sumcol = vec3(0.0);
	vec3 sumw = vec3(0.0);
		
	for ( int i=0; i<num_iter;++i )
	{
		float t = float(i) * (1.0 / float(num_iter));
		vec3 w = spectrum_offset( t );
		sumw += w;
		sumcol += w * texture2D( iChannel0, barrelDistortion(uv, chromatic_abb * t , fragCoord) ).rgb;
	}
	
	fragColor = vec4(sumcol.rgb / sumw,  1.0 );
}
