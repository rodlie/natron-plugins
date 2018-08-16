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
// Code original : crok_distort Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_distort Matchbox for Autodesk Flame


// iChannel0: Lens , filter = linear , wrap = clamp
// BBox: iChannel0



uniform float blur_matte = 10.0; // Blur Lens : , min=0.001, max=256.0



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 coords = fragCoord.xy / vec2( iResolution.x, iResolution.y );
    int f0int = int(blur_matte);
    vec4 accu = vec4(0);
    float energy = 0.0;
    vec4 blur_colory = vec4(0.0);
   
    for( int y = -f0int; y <= f0int; y++)
    {
       vec2 currentCoord = vec2(coords.x, coords.y+float(y)/iResolution.y);
       vec4 aSample = texture2D(iChannel0, currentCoord).rgba;
       float anEnergy = 1.0 - ( abs(float(y)) / blur_matte);
       energy += anEnergy;
       accu+= aSample * anEnergy;
    }
   
    blur_colory = 
       energy > 0.0 ? (accu / energy) : 
                      texture2D(iChannel0, coords).rgba;
                     
    fragColor = vec4( blur_colory );
}