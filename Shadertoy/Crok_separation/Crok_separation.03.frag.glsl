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
// Code original : crok_separation Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_separation Matchbox for Autodesk Flame


// iChannel0: Source, filter = linear, wrap = clamp
// iChannel1: pass2_result, filter = linear, wrap = clamp
// BBox: iChannel0


#extension GL_ARB_shader_texture_lod : enable



vec2 resolution = vec2(iResolution.x, iResolution.y);


uniform float contrast = 1.0; // Contrast : ,min=0.0, max=2.0
uniform bool toggle = false; // Output HighPass as RGB


vec3 linearLight( vec3 s, vec3 d )
{
	return 2.0 * s + d - 1.0;
}

vec3 subtract( vec3 s, vec3 d )
{
	return s - d;
}

vec3 linearDodge( vec3 s, vec3 d )
{
	return s + d;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y);
	
	// source
	vec3 scr = texture2D(iChannel0, uv).rgb;
	
	// blured source
	vec3 b_scr = texture2D(iChannel1, uv).rgb;
	
	vec3 c = vec3(0.0);
	vec3 fifty_p_grey = vec3(0.5);
	
	// suptract operation
	vec3 sub =  c + subtract(scr, b_scr);
	
	// linear dodge operation
	c =  c + linearDodge(sub, fifty_p_grey);
	
	// adjust contrast to 50%
	c = ( c * 0.5 + 0.25 ) * contrast;	
	
	// merge highpass ontop of the blured painted one
	//c =  linearLight(c, b_scr);
	
	fragColor = vec4(b_scr, c);
	
	if ( toggle == true )
		fragColor = vec4(c, c);
}