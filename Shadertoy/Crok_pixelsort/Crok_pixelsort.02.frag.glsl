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
// Code original : crok_pixelsort Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_pixelsort Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter=linear, wrap=mirror
// BBox: iChannel0


// based on https://www.shadertoy.com/view/XsBfRG



float gray( vec3 c ) {
  return dot( c, vec3( 0.299, 0.587, 0.114 ) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
   vec3 c = texture2D(iChannel0, uv).rgb;
   c.r = gray(c);
   fragColor = vec4(c.r);
}
