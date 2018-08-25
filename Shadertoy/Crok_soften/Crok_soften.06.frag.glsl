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
// Code original : crok_soften Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_soften Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter = linear , wrap = clamp
// iChannel1: pass5_result, filter = linear , wrap = clamp
// iChannel2: Mask, filter = linear , wrap = clamp
// BBox: iChannel0



uniform float amount = 0.8; // Strength : , min=0.0, max=1.0


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
   vec4 o = texture2D(iChannel0, uv);
   vec4 b = texture2D(iChannel1, uv);
   vec4 m = texture2D(iChannel2, uv);

   vec4 c = mix(o, b, amount);
   fragColor = mix(o,c,b.a);
   fragColor.a = b.a;
}
