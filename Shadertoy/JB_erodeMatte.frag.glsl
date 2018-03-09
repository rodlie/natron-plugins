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
// Code original : JB_erodematte Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : JB_erodematte Matchbox for Autodesk Flame


// iChannel0: source, filter = nearest, wrap0 = clamp



uniform int alias = 0; // 2 steps : (2 steps), min=0, max=1
uniform int iterations = 2; // Iterations : (iterations), min=0, max=100

void mainImage( out vec4 fragColor, in vec2 fragCoord )

{

	vec2 st0;
	st0.x = fragCoord.x / iResolution.x;
	st0.y = fragCoord.y / iResolution.y;
	
	vec4 getColPixel0;
	getColPixel0 = texture2D(iChannel0, st0);

	vec4 color;
	vec2 st1;
	vec2 st2;
	vec2 st3;
	vec2 st4;
	vec2 st5;
	vec2 st6;
	vec2 st7;
	vec2 st8;
	vec4 getColPixel1;
	vec4 getColPixel2;
	vec4 getColPixel3;
	vec4 getColPixel4;
	vec4 getColPixel5;
	vec4 getColPixel6;
	vec4 getColPixel7;
	vec4 getColPixel8;
		
		
		
		
		
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
	float buffer = 1;
	
	if (((color.x+color.y+color.z)/3)<(buffer*0.33)){color=vec4(0);}
	if (((color.x+color.y+color.z)/3)>=(buffer*0.33)&&((color.x+color.y+color.z)/3)<(buffer*0.51)){color=getColPixel0;if(alias!=0){color=vec4(0.5);}}
	if (((color.x+color.y+color.z)/3)>=(buffer*0.51)){color=vec4(1);}


	fragColor = color;
}
