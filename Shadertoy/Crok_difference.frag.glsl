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
// Code original : crok_difference Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_difference Matchbox for Autodesk Flame




uniform float red = 1.0; // Red : (red), min=-100, max=100
uniform float green= 1.0; // Green : (green), min=-100, max=100
uniform float blue= 1.0; // Blue : (blue), min=-100, max=100

uniform float minInput = 0.0; // MinInput : (min input), min=-100, max=100
uniform float minOutput = 0.0; // MinOutput : (min output), min=-100, max=100
uniform float maxInput = 1.0; // MaxInput : (max input), min=-100, max=100
uniform float maxOutput = 1.0; // MaxOutput : (max output), min=-100, max=100

uniform float brightness = 1.0; // Brightness : (brightness), min=-100, max=100
uniform float contrast = 1.0; // Contrast : (contrast), min=-100, max=100
uniform float gain = 1.0; // Gain : (gain), min=-100, max=100
uniform float gamma = 1.0; // Gamma : (gamma), min=-100, max=100

uniform bool clamping = false; // Clamp : (clamp alpha)
uniform bool invert = false; // Invert : (invert alpha)




const vec3 lumc = vec3(0.2125, 0.7154, 0.0721);

vec3 difference( vec3 s, vec3 d )
{
	return abs(d - s);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y);
	vec3 s = texture2D(iChannel0, uv).xyz;
	vec3 d = texture2D(iChannel1, uv).xyz;

	vec3 avg_lum = vec3(0.5, 0.5, 0.5);
	vec3 c_channels = vec3(red, green, blue);
	vec3 col = vec3(0.0);


	col = col + difference(s,d);

	col = mix(vec3(0.0), col, c_channels);
	
	col = vec3(max(max(col.r, col.g), col.b));
	col = vec3(dot(col.rgb, lumc));
	col = mix(avg_lum, col, contrast);
	col = col - 1.0 + brightness;
	col = col * gain;
	
    col = min(max(col - vec3(minInput), vec3(0.0)) / (vec3(maxInput) - vec3(minInput)), vec3(1.0));
    col = pow(col, vec3(gamma));
    col = mix(vec3(minOutput), vec3(maxOutput), col);
	

	if ( clamping )
		col = clamp(col, 0.0, 1.0);
	if ( invert )
	    col = 1.0 - col;
	
	fragColor = vec4(col, col);
}