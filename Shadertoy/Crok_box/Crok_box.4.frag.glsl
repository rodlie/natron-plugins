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
// Code original : crok_box Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_box Matchbox for Autodesk Flame

// pass2 : blur X

// iChannel0: result_pass3, filter = linear, wrap=clamp
// BBox: iChannel0




uniform float blur_comp = 0.0; // Blur : ,min=0.0, max=10000



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 coords = fragCoord.xy / iResolution.xy;
   int f0int = int(blur_comp);
   vec4 accu = vec4(0);
   float energy = 0.0;
   vec4 blur_compx = vec4(0.0);
   
   for( int x = -f0int; x <= f0int; x++)
   {
      vec2 currentCoord = vec2(coords.x+float(x)/iResolution.x, coords.y);
      vec4 aSample = texture2D(iChannel0, currentCoord).rgba;
      float anEnergy = 1.0 - ( abs(float(x)) / blur_comp);
      energy += anEnergy;
      accu+= aSample * anEnergy;
   }
   
   blur_compx = 
      energy > 0.0 ? (accu / energy) : 
                     texture2D(iChannel0, coords).rgba;
                     
   fragColor = vec4( blur_compx );
}
