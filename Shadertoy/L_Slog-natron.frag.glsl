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
// Code original : L_Slog Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_Slog Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=clamp
// BBox: iChannel0

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // creation de l'entrée
    vec4 color0 = texture(iChannel0, uv);

    // conversion colorimétrique
    float OutRed  = pow(10.0, ((color0.r - 0.616596 - 0.03) / 0.432699)) - 0.037584;
    float OutGreen = pow(10.0, ((color0.g - 0.616596 - 0.03) / 0.432699)) - 0.037584;
    float OutBlue = pow(10.0, ((color0.b - 0.616596 - 0.03) / 0.432699)) - 0.037584;

    // résultat
    fragColor = vec4(OutRed, OutGreen, OutBlue, 1);
}
