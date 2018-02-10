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

// Adapted to Natron by F.Fernandez

// iChannel0: Source0, filter=nearest, wrap=clamp
// BBox: iChannel0

uniform vec3 fillColor = vec3(1.0, 0.0, 0.0); // color

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = fragCoord.xy / iResolution.xy;
    
    vec4 color0 = texture(iChannel0, uv);
    vec4 overDark = texture(iChannel0, uv);
    vec4 result =   texture(iChannel0, uv);
    float resultAlpha = 0;



    if (color0.r < 0)
      {
      overDark.r = 1;
      }

    else
      {
      overDark.r = 0;
      }

    if (color0.g < 0)
      {
      overDark.g = 1;
      }

    else
      {
      overDark.g = 0;
      }

    if (color0.b < 0)
      {
      overDark.b = 1;
      }

    else
      {
      overDark.b = 0;
      }



    result.r = clamp( ( color0.r*(overDark.r) )+1, 0 ,1);
    result.g = clamp( ( color0.g*(overDark.g) )+1, 0 ,1);
    result.b = clamp( ( color0.b*(overDark.b) )+1, 0 ,1);

    resultAlpha = (result.r +result.g + result.b)/3;

    fragColor = vec4( fillColor.r, fillColor.g, fillColor.b,( (result.g)*-1)+1);
}
