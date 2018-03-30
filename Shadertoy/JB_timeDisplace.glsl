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
// Code original : JB_timeDisplace Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : JB_timeDisplace Matchbox for Autodesk Flame


// iChannel0: Input 1, filter=linear, wrap=clamp
// iChannel1: Input 2, filter=linear, wrap=clamp
// iChannel2: previous frame, filter=linear, wrap=clamp
// iChannel3: next frame, filter=linear, wrap=clamp
// BBox: iChannel0




uniform float redTS = 1.0; // Red timeshift : 
uniform float greenTS = 1.0; // Green timeshift : 
uniform float blueTS = 1.0; // Blue timeshift : 

uniform int iterations = 2; // Iterations : 
uniform bool interpolate = false; // Interpolate




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st0;
	st0.x = fragCoord.x / iResolution.x;
	st0.y = fragCoord.y / iResolution.y;
	
	vec4 getColPixel0;
	getColPixel0 = texture2D(iChannel0, st0);
	
	vec3 color;
	vec2 st1;
	vec2 st2;
	vec2 st3;
	vec4 getColPixel1;		
		
   	vec3 prev = texture2D( iChannel2, st0 ).rgb;
  	vec3 next = texture2D( iChannel3, st0 ).rgb;
   	vec3 curr = texture2D( iChannel0, st0 ).rgb;
		
		
		
	color = getColPixel0.rgb;
	float colorBuffer;
	int count=0;
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x+x) / iResolution.x;
		st1.y = (fragCoord.y+y) / iResolution.y;
		if ( (fragCoord.x+x) >=0 && (fragCoord.x+x) <= iResolution.x){getColPixel1 = texture2D(iChannel1, st1);}
		if ( (fragCoord.y+y) >=0 && (fragCoord.y+y) <= iResolution.y){getColPixel1 = texture2D(iChannel1, st1);}		
		color += getColPixel1.rgb;count++;
		}
	count++;
	}
	
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x-x) / iResolution.x;
		st1.y = (fragCoord.y+y) / iResolution.y;
		if ( (fragCoord.x-x) >=0 && (fragCoord.x-x) <= iResolution.x){getColPixel1 = texture2D(iChannel1, st1);}
		if ( (fragCoord.y+y) >=0 && (fragCoord.y+y) <= iResolution.y){getColPixel1 = texture2D(iChannel1, st1);}		
		color += getColPixel1.rgb;count++;
		}
	count++;
	}
	
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x+x) / iResolution.x;
		st1.y = (fragCoord.y-y) / iResolution.y;
		if ( (fragCoord.x+x) >=0 && (fragCoord.x+x) <= iResolution.x){getColPixel1 = texture2D(iChannel1, st1);}
		if ( (fragCoord.y-y) >=0 && (fragCoord.y-y) <= iResolution.y){getColPixel1 = texture2D(iChannel1, st1);}		
		color += getColPixel1.rgb;count++;
		}
	count++;
	}
	for (int x = 0; x <=iterations; x++)
	{
		for (int y = 1; y<= iterations; y++)
		{
		st1.x = (fragCoord.x-x) / iResolution.x;
		st1.y = (fragCoord.y-y) / iResolution.y;
		if ( (fragCoord.x-x) >=0 && (fragCoord.x-x) <= iResolution.x){getColPixel1 = texture2D(iChannel1, st1);}
		if ( (fragCoord.y-y) >=0 && (fragCoord.y-y) <= iResolution.y){getColPixel1 = texture2D(iChannel1, st1);}		
		color += getColPixel1.rgb;count++;
		}
	count++;
	}
	color/=count;
	float buffer = 1;
	vec3 outcolor = curr;
	if ((color.r*redTS)>=(color.b*blueTS) && (color.r*redTS)>=(color.g*greenTS) ){outcolor = next;if (interpolate == true){outcolor = (next+curr)*0.5;}}
	if ((color.g*greenTS)>=(color.r*redTS) && (color.g*greenTS)>=(color.b*blueTS) ){outcolor = curr;}
	if ((color.b*blueTS)>=(color.r*redTS) && (color.b*blueTS)>=(color.g*greenTS) ){outcolor = prev;if (interpolate == true){outcolor = (next+prev)*0.5;}}

	vec4 outColor;
	fragColor =  vec4(outcolor,1.0);
}
