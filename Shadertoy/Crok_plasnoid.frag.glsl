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
// Code original : crok_plasnoid Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_plasnoid Matchbox for Autodesk Flame




uniform float speed = 1; // Speed : (speed), min=-500 , max=500
uniform float offset = 0; // Offset : (offset), min=-100 , max=100
uniform float detail = 2; // Detail : (detail), min=-500 , max=500
uniform float noise_x = -5; // Noise X : (noise x), min=-500 , max=500
uniform float noise_y = 5; // Noise Y : (noise y), min=-500 , max=500
uniform float fractal_x = -5; // Fractal X : (fractal x), min=-500 , max=500
uniform float fractal_y = 12; // Fractal Y : (fractal y), min=-500 , max=500
uniform float random_x = 1; // Random X : (random x), min=-500 , max=500
uniform float random_y = -5; // Random Y : (random y), min=-500 , max=500

uniform int itterations = 6; // Iterations : (iterations), min=0 , max=500
uniform vec3 color = vec3(0.5, 0.6, 0.65);




float time = iTime*.025 * speed + offset;

float getGas(vec2 p)
{
	return (cos(p.y * detail + time)+1.0)*0.5+(sin(time))*0.0+0.1;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 position = ( fragCoord.xy / iResolution.xy );
	
	vec2 p=position;
	for(int i=1;i<itterations;i++){
		vec2 newp=p;
		
//		newp.x+=(0.4/(float(i)))*(sin(p.y*(10.0+time*0.0001))*0.2*sin(p.x*30.0)*0.8);
//		newp.y+=(0.4/(float(i)))*(cos(p.x*(20.0+time*0.0001))*0.2*sin(p.x*5.0)+time*0.1);

		newp.x+=(noise_x / (float(i)))*(sin(p.y*(fractal_x + time * 0.0001))*0.2*sin(p.x * random_x)*0.8);
		newp.y+=(noise_y / (float(i)))*(cos(p.x*(fractal_y + time * 0.0001))*0.2*sin(p.x * random_y)+time*0.1);
		p=newp;
	}

	vec3 clr=vec3(color.r * .2 ,color.g *.2 , color.b * .2);
	clr/=getGas(p);

	fragColor = vec4( clr, 1.0 );

}