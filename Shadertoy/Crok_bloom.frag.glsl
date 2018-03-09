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


// iChannel0: Source, filter = linear, wrap = mirror
// BBox: iChannel0

// bloom shader
// based on http://myheroics.wordpress.com/2008/09/04/glsl-bloom-shader/


uniform float pSize = 0.08; // Size : (size), min=0, max=2
uniform float p1 = 0.12; // Offset : (offset), min=-5, max=5
uniform float p2 = 0.9; // Strenght : (offset), min=0, max=5

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec4 sum = vec4(0);
   vec2 texcoord = fragCoord.xy / iResolution.xy;
   int j;
   int i;

   for( i= -4 ;i < 4; i++)
   {
        for (j = -3; j < 3; j++)
        {
            sum += texture2D(iChannel0, texcoord + vec2(j, i)*p1*0.01) * p2;
        }
   }
        {
            fragColor = sum*sum*0.0075*pSize + texture2D(iChannel0, texcoord);
        }
}
