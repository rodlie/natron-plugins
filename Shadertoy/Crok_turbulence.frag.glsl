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
// Code original : crok_turbulence pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_turbulence for Autodesk Flame



// water turbulence effect by joltz0r 2013-07-04, improved 2013-07-07




uniform float Speed = 10.0; // Speed : (speed), min=-10, max=10
uniform float Offset = 0.0; // Offset : (offset), min=-10000, max=10000
uniform float Zoom = 2.0; // Zoom : (zoom), min=-0.01, max=15
uniform int Detail = 15; // Detail : (detail), min=1, max=100
uniform vec2 Position = vec2(15.0,24.0); // Position : (position)
uniform vec3 Colour = vec3(0.3,0.5,0.95); // Colour : (colour)




float time = iTime*.05 * Speed + Offset+50. ;
vec2 resolution = vec2(iResolution.x, iResolution.y);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 sp = fragCoord.xy / resolution;
	vec2 center_uv=(2.0*(sp-.5));
	vec2 p = center_uv * Zoom - Position;
	vec2 i = p;
	float c = 1.0;
	float inten = .05;
	for (int n = 0; n < Detail; n++) 
	{
		float t = time/5. * (1.0 - (3.0 / float(n+1)));
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0/length(vec2(p.x / (2.*sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
	}
	c /= float(Detail);
	c = 1.5-sqrt(pow(c,3.*0.5));
	fragColor = vec4(vec3(c*c*c*c*Colour.r,c*c*c*c*Colour.g,c*c*c*c*Colour.b), 1.0);

}