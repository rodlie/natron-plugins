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
// Code original : crok_regrain Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_regrain Matchbox for Autodesk Flame


// iChannel0: pass3_result, filter=linear, wrap=repeat
// BBox: iChannel0

uniform float blur = 1.0;               // Softness : ,min=0.0, minx=10.0
uniform int stock = 0 ;                 // Stock : ,min=0, max=12

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
   vec2 coords = fragCoord.xy / vec2( iResolution.x, iResolution.y );
   float p_blur = 1.0;

// Alan Skin BW
	if ( stock == 10 )
	{
		p_blur = 0.73;
	}

   float softness = (blur + 1.) * p_blur;
   int f0int = int(softness);
   vec4 accu = vec4(0);
   float energy = 0.0;
   vec4 finalColor = vec4(0.0);

   for( int y = -f0int; y <= f0int; y++)
   {
      vec2 currentCoord = vec2(coords.x, coords.y+float(y)/iResolution.y);
      vec4 aSample = texture2D(iChannel0, currentCoord).rgba;
      float anEnergy = 1.0 - ( abs(float(y)) / softness);
      energy += anEnergy;
      accu+= aSample * anEnergy;
   }

   finalColor =
      energy > 0.0 ? (accu / energy) :
                     texture2D(iChannel0, coords).rgba;

   fragColor = vec4( finalColor );
}
