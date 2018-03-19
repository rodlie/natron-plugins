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
// Code original : crok_bw Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_bw Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=clamp
// BBox: iChannel0

// Contour and Valley detection using GLSL
// http://www.forceflow.be/2010/04/14/contour-and-valley-detection-using-glsl/


uniform int radius = 10; // Radius : (radius), min=1, max=100
uniform int renderwidth = 200; // Resolution : (resolution), min=0, max=10000

float intensity(in vec4 color)
{
	return sqrt((color.x*color.x)+(color.y*color.y)+(color.z*color.z));
}

vec3 simple_edge_detection(in float step, in vec2 center)
{
	float center_intensity = intensity(texture2D(iChannel0, center));
	int darker_count = 0;
	float max_intensity = center_intensity;
	for(int i = -radius; i <= radius; i++)
	{
		for(int j = -radius; j<= radius; j++)
		{
			vec2 current_location = center + vec2(i*step, j*step);
			float current_intensity = intensity(texture2D(iChannel0,current_location));
			if(current_intensity < center_intensity) 			{ 				darker_count++; 			} 			if(current_intensity > max_intensity)
			{
				max_intensity = current_intensity;
			}
		}
	}
	if((max_intensity - center_intensity) > 0.01*radius)
	{
		if(darker_count/(radius*radius) < (1-(1/radius)))
		{
			return vec3(0.0,0.0,0.0);
		}
	}
	return vec3(1.0,1.0,1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	float step = 1.0/renderwidth;
	vec2 center_color = fragCoord.xy / iResolution.xy;
	fragColor.rgb = simple_edge_detection(step,center_color);
}