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
// Code original : pixelDisplace Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : pixelDisplace Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Source, filter=linear
// iChannel1: Displace Map, filter=linear
// iChannel2: Mask, filter=linear

// creating user parameters
uniform float scanlineX = 10;  // global X displace, min=-0., max=50.
uniform float scanlineY = 10;  // global Y displace, min=-0., max=50.

uniform float offsetX; // global X offset, min=-0., max=50.
uniform float offsetY; // global Y offset, min=-0., max=50.

uniform float rx = 10; // red X displace, min=-0., max=50.
uniform float ry = 10; // red Y displace, min=-0., max=50.
uniform float gx; // green X displace, min=-0., max=50.
uniform float gy; // green Y displace, min=-0., max=50.
uniform float bx; // blue X displace, min=-0., max=50.
uniform float by; // blue Y displace, min=-0., max=50.


// main function
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	float blender = 0;

	vec2 stDisp;
	stDisp.x = fragCoord.x / iResolution.x;
	stDisp.y = fragCoord.y / iResolution.y;
	
	// get the diplace map input (iChannel1)
	vec4 getDispInput1;
	getDispInput1 = texture2D(iChannel1, stDisp);

	
	vec2 st2;	
	st2.x =( fragCoord.x - (((rx)*getDispInput1.x + (bx) * getDispInput1.z + (gx) * getDispInput1.y)*scanlineX)+ offsetX) / iResolution.x;
	st2.y =( fragCoord.y - (((ry)*getDispInput1.x + (by) * getDispInput1.z + (gy) * getDispInput1.y)*scanlineY)+ offsetY) / iResolution.y;


	// get the displaced image
	vec4 getColorInputDisp;
	getColorInputDisp = texture2D(iChannel0, st2);
	

	vec4 getColorInputDispMap;
	getColorInputDispMap = texture2D(iChannel0, st2);

	// get pixel informations RGB for each input
	vec2 st;
	st.x = fragCoord.x  / iResolution.x;
	st.y = fragCoord.y / iResolution.y;

	// get the image to be displaced
	vec4 getColorInputClean;
	getColorInputClean = texture2D(iChannel0, st);
	
	vec4 outColor;
	outColor =( (getColorInputDisp) );		
	outColor.a = getColorInputDispMap.r;
	
	//process the output
	fragColor = outColor;
}
