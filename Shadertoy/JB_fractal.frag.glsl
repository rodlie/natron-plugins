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
// Adaptation pour Natron par F. Fernandez
// Code original : JB_fractal pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : JB_fractal Matchbox for Autodesk Flame

uniform float steps = 10.; // steps :, min=1, max=100.
uniform float wx;
uniform float wy;
uniform int number = 20; // number :, min=0, max=1000.
uniform vec2 ratio = vec2(1, 1);
uniform vec2 positionB = vec2(0.5, 0.5);
uniform float algo = 0.6; // algo :, min=0, max=1.
uniform vec3 color = vec3(0.9, 1.5, 0.8);


void mainImage( out vec4 fragColor, in vec2 fragCoord ){
		
	vec2 w = vec2(wx,wy);
	vec2 st0;
	st0.x = fragCoord.x / iResolution.x;
	st0.y = fragCoord.y / iResolution.y;

	float f = 1.0;
	float g = f;
	float t = steps;
	
	vec2 p = vec2((ratio.x*st0.x-positionB.x),(ratio.y*st0.y-positionB.y));
	vec2 z = p;
	vec2 k = vec2(cos(t*algo),sin(algo*t));

	
	for( int i=0; i<number; i++ ) 
	{
				   
		z = vec2( z.x*z.x-z.x*z.y, z.x/z.y ) - p*k;
		f = min( f, abs(dot(z-p,z-k) ));
		g = min( g, dot(z,z));
	}
	
	f = log(f)/9.;
	vec4 c;
	c = abs(vec4(color.r*f,color.g*f,color.b*f,f));
	fragColor = c;
}
