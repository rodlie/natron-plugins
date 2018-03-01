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
// Code original : crok_2color Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_2color Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest
// BBox: iChannel0


uniform float Amount = 1; // Amount : (Amount), min = 0., max = 1.
uniform float Exposure = 1; // Exposure : (Exposure), min = 0., max = 5.

uniform float dark_low = 0; // Dark low : (Dark low), min = 0., max = 1.
uniform float dark_high = 1; // Dark high : (Dark high), min = 0., max = 5.

uniform float light_low = 0; // Light low : (Light low), min = 0., max = 1.
uniform float light_high = 1; // Light high : (Light high), min = 0., max = 5.

uniform float contrast = 1; // Contrast : (Contrast), min = 0., max = 5.
uniform float saturation = 1; // Saturation : (Saturation), min = 0., max = 1.

uniform vec3 light_tint = vec3(0.0, 1.0, 1.0); // Light tint : (Light tint)
uniform vec3 dark_tint = vec3(0.5, 0.0, 1.0); // Dark tint : (Dark tint)


const vec3 lumc = vec3(0.2125, 0.7154, 0.0721);


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	
	vec3 original = texture2D(iChannel0, uv).rgb;
	vec3 col = original;

	float bri = (col.x+col.y+col.z)/3.0;
	float v = smoothstep(dark_low, dark_high, bri);
	col = mix(dark_tint * bri, col, v);
	
	v = smoothstep(light_low, light_high, bri);
	col = mix(col, min(light_tint * col, 1.0), v);
	col = mix(original, col, Amount);
	
	vec3 avg_lum = vec3(0.5, 0.5, 0.5);
	vec3 intensity = vec3(dot(col.rgb, lumc));
	vec3 sat_color = mix(intensity, col.rgb, saturation);
	vec3 con_color = mix(avg_lum, sat_color, contrast);
	vec3 fin_col = con_color;
	
	
	fragColor = vec4(fin_col, 1.0) * Exposure;
}