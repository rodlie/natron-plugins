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
// Code original : JB_autoMatte pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : JB_lidar autoMatte for Autodesk Flame

// iChannel0: Source, filter = nearest



uniform bool algo = fasle; // Ponderate : (ponderate)
uniform int iterations = 2; // Iterations : (iterations), min=0, max=100



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st0 = fragCoord.xy / iResolution.xy;

	
	vec4 getColPixel0;
	getColPixel0 = texture2D(iChannel0, st0);
	
	vec4 color;
	vec2 st1;
	vec2 st2;
	vec2 st3;
	vec4 getColPixel1;		
		
		
		
		
	color = getColPixel0;
	float colorBuffer;
	int count=0;
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x+x) / iResolution.x;
		st1.y = (fragCoord.y+y) / iResolution.y;
		if ( (fragCoord.x+x) >=0 && (fragCoord.x+x) <= iResolution.x){getColPixel1 = texture2D(iChannel0, st1);}
		if ( (fragCoord.y+y) >=0 && (fragCoord.y+y) <= iResolution.y){getColPixel1 = texture2D(iChannel0, st1);}		
		color += getColPixel1;count++;
		}
	count++;
	}
	
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x-x) / iResolution.x;
		st1.y = (fragCoord.y+y) / iResolution.y;
		if ( (fragCoord.x-x) >=0 && (fragCoord.x-x) <= iResolution.x){getColPixel1 = texture2D(iChannel0, st1);}
		if ( (fragCoord.y+y) >=0 && (fragCoord.y+y) <= iResolution.y){getColPixel1 = texture2D(iChannel0, st1);}		
		color += getColPixel1;count++;
		}
	count++;
	}
	
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x+x) / iResolution.x;
		st1.y = (fragCoord.y-y) / iResolution.y;
		if ( (fragCoord.x+x) >=0 && (fragCoord.x+x) <= iResolution.x){getColPixel1 = texture2D(iChannel0, st1);}
		if ( (fragCoord.y-y) >=0 && (fragCoord.y-y) <= iResolution.y){getColPixel1 = texture2D(iChannel0, st1);}		
		color += getColPixel1;count++;
		}
	count++;
	}
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x-x) / iResolution.x;
		st1.y = (fragCoord.y-y) / iResolution.y;
		if ( (fragCoord.x-x) >=0 && (fragCoord.x-x) <= iResolution.x){getColPixel1 = texture2D(iChannel0, st1);}
		if ( (fragCoord.y-y) >=0 && (fragCoord.y-y) <= iResolution.y){getColPixel1 = texture2D(iChannel0, st1);}		
		color += getColPixel1;count++;
		}
	count++;
	}
	color/=count;
	if (algo==true){color+=getColPixel0;
	color/=2;}

	float buffer = 1;
	
	if (color.r>=color.b && color.r>=color.g ){color.r=1; color.g=0; color.b=0;}
	if (color.g>=color.r && color.g>=color.b ){color.r=0; color.g=1; color.b=0;}
	if (color.b>=color.r && color.b>=color.g ){color.r=0; color.g=0; color.b=1;}

	vec4 outColor;
	fragColor =  color;
}
