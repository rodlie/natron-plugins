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
// Code original : K_BW Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : K_BW Matchbox for Autodesk Flame
//
// K_BW v1.0
// Shader written by: Kyle Obley (kyle.obley@gmail.com)
//
// iChannel0: Source, filter = nearest
// BBox: iChannel0


uniform float red = 40; // red : (red), min=0, max=100
uniform float green = 30; // green : (green), min=0, max=100
uniform float blue = 30; // blue : (blue), min=0, max=100



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{	
	vec2 st = fragCoord.xy / vec2 (iResolution.x, iResolution.y);
	vec4 image = texture2D(iChannel0, st);
	
	float luminance = image.r * (red/100.0) + image.g * (green/100.0) + image.b * (blue/100.0);
	fragColor = vec4(luminance, luminance, luminance, image.a);
}