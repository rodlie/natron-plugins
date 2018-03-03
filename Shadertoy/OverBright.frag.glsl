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
// Code original : L_Mult Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_Mult Matchbox for Autodesk Flame


// iChannel0: Source0, filter=linear, wrap=clamp
// iChannel1: Modulate (Image containing the crop matte), filter=nearest, wrap=clamp
// BBox: iChannel0

uniform vec3 fillColor = vec3(1.0, 0.0, 0.0); // color

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec4 color0 = texture(iChannel0, uv);
    vec4 overBright = texture(iChannel0, uv);
    float result = 0;



    if (overBright.r > 1)
      {
      overBright.r = 1;
      }

    else
      {
      overBright.r = 0;
      }

    if (overBright.g > 1)
      {
      overBright.g = 1;
      }

    else
      {
      overBright.g = 0;
      }

    if (overBright.b > 1)
      {
      overBright.b = 1;
      }

    else
      {
      overBright.b = 0;
      }



    color0.r = clamp( ( color0.r*(overBright.r) )-1, 0 ,1);
    color0.g = clamp( ( color0.g*(overBright.g) )-1, 0 ,1);
    color0.b = clamp( ( color0.b*(overBright.b) )-1, 0 ,1);


    result = (color0.r +color0.g + color0.b)/3;

    fragColor = vec4( fillColor.r, fillColor.g, fillColor.b, result );
}
