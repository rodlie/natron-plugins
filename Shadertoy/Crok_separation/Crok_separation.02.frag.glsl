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
// Code original : crok_separation Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_separation Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter = linear, wrap = clamp
// BBox: iChannel0


#extension GL_ARB_shader_texture_lod : enable




uniform float blur_fg = 10.0; // Blur : , min=0.0, max=1000.0




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 coords = fragCoord.xy / vec2( iResolution.x, iResolution.y );
   int f0int = int(blur_fg);
   vec4 accu = vec4(0);
   float energy = 0.0;
   vec4 blur_fg_y = vec4(0.0);
   
   for( int y = -f0int; y <= f0int; y++)
   {
      vec2 currentCoord = vec2(coords.x, coords.y+float(y)/iResolution.y);
      vec4 aSample = texture2D(iChannel0, currentCoord).rgba;
      float anEnergy = 1.0 - ( abs(float(y)) / blur_fg);
      energy += anEnergy;
      accu+= aSample * anEnergy;
   }
   
   blur_fg_y = 
      energy > 0.0 ? (accu / energy) : 
                     texture2D(iChannel0, coords).rgba;
                     
   fragColor = vec4( blur_fg_y );
}
