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
// Code original : crok_lines Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : crok_lines Matchbox for Autodesk Flame



uniform float density = 1; // Density : (density), min =-100, max=100
uniform float speed = 1; // Speed : (speed), min =-1000, max=1000
uniform float offset = 0; // Offset : (offset), min =-1000, max=1000
uniform int itterations = 5; // Iterations : (iterations), min =-1000, max=1000
uniform float gain = 0.45; // Gain : (gain), min=0, max=1000
uniform	float edgeSharpness = 3; // Edge sharpness : (edge sharpness), min =-100, max=100
uniform vec3 color = vec3(1,1,1); // Colour : (colour)




float time = iTime*.002 * speed + offset;
const float Pi = 3.14159;




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 pos = fragCoord.xy / iResolution.xy;
  float angled = (pos.x) * density;	
  for (int i = 1; i < itterations; i++)
  {
	  angled += (edgeSharpness * sin( float(i)*angled) / float(i) ) + time;
  }
  float base = gain * sin(3.0*angled);
  fragColor=vec4(color.r * base, color.g * base, color.b * base, 1.0);
}
