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
// Code original : K_RgbcmyMatte Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : K_RgbcmyMatte Matchbox for Autodesk Flame
//
// K_RgbcmyMatte v1.2
// Shader written by: Kyle Obley (kyle.obley@gmail.com)
//

// BBox: iChannel0

uniform int selection; // Selection : (1=Red, 2=Green, 3=Blue, 4=Cyan, 5=Yellow, 6=Magenta, 7=White), min=1, max=7

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{	
	vec2 st = fragCoord.xy / vec2 (iResolution.x, iResolution.y);
	vec3 image = texture2D(iChannel0, st).rgb;
	
	// Red
	if ( selection == 1 )
	{
		fragColor = vec4( image.r * (1.0 - image.g) * (1.0 - image.b) );
	}
	
	// Green
	else if ( selection == 2 )
	{
		fragColor = vec4( (1.0 - image.r) * image.g * (1.0 - image.b) );
	}
	
	// Blue
	else if ( selection == 3 )
	{
		fragColor = vec4( (1.0 - image.r) * (1.0 - image.g) * image.b );
	}
	
	// Cyan
	else if ( selection == 4 )
	{
		fragColor = vec4( (1.0 - image.r) * image.g * image.b );
	}
	
	// Yellow
	else if ( selection == 5 )
	{
		fragColor = vec4(  image.r * image.g  * (1.0 - image.b) );
	}
	
	// Magenta
	else if ( selection == 6 )
	{
		fragColor = vec4( image.b * (1.0 - image.r ) * image.g );
	}
	
	// White
	else if ( selection == 7 )
	{
		fragColor = vec4( image.r * image.g * image.b );
	}
}