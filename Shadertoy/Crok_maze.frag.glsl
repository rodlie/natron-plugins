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
// Code original : crok_maze Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_maze Matchbox for Autodesk Flame

//based on http://glslsandbox.com/e#21316.0





uniform float zoom = 12.0; // Zoom : , min=0.001, max=10000
uniform float width = 1.0; // Width : , min=0.51, max=10000
uniform float rot = 0.0; // Rotation : , min=-10000, max=10000

uniform vec2 center = vec2(0.0 , 0.0); // Center : 

uniform vec3 mazeColor = vec3(1.0,1.0,1.0); // Color : 

uniform bool invertMaze = false; // Invert : 


vec2 resolution = vec2(iResolution.x, iResolution.y);
const float PI = 3.1415926;

float	hash(vec2 p);
mat2	rmat(float theta);
float	random_tiles(vec2 p);
float	cross(float x);

float smoothmin(float a, float b, float k)
{
	return -(log(exp(k*-a)+exp(k*-b))/k);
}

float maze( vec2 p ) 
{
	vec2 tp 	= (p) * rmat(PI*.25 + (.0000125) * 2.);
	
	float t0 	= random_tiles(tp * zoom * .5 - 4.);
	float t1 	= random_tiles(tp * zoom * .5 + 32.);
	float t2 	= random_tiles(tp * zoom * 2. + 32.);

	return 1.-(step(t2,.5));
}

float hash(vec2 p) {
	return fract(sin(p.x * 15.35 + p.y * 35.79) * 43758.23);
}

mat2 rmat(float theta)
{
	float c = cos(theta);
	float s = sin(theta);
	return mat2(c, s, -s, c);
}

float random_tiles(vec2 p) 
{
	vec2 lattice	= floor(p);
	float theta 	= hash(lattice) > 0.5 ? 0.0 : PI * 0.5;	
	p 		*= rmat(theta);
	vec2 f		= fract(p);
	return cross(f.x-f.y);
}

float cross(float x) 
{
	return abs(fract(x)-.5)*2. * width;	
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = ((fragCoord.xy / resolution.xy) - 0.5) - center;
	float myFrameratio = iResolution.x / iResolution.y;
    mat2 rotation = mat2( cos(-rot*.1), -sin(-rot*.1), sin(-rot *.1), cos(-rot * .1));
    uv.x *= myFrameratio;
    uv *= rotation;
	uv.x /= myFrameratio;
	
	

	float m = maze(uv);
		
	fragColor = vec4( mazeColor.r*m, mazeColor.g*m, mazeColor.b*m, m);


}


