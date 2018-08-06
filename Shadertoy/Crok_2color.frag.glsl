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


// iChannel0: Source,filter=nearest,wrap=clamp
// BBox: iChannel0


uniform float Amount = 1; // Amount : (Amount), min = 0., max = 1.
uniform float Exposure = 1; // Exposure : (Exposure), min = 0., max = 5.

uniform float dark_low = 0; // Dark low : (Dark low), min = 0., max = 1.
uniform float dark_high = 1; // Dark high : (Dark high), min = 0., max = 5.

uniform float light_low = 0; // Light low : (Light low), min = 0., max = 1.
uniform float light_high = 1; // Light high : (Light high), min = 0., max = 5.

uniform float contrast = 1; // Contrast : (Contrast), min = 0., max = 5.
uniform float saturation = 1; // Saturation : (Saturation), min = 0., max = 1.

uniform vec4 light_tint = vec4(0.0, 1.0, 1.0, 0.0); // Light tint : (Light tint)
uniform vec4 dark_tint = vec4(0.5, 0.0, 1.0, 0.0); // Dark tint : (Dark tint)


const vec4 lumc = vec4(0.2125, 0.7154, 0.0721, 0.0);


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	
	vec4 original = texture2D(iChannel0, uv);
	vec4 col = original;

	float bri = (col.x+col.y+col.z)/3.0;
	float v = smoothstep(dark_low, dark_high, bri);
	col = mix(dark_tint * bri, col, v);
	
	v = smoothstep(light_low, light_high, bri);
	col = mix(col, min(light_tint * col, 1.0), v);
	col = mix(original, col, Amount);
	
	vec4 avg_lum = vec4(0.5, 0.5, 0.5, 0.0);
	vec4 intensity = vec4(dot(col.rgba, lumc));
	vec4 sat_color = mix(intensity, col.rgba, saturation);
	vec4 con_color = mix(avg_lum, sat_color, contrast);
	vec4 fin_col = con_color;
	
	
	fragColor = vec4(fin_col.rgb, original.a) * Exposure;
}