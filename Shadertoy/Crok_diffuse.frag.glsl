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
// Code original : crok_diffuse Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_diffuse Matchbox for Autodesk Flame

// based on https://www.shadertoy.com/view/MdXXWr


// iChannel0: Source, filter = linear, wrap = clamp
// iChannel1: Strength map, filter = linear, wrap = clamp

// BBox: iChannel0





uniform int itteration = 3; // Iterations : (iterations), min=1, max=100
uniform float size = 100; // Size : (size), min=0, max=10000



float time = iTime *.05;
float cent = 0.0;



float rand1(vec2 a, out float r)
{
	vec3 p = vec3(a,1.0);
	r = fract(sin(dot(p,vec3(37.1,61.7, 12.4)))*3758.5453123);
	return r;
}

float rand2(inout float b)
{
	b = fract((134.324324) * b);
	return (b-0.5)*2.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	
	float strength = texture2D(iChannel1, uv).r;
	float n = size * strength / iResolution.x;
	rand1(uv, cent);
	vec4 col = vec4(0.0);
	for(int i=0;i<itteration;i++)
	{
		float noisex = rand2(cent);
		float noisey = rand2(cent);
		col += texture2D(iChannel0, uv - vec2(noisex, noisey) * n) / float(itteration);
	}
	fragColor = col;
}