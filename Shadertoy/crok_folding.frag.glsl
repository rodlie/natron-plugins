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
// Code original : crok_folding Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_folding Matchbox for Autodesk Flame


uniform float Noise = 3.0; // Noise : 
uniform float Detail = 1.5; // Detail : 
uniform float Steps = 3.0; // Iterations : , min=1.0, max=10.0
uniform float Speed = 5.0; // Speed : 
uniform float Offset = 0.0; // Offset : 
uniform float Zoom = 1.0; // Zoom : , min=0.0, max=100.0
uniform float Aspect = 1.0; // Aspect : 

uniform vec3 color_pot = vec3( 0.9 , 0.95 , 1.0); // Colour : 
uniform bool useduration = false; // Choose speed to create loop : 
uniform int duration = 100; // Duration : , min=1



vec2 resolution = vec2(iResolution.x, iResolution.y);



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	float time;
	if(useduration == true) {
		// The only time-dependent function below is sin(time), which
		// repeats every 2*pi
		time = 2.0 * 3.14159265358979 * (iTime/float(duration));
		time += Offset/float(duration);
	} else {
		time = iTime*.01*Speed+Offset;
	}
	vec2 position = ( fragCoord.xy / resolution.xy );
	vec2 zoom_center=(2.0*(position-.5)) * Zoom;
	zoom_center.x *= resolution.x / resolution.y*Aspect;
	float color = 0.0;
	for(float i = 0.0; i < Steps; i++)
	{
		zoom_center.x += sin(Noise * sin(length(zoom_center.y + 5.)));
		color += sin(0.6 * Detail * sin(length(position) + zoom_center.x + i * zoom_center.y + sin(i + zoom_center.x + time )) + sin(Noise * cos(sin(zoom_center.y + zoom_center.x) * 0.5)));
		color = sin(color*1.5);
		zoom_center.y += color*1.5;
		zoom_center.x -= sin(zoom_center.y - cos(dot(zoom_center, vec2(color, sin(color*2.)))));
	}
	fragColor = vec4(abs(color) * color_pot, 1.0);
    
}