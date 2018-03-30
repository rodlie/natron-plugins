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
// iChannel0: pass3_result, filter=linear, wrap=clamp



vec2 resolution = vec2(iResolution.x, iResolution.y);

uniform float amount = 1.0; // Amount : ,min=0.0, max=100.0
uniform float Exposure = 1.0; // Exposure : ,min=0.0, max=100.0

uniform float brightness = 1.0; // Brightness : ,min=0.0, max=100.0
uniform float contrast = 1.0; // Contrast : ,min=0.0, max=10.0
uniform float saturation = 0.5; // Saturation : ,min=0.0, max=10.0

uniform float Red = 10.0; // Red : ,min=-0.0, max=100.0
uniform float Green = 1.0; // Green : ,min=-0.0, max=100.0
uniform float Blue = -10.0; // Blue : ,min=-0.0, max=100.0

uniform vec3 tint = vec3( 0.258 , 1.0 , 0.188 ); // Colour : 


vec3 RGB_lum = vec3(Red, Green, Blue);
const vec3 lumcoeff = vec3(0.2126,0.7152,0.0722);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{ 		
	vec2 uv = fragCoord.xy / resolution.xy;
	vec3 avg_lum = vec3(0.5, 0.5, 0.5);
	vec4 tc = texture2D(iChannel0, uv);
	
	vec4 tc_new = tc * (exp2(tc)*vec4(Exposure));
	vec4 RGB_lum = vec4(lumcoeff * RGB_lum, 0.0 );
	float lum = dot(tc_new,RGB_lum);
	vec4 luma = vec4(lum);
	//vec4 col = mix(tc, luma, amount);
	vec3 col = luma.rgb * tint;


	vec3 intensity = vec3(dot(col.rgb, lumcoeff));
	vec3 sat_color = mix(intensity, col.rgb, saturation);
	vec3 con_color = mix(avg_lum, sat_color, contrast);
	vec3 fin_col = con_color - 1.0 + brightness;
	col = mix(tc.rgb, fin_col, amount);
	
	fragColor.rgb = col;
} 
