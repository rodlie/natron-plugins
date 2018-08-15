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
// Code original : crok_defocus Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_defocus Matchbox for Autodesk Flame

// iChannel0: Source, filter=nearest, wrap=clamp
// iChannel1: Mask, filter=nearest, wrap=clamp
// BBox: iChannel0


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
   vec3 col = clamp(vec3( texture2D(iChannel0, uv).rgb), 0.0, 10000000000.0);
   float matte = texture2D(iChannel1, uv).a;
   col *= matte;
   fragColor = vec4(col, matte);
}
