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
// Code original : JB_lidar pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : JB_lidar Matchbox for Autodesk Flame

// iChannel0: Source, filter = nearest
// iChannel1: Previous, filter = nearest
// iChannel2: Next, filter = nearest

// BBox: iChannel0



uniform bool lumaColor = true; // Use color : (use color)
uniform int pixelSize = 1; // Point size : (point size), min=1, max=10

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st0 = fragCoord.xy / iResolution.xy;

	
	vec4 getColPixel0;
	getColPixel0 = texture2D(iChannel0, st0);
	
	float luma = (getColPixel0.r + getColPixel0.g + getColPixel0.b)/3;
	
	vec4 getColPixel1;
	
	getColPixel1 = texture2D(iChannel1, st0);
	float luma1 = (getColPixel1.r + getColPixel1.g + getColPixel1.b)/3;

	vec4 getColPixel2;
	
	getColPixel2 = texture2D(iChannel2, st0);
	float luma2 = (getColPixel2.r + getColPixel2.g + getColPixel2.b)/3;
	
	float buffer = (luma + luma1 +luma2)/3;
	vec4 resultColor;
	resultColor=vec4(vec3(0),1);
	int pixelRatio;
	pixelRatio = int(luma*20);
	
	if (buffer>= (luma*0.9)){resultColor=vec4(vec3(0),1);}
	if (mod((fragCoord.x+0.5),pixelRatio)>=pixelSize && mod((fragCoord.y+0.5),pixelRatio)>=pixelSize){
	
	if (buffer<(luma*0.9)){
		resultColor = vec4(luma*exp(buffer), luma1*exp(buffer), luma2*exp(buffer),1);
		if (luma >= luma1 && luma >= luma2){resultColor = vec4(1*luma, 0, 0,1);}
		if (luma1 >= luma && luma >= luma2){resultColor = vec4(0, 1*luma, 0,1);}
		if (luma2 >= luma1 && luma >= luma){resultColor = vec4(0, 0, 1*luma,1);};}

	
	;}
	
	if (lumaColor == true){
	
		if (buffer>= (luma*0.9)){resultColor=vec4(vec3(0),1);}
		if (mod((fragCoord.x+0.5),pixelRatio)>=pixelSize && mod((fragCoord.y+0.5),pixelRatio)>=pixelSize){
	
			if (buffer<(luma*0.9)){
			
			resultColor = vec4(luma*exp(buffer), luma1*exp(buffer), luma2*exp(buffer),1);
			resultColor = vec4(getColPixel0.r, getColPixel0.g, getColPixel0.b,1)
			
			;}
		;}
	;}
	
	fragColor = resultColor;
	
}
