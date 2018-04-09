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
// Code original : crok_checkerboard Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_checkerboard Matchbox for Autodesk Flame



uniform float rot = 0.0; // Rotation : (rotation), min=-10000, max=10000
uniform float zoom = 10.0; // Zoom : (zoom), min=2.0, max=1000
uniform float blur = 0.0; // Blur : (blur), min=0.0, max=1000.0
uniform float Aspect = 1.0; // Aspect : (aspect), min=0.01, max=100

uniform vec3 color1 = vec3(1.0,1.0,1.0); // Color 1 : (color 1)
uniform vec3 color2 = vec3(0.0,0.0,0.0); // Color 2 : (color 2)



#define PI 3.14159265359

vec2 resolution = vec2(iResolution.x, iResolution.y);

    
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = ((fragCoord.xy / resolution.xy) - 0.5);
	float bl = 0.0;

	bl += blur; 

	float b = bl * zoom / resolution.x;

	float frameRatio = iResolution.x / iResolution.y;
	uv.x *= frameRatio;
	// degrees to radians conversion
	float rad_rot = rot * PI / 180.0; 

	// rotation
	mat2 rotation = mat2( cos(-rad_rot), -sin(-rad_rot), sin(-rad_rot), cos(-rad_rot));
	uv *= rotation;
	
	uv.x *= Aspect;
	uv *= zoom;
	
	
    vec2 anti_a = sin(PI * uv);
	vec2 square = smoothstep( -b, b, anti_a );
	square = 2.0 * square - 1.0;						
    float a = 0.5 * (square.x * square.y) + 0.5;
	vec3 c = mix(color1, color2, a); 
	fragColor = vec4(c, a);
}