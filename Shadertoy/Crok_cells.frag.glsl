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
// Code original : crok_cells Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_cells Matchbox for Autodesk Flame



uniform float itterations = 4.0;
uniform float zoom = 40.0;

uniform float speed = 10.0;
uniform float offset = 0.0;

uniform vec3 color_1 = vec3(2,.5,.2);





vec2 resolution = vec2(iResolution.x, iResolution.y);
float time = iTime*.025 * speed + offset;
#define PI 3.14159
#define TWO_PI (PI*2.0)


void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{
	vec2 center = (fragCoord.xy);
	center.x=-0.12*sin(time/200.0);
	center.y=-100.12*cos(time/200.0);
	vec2 v = (fragCoord.xy - resolution/2.0) / min(resolution.y,resolution.x) * zoom;
	v.x=v.x-200.0;
	v.y=v.y-200.0;
	float col = 0.0;
	for(float i = 0.0; i < itterations; i++) 
	{
	  	float a = i * (TWO_PI/itterations) * 61.95;
		col += cos(TWO_PI*(v.y * cos(a) + v.x * sin(a) + sin(time*0.004)*100.0 ));
	}
	fragColor = vec4(col*color_1.r, col*color_1.g, col*color_1.b, 1.0);
}