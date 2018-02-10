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
// Adaptation pour Natron par F. Fernandez
// Code original : L_AlexaLogCv3 Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_AlexaLogCv3 Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=clamp
// BBox: iChannel0

uniform bool lin_2_log;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // creation de l'entrée
    vec4 color = texture(iChannel0, uv);


    vec3 outColor;


    // activation ou désactivation de l'entrée modulate
    if (lin_2_log) {
    				outColor = vec3((color.r > 0.010591 ? (0.247190* (log (5.555556*color.r + 0.052272) / 2.30258509299) + 0.385537): (5.367655*color.r) + 0.092809), (color.g > 0.010591 ? (0.247190* (log (5.555556*color.g + 0.052272) / 2.30258509299) + 0.385537): (5.367655*color.g) + 0.092809), (color.b > 0.010591 ? (0.247190* (log (5.555556*color.b + 0.052272) / 2.30258509299) + 0.385537): (5.367655*color.b) + 0.092809));
    				}
    else 			{
    	 			outColor = vec3((color.r > 0.1496582 ? (pow(10.0, (color.r - 0.385537) / 0.2471896) - 0.052272) / 5.555556 : (color.r - 0.092809) / 5.367655 ), (color.g > 0.1496582 ? (pow(10.0, (color.g - 0.385537) / 0.2471896) - 0.052272) / 5.555556 : (color.g - 0.092809) / 5.367655 ), (color.b > 0.1496582 ? (pow(10.0, (color.b - 0.385537) / 0.2471896) - 0.052272) / 5.555556 : (color.b - 0.092809) / 5.367655 ));
         			}

    // résultat
    fragColor = vec4(outColor, 1);
}
