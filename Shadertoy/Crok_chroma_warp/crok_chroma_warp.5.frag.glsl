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
// Code original : crok_chroma_warp Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_chroma_warp Matchbox for Autodesk Flame

// iChannel0: pass3_result, filter=linear, wrap=clamp
// iChannel1: pass4_result, filter=linear, wrap=clamp
// BBox: iChannel0



uniform float d_amount = 1.0; // Distorsion Amount : , min=0.0
uniform int num_iter = 48; // Iterations : , min=0, max=2048
uniform bool add_distortion = false; // Add Distorsion : 
uniform float off_chroma = 1.0; // Saturation : , min=0.0, max=1.0
vec2 center = iMouse.xy /iResolution.xy;

uniform float ca_amt; // Chroma Aberration Amount : 
uniform bool inv_dis_matte = false; // Invert Distort Matte : 



/*
vec2 barrelDistortion(vec2 coord, float amt, float d_str)
{
	vec2 cc = (((fragCoord.xy/iResolution.xy) - center ));
	float distortion = dot(cc * d_amount * .3 * d_str, cc);
	return coord + cc * distortion * -1.;
}
*/
vec2 barrelDistortion(vec2 coord, float amt, float d_str, vec2 fragCoord)
{
	vec2 cc = (((fragCoord.xy/iResolution.xy) - center ));
	float distortion = dot(cc * d_amount * .3 * d_str, cc);
	return mix( coord + cc * distortion * -1., coord + cc * distortion * -1. * amt, ca_amt) ;
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

vec4 spectrum_offset( float t ) {
	vec3 tmp;
	vec4 ret;
	float lo = step(t,0.5);
	float hi = 1.0-lo;
	float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
	tmp = vec3(lo,1.0,hi) * vec3(1.0-w, w, 1.0-w);
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 lum = vec3(dot(tmp, W));
	ret = vec4(tmp, lum.r);
	return pow( ret, vec4(1.0/2.2) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv=(fragCoord.xy/iResolution.xy);
	vec4 col = texture2D(iChannel1, uv);
	fragColor = col;
	if ( add_distortion )
	{
		vec4 sumcol = vec4(0.0);
		vec3 sumalpha = vec3(0.0);
		vec4 sumw = vec4(0.0);
		float dist_str = texture2D( iChannel0, uv).r;

		// invert chromatic abberration strength mate
		if ( inv_dis_matte )
			dist_str = 1.0 - dist_str;

		for ( int i=0; i<num_iter;++i )
		{
			float t = float(i) * (1.0 / float(num_iter));
			vec4 w_off = spectrum_offset( t );
			vec4 w_st = vec4(1.0);
			vec4 w = mix(w_st, w_off, off_chroma);
			sumw += w;
			sumcol += w * texture2D( iChannel1, barrelDistortion(uv, t, dist_str, fragCoord));
		}
		vec4 col = vec4(sumcol / sumw);
		fragColor = col;
	}
}
