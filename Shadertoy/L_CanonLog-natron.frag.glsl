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
// Code original : L_CanonLog Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_CanonLog Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=clamp
// BBox: iChannel0

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // creation de l'entrée
    vec4 color0 = texture(iChannel0, uv);

    // conversion colorimétrique
    float OutRed  = ((pow(10,(((color0.r*1023.0-64.0)/876.0)-(64.0/876.0))/0.529136)-1.0)/10.1596);
    float OutGreen = ((pow(10,(((color0.g*1023.0-64.0)/876.0)-(64.0/876.0))/0.529136)-1.0)/10.1596);
    float OutBlue = ((pow(10,(((color0.b*1023.0-64.0)/876.0)-(64.0/876.0))/0.529136)-1.0)/10.1596);

    // résultat
    fragColor = vec4(OutRed, OutGreen, OutBlue, 1);
}
