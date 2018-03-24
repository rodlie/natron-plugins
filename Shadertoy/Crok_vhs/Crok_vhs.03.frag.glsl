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
// Code original : crok_vhs Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_vhs Matchbox for Autodesk Flame



// iChannel0: result_pass1, filter = linear
// BBox: iChannel0

vec2 res = vec2(iResolution.x, iResolution.y);
uniform float vhs_res = 0.17; // Resolution : , min=0.0, max=1.0

 void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 p = (fragCoord.xy / res.xy ) * vhs_res;
  vec4 col = texture2D( iChannel0, p );
  fragColor = vec4(col.rgb,1.0 );
}
