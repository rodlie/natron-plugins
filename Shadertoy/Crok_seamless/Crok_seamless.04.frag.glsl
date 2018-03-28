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
// Code original : crok_seamless Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_seamless Matchbox for Autodesk Flame


// iChannel0: pass2_result, filter=linear, wrap=repeat
// iChannel1: pass3_result, filter=linear, wrap=repeat
// BBox: iChannel0



vec2 res = vec2(iResolution.x, iResolution.y);


uniform int version = 0; // Version : ,min=0, max=1

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / res.x;
	vec4 col = vec4(0.0);

	if ( version == 0 )
  	col = texture2D( iChannel0, uv );
	else if ( version == 1 )
		col = texture2D( iChannel1, uv );

	 fragColor = col;
}
