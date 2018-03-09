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
// Code original : JB_multiMatteManager Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : JB_multiMatteManager Matchbox for Autodesk Flame


// iChannel0: matte1, filter = nearest
// iChannel1: matte2, filter = nearest
// iChannel2: matte3, filter = nearest
// iChannel3: matte4, filter = nearest
// BBox: iChannel0




uniform bool redChannel1 = true; // Matte1 Red
uniform bool greenChannel1 = true; // Matte1 Green
uniform bool blueChannel1 = true; // Matte1 Blue
// declare the variables (switches for the channels for each input)

uniform bool redChannel2 = true; // Matte2 Red
uniform bool greenChannel2 = true; // Matte2 Green
uniform bool blueChannel2 = true; // Matte2 Blue

uniform bool redChannel3 = true; // Matte3 Red
uniform bool greenChannel3 = true; // Matte3 Green
uniform bool blueChannel3 = true; // Matte3 Blue

uniform bool redChannel4 = true; // Matte4 Red
uniform bool greenChannel4 = true; // Matte4 Green
uniform bool blueChannel4 = true; // Matte4 Blue

uniform bool alphaToRGB = false; // Copy alpha to RGB
uniform bool invertAlpha = false; // Invert alpha




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 st;
	st.x = fragCoord.x / iResolution.x;
	st.y = fragCoord.y / iResolution.y;

	
	vec4 getColorInput1;
	getColorInput1 = texture2D(iChannel0, st);
	
	vec4 getColorInput2;
	getColorInput2 = texture2D(iChannel1, st);

	vec4 getColorInput3;
	getColorInput3 = texture2D(iChannel2, st);

	vec4 getColorInput4;
	getColorInput4 = texture2D(iChannel3, st);	

	
	
	getColorInput1.r *= int(redChannel1);
	getColorInput1.g *= int(greenChannel1);
	getColorInput1.b *= int(blueChannel1);
	
	getColorInput2.r *= int(redChannel2);
	getColorInput2.g *= int(greenChannel2);
	getColorInput2.b *= int(blueChannel2);

	getColorInput3.r *= int(redChannel3);
	getColorInput3.g *= int(greenChannel3);
	getColorInput3.b *= int(blueChannel3);

	getColorInput4.r *= int(redChannel4);
	getColorInput4.g *= int(greenChannel4);
	getColorInput4.b *= int(blueChannel4);

	 
	vec4 result;
	
	result.r = getColorInput1.r + getColorInput2.r + getColorInput3.r + getColorInput4.r;
	result.g = getColorInput1.g + getColorInput2.g + getColorInput3.g + getColorInput4.g;
	result.b = getColorInput1.b + getColorInput2.b + getColorInput3.b + getColorInput4.b;

	
	result.a = result.r +result.b +result.g;



	if (invertAlpha == true) {result.a = 1-result.a;}

	if (alphaToRGB == true)
	{
		result.r = result.a;
		result.g = result.a;
		result.b = result.a;
	}

	fragColor = result;
	
}