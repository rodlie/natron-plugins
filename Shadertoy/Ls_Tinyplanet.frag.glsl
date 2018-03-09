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
//
// Adapted to Natron by F.Fernandez
// Original code : Ls_Tinyplanet Matchbox for Autodesk Flame
//

// Stereographic projection of a 360x180 latlong panorama, tiny planets style
// lewis@lewissaunders.com


uniform float xo = 0.5; // X centre : (x centre), min=-2., max=2.
uniform float yo = 0.5; // Y centre : (y centre), min=-2., max=2.
uniform float long0 = 0.25333333333; // X rotate : (x rotate), min=-1000., max=1000.
uniform float lat1 = -0.70666666666; // Y rotate : (y rotate), min=-1000., max=1000.
uniform float r = 0.17; // Zoom : (zoom), min=-1., max=2.


uniform float latm = 0.31830988618379069; // Latitude mult : (latitude mult), min=-30., max=30.
uniform float longm = 0.15915494309189535; // Longitude mult : (longitude mult), min=-30., max=30.
uniform float lato = -1.5707963267948966; // Latitude offset : (latitude offset), min=-30., max=30.
uniform float longo = -3.1415926535897932; // Longitude offset : (longitude offset), min=-30., max=30.



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 res = vec2(iResolution.x, iResolution.y);
	vec2 coords = fragCoord.xy / res;
	coords.x -= 0.5;
	coords.x *= (res.x / res.y);
	coords.x += 0.5;

	float p = sqrt((coords.x-xo)*(coords.x-xo)+(coords.y-yo)*(coords.y-yo));
	float c = 2.0 * atan(p, 2.0 * r);
	float longg = (long0 + atan((coords.x-xo)*sin(c), p*cos(lat1)*cos(c) - (coords.y-yo)*sin(lat1)*sin(c)));
	float lat = asin(cos(c)*sin(lat1) + (((coords.y-yo)*sin(c)*cos(lat1)) / p));
	vec2 uv;
	uv.x = (longg - longo) * longm;
	uv.y = (lat - lato) * latm;

	vec3 o = texture2D(iChannel0, uv).rgb;

	fragColor = vec4(o, 1.00);
}
