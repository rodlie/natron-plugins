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
// Code original : crok_bloom Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_bloom Matchbox for Autodesk Flame


// iChannel0: Source, filter=linear,wrap=mirror
// iChannel1: Mask, filter=nearest,wrap=clamp
// BBox: iChannel0

// bloom shader
// based on http://myheroics.wordpress.com/2008/09/04/glsl-bloom-shader/




uniform float pSize = 0.08; // Size : (size), min=0, max=2
uniform float p2 = 0.9; // Strenght : (strength), min=0, max=5


uniform float p1 = 0.12; // Offset : (offset), min=-5, max=5
uniform int max1 = 4; // H Offset : (horizontal offset), min=1, max=10
uniform int max2 = 3; // V Offset : (vertical offset), min=1, max=10

uniform bool perpixel_size = false; // Modulate (Modulate the amplitude by multiplying it by the first channel of the Modulate input)
uniform int maskChannel = 3; // Mask : (mask channel), min=0, max=3




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec4 sum = vec4(0);
   vec2 texcoord = fragCoord.xy / iResolution.xy;
   vec4 source = texture2D(iChannel0, texcoord);
   vec4 matte = texture2D(iChannel1, texcoord);
   int j;
   int i;

   for( i= -max1 ;i < max1; i++)
   {
        for (j = -max2; j < max2; j++)
        {
            sum += texture2D(iChannel0, texcoord + vec2(j, i)*p1*0.01) * p2;
        }
   }
        {
            if (maskChannel == 1)
            {
              matte.r = matte.g;
            }

            if (maskChannel == 2)
            {
              matte.r = matte.b;
            }

            if (maskChannel == 3)
            {
              matte.r = matte.a;
            }


            if (perpixel_size)
            {
              fragColor = sum*sum*0.0075*pSize*matte.r + texture2D(iChannel0, texcoord);
            }

            else
            {
              fragColor = sum*sum*0.0075*pSize + texture2D(iChannel0, texcoord);
            }
        }
}
