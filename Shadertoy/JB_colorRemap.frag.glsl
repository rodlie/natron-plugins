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
// Code original : AFX_Grade Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : AFX_Grade Matchbox for Autodesk Flame


// iChannel0: source 1, filter = nearest, wrap0 = clamp
// iChannel1: source 2, filter = nearest, wrap1 = clamp


uniform bool inverseFlag = false; // Invert sources : (invert sources)

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	int inverseSource = 0;
	if (inverseFlag == true)
		inverseSource = 1;

	vec2 st1;
	st1.x = fragCoord.x / iResolution.x;
	st1.y = fragCoord.y / iResolution.y;
	
	vec4 getDispInput;
	getDispInput = texture2D(iChannel0, st1);
	

	vec2 stDisp;
	stDisp.x = (getDispInput.x + getDispInput.z) ;
	stDisp.y = (getDispInput.y + getDispInput.z);
	
	vec4 getDispiChannel0;
	getDispiChannel0 = texture2D(iChannel1, stDisp);

	vec4 outColor;
	fragColor = (1-inverseSource)*getDispiChannel0+((1*inverseSource)+(-1*inverseSource) * getDispiChannel0);
}
