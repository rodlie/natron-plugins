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
//                          MMMMMMMMMMMMMMMMMMMMMMMMMMM                                                      
//                                                                
//
// Adaptation pour Natron par F. Fernandez
// Code original : crok_bw Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_bw Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest
// BBox: iChannel0


uniform float Exposure = 1; // Exposure, min=0, max=10
uniform float amount = 1; // Desaturation, min=0, max=1

uniform float Red = 1; // Red desaturation, min=0, max=1
uniform float Green = 1; // Green desaturation, min=0, max=1
uniform float Blue = 1; // Blue desaturation, min=0, max=1

vec3 RGB_lum = vec3(Red, Green, Blue);
const vec3 lumcoeff = vec3(0.2126,0.7152,0.0722);

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{ 		
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 tc = texture(iChannel0, uv);

	vec4 tc_new = tc * (exp2(tc)*vec4(Exposure));
	vec4 RGB_lum = vec4(lumcoeff * RGB_lum, 0.0 );
	float lum = dot(tc_new,RGB_lum);
	vec4 luma = vec4(lum);
	fragColor = mix(tc, luma, amount);
}