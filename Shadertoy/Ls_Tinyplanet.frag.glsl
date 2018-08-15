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
// Code original : Ls_Tinyplanet Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Tinyplanet Matchbox for Autodesk Flame


// iChannel0: Source,filter=linear,wrap=repeat
// BBox: iChannel0

// Stereographic projection of a 360x180 latlong panorama, tiny planets style
// lewis@lewissaunders.com


vec2 center = iMouse.xy /iResolution.xy;

uniform float long0 = 0.25333333333; // Rotate X : , min=-10000.0, max=10000
uniform float lat1 = -0.70666666666; // Rotate Y : , min=-10000.0, max=10000
uniform float r = 0.17; // Zoom : , min=0.0001, max=2.0

uniform float latm = 0.31830988618379069; // Lal Mult : ,min=-30.0, max=30.0
uniform float longm = 0.15915494309189535; // Long Mult : ,min=-30.0, max=30.0
uniform float lato = -1.5707963267948966; // Lat Offset : ,min=-30.0, max=30.0
uniform float longo = -3.1415926535897932; // Long Offset : ,min=-30.0, max=30.0


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 res = vec2(iResolution.x, iResolution.y);
	vec2 coords = fragCoord.xy / res;
	coords.x -= 0.5;
	coords.x *= (res.x / res.y);
	coords.x += 0.5;

	float p = sqrt((coords.x-center.x)*(coords.x-center.x)+(coords.y-center.y)*(coords.y-center.y));
	float c = 2.0 * atan(p, 2.0 * r);
	float longg = (long0 + atan((coords.x-center.x)*sin(c), p*cos(lat1)*cos(c) - (coords.y-center.y)*sin(lat1)*sin(c)));
	float lat = asin(cos(c)*sin(lat1) + (((coords.y-center.y)*sin(c)*cos(lat1)) / p));
	vec2 uv;
	uv.x = (longg - longo) * longm;
	uv.y = (lat - lato) * latm;

	vec4 o = texture2D(iChannel0, uv);

	fragColor = o;
}
