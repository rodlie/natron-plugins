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
// Code original : crok_fractal_soup Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_fractal_soup Matchbox for Autodesk Flame

uniform int detail = 48; // Detail : (detail), min=0.0, max=100.0

uniform float Speed =10.0; // Speed : (speed), min=-10000, max=10000

uniform float gain = 3.8; // Gain : (gain), min=0.0, max=10.0


float myGlobalTime = iTime*.02;


#ifdef GL_ES
precision mediump float; 
#endif

uniform float time = 7.0; // Time : (time), min=-5000, max=5000

uniform vec3 vBaseColour = vec3(0.232,0.48,0.64); // Colour : (colour)

// Fractal Soup - @P_Malin

vec2 CircleInversion(vec2 vPos, vec2 vOrigin, float fRadius)
{	
	vec2 vOP = vPos - vOrigin;
	return vOrigin - vOP * fRadius * fRadius / dot(vOP, vOP);
}

float Parabola( float x, float n )
{
	return pow( gain*x*(1.0-x), n );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 vPos = fragCoord.xy / iResolution.xy;
	vPos = vPos - 0.5;
	
	vPos.x *= iResolution.x / iResolution.y;
	
	vec2 vScale = vec2(1.2);
	vec2 vOffset = vec2( sin((myGlobalTime+time)*.123*Speed), sin((myGlobalTime+time)*.0567*Speed));

	float l = 0.0;
	float minl = 10000.0;
	
	for(int i=0; i<detail; i++)
	{
		vPos.x = abs(vPos.x);
		vPos = vPos * vScale + vOffset;	
		
		vPos = CircleInversion(vPos, vec2(0.5, 0.5), 1.0);
		
		l = length(vPos);
		minl = min(l, minl);
	}
	
	float t = 4.1 + time;

	float fBrightness = 15.0;
	
	vec3 vColour = vBaseColour * l * l * fBrightness;
	
	minl = Parabola(minl, 5.0);	
	
	vColour *= minl + 0.1;
	
	vColour = 1.0 - exp(-vColour);
	fragColor = vec4(vColour,1.0);
}
