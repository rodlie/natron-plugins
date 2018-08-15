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

// iChannel0: pass1_result, filter=linear, wrap=repeat
// iChannel1: pass2_result, filter=linear, wrap=repeat
// BBox: iChannel0



uniform float chromatic_abb = 1.0; // Chroma Aberration Amount : , min=0.0
uniform int num_iter = 48; // Iterations : , min=0, max=2048
uniform bool add_distortion = false; // Invert Distort Matte : 
uniform float off_chroma = 1.0; // Saturation : , min=0.0, max=1.0
vec2 center = iMouse.xy /iResolution.xy;

uniform bool inv_ca_matte = false; // Invert C.A. Matte : 



vec2 barrelDistortion(vec2 coord, float amt, vec2 fragCoord)
{
	vec2 cc = (((fragCoord.xy/iResolution.xy) - center ));
	float distortion = dot(cc * .3, cc);
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
	vec4 sumcol = vec4(0.0);
	vec3 sumalpha = vec3(0.0);
	vec4 sumw = vec4(0.0);
	vec4 front = texture2D(iChannel0, uv);
	float ca_str = texture2D( iChannel1, uv).r;

	// invert chromatic abberration strength mate
	if ( inv_ca_matte )
		ca_str = 1.0 - ca_str;

	for ( int i=0; i<num_iter;++i )
	{
		float t = float(i) * (1.0 / float(num_iter));
		vec4 w_off = spectrum_offset( t );
		vec4 w_st = vec4(1.0);
		vec4 w = mix(w_st, w_off, off_chroma);
		sumw += w;
		sumcol += w * texture2D( iChannel0, barrelDistortion(uv, chromatic_abb * t * ca_str, fragCoord));
	}

	vec4 col = vec4(sumcol / sumw);

	col.rgb = col.rgb + front.rgb * (1.0 - col.a);

	fragColor = col;
}
