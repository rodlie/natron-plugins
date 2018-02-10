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
// Code original : L_Mult Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_Mult Matchbox for Autodesk Flame


// iChannel0: Source0, filter=nearest, wrap=clamp
// iChannel1: Modulate (Image containing the crop matte), filter=linear, wrap=clamp
// BBox: iChannel0

uniform float multiplicateur = 1;  // Multiplicateur, min=0., max=10.
uniform float blend = 1;  // Blend, min=0., max=1.
uniform bool perpixel_matte = false; // Modulate (Modulate the amplitude by multiplying it by the first channel of the Modulate input)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // creation des 2 entrées
    vec4 color0 = texture(iChannel0, uv);
    vec4 matte0 = texture(iChannel1, uv);
    vec4 matteOUT = matte0;

    // activation ou désactivation de l'entrée modulate
    if (perpixel_matte) {
        				matteOUT = matte0;
    					}
    else {
    	 matteOUT.r = 1;
         matteOUT.g = 1;
         matteOUT.b = 1;
         }

    // résultat
    fragColor = mix (color0, color0*multiplicateur, matteOUT*blend);
}
