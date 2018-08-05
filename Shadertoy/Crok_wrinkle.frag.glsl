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
// Code original : crok_wrinkle Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_wrinkle Matchbox for Autodesk Flame

uniform float Speed = 1.0; // Speed : (speed), min=-10000, max=10000
uniform float Offset = 0.0; // Offset : (offset), min=-1000, max=10000
uniform float seed = 0.0; // Seed : (seed), min=-10000, max=10000
uniform float detail = 50.0; // Detail : (detail), min=0, max=500
uniform float noise = 5.0; // Noise : (noise), min=0, max=10000
uniform float zoom = 10.0; // Zoom : (zoom), min=-100, max=100
uniform float rotation = 0.0; // Rotation : (rotation), min=-10000, max=10000
vec2 center = iMouse.xy /iResolution.xy;


uniform vec3 color = vec3(1,1,1);

vec2 myResolution = vec2(iResolution.x, iResolution.y);
float time = iTime *.05 * Speed + Offset;


//Wrinkled paper generator
//based off http://www.claudiocc.com/the-1k-notebook-part-iii/
//http://glsl.heroku.com/e#16688.0

float rand(float n)
{
    vec2 co = vec2(n,3.4234324-n);
    return fract(sin(dot(co.xy ,vec2(16.9898,78.233))) * 9958.5453);
}

vec3 LinearGrad(vec2 p1,vec2 p2,vec2 px)
{
	vec2 dir = (normalize(p2-p1)) / noise * 10.;
	float g = dot(px-p1,dir)/length(p1-p2);
	return vec3(clamp(g,0.,1.));
}

vec3 Difference(vec3 c1,vec3 c2)
{
	return abs(c1-c2);
}


vec3 Paper(vec2 p)
{
	vec3 c = vec3(0.0);
	
	for(float i = 0.;i < detail;i++)
	{
		vec2 p1 = vec2(rand(1.+i+seed-6.67)+cos(time*0.43)*0.1,rand(1.1+i+seed-16.68)+sin(time*0.89)*0.1) * myResolution;
		vec2 p2 = vec2(rand(0.2+i+seed-6.68)+cos(time*0.456)*0.1,rand(1.3+i+seed-16.68)+sin(time*0.00000033)*0.1) * myResolution;

		c = Difference(c,LinearGrad(p1, p2, p));
	}
	return c;
}

vec3 Band(float pc)
{
	vec3 c;
	c = mix(vec3(0),vec3(color.x,color.y,color.z),pc);
	return c;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{

	vec2 p = ((fragCoord.xy / iResolution.xy) - center) * zoom * 500.;

    mat2 rotcalc = mat2( cos(-rotation), -sin(-rotation), sin(-rotation), cos(-rotation) );
	p *= rotcalc;
					   
	vec3 c = Band(1.-Paper(p).x);
		
	fragColor = vec4(c, 1.0 );
}