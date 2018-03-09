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


// iChannel0: source, filter = nearest, wrap0 = clamp
// iChannel1: alpha, filter = nearest, wrap1 = clamp
// BBox: iChannel0

uniform vec3 s_whitePoint = vec3(1, 1, 1); // White point : (white point)


uniform float temp = 0.0; // Temperature : (temperature), min=-1, max=1
uniform float tint = 0.0; // Tint : (tint), min=-1, max=1
uniform float t_saturation = 1.0; // Saturation : (saturation), min=0.0, max=2.0

uniform float offset = 0.0; // Offset : (offset), min=-10, max=10
uniform vec3 RGBOffset = vec3(0, 0, 0); // RGB offset : (RGB offset)

uniform float gamma = 1.0; // Gamma : (gamma), min=0.0, max=10
uniform vec3 RGBGamma = vec3(1, 1, 1); // RGB gamma : (RGB gamma)

uniform float multiply = 1.0; // Multiply : (multiply), min=0, max=10
uniform vec3 RGBMultiply = vec3(1, 1, 1); // RGB multiply : (RGB multiply)

uniform bool premultiplied = false;




const float ONE_THIRD  = 0.3333333333333333333;
const float TWO_THIRDS = 0.6666666666666666667;




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 uv = vec2(fragCoord.xy / vec2( iResolution.x, iResolution.y ));
	vec3 	source 	= texture2D(iChannel0, uv).rgb;
	float 	alpha	= texture2D(iChannel1, uv).r;
	
	vec3 result = source;
	
	if(premultiplied == true)
		if (alpha !=0.0)
			result = source / vec3(alpha);
		else
			result = vec3(0.0);

	// White Balance Pre (adjust tint & temp of white point)
	vec3 x_whitePoint = s_whitePoint;
	vec3 t_whitepoint = vec3(	x_whitePoint.r -=(tint*ONE_THIRD)+(temp*0.5),
								x_whitePoint.g +=(tint*TWO_THIRDS),
								x_whitePoint.b -=(tint*ONE_THIRD)-(temp*0.5));
	

	// Perform Averaged White Balance of Source
	result = vec3(	result.r / (t_whitepoint.r/((t_whitepoint.r + t_whitepoint.g + t_whitepoint.b)*ONE_THIRD)),
					result.g / (t_whitepoint.g/((t_whitepoint.r + t_whitepoint.g + t_whitepoint.b)*ONE_THIRD)),
					result.b / (t_whitepoint.b/((t_whitepoint.r + t_whitepoint.g + t_whitepoint.b)*ONE_THIRD)) );

	// offset
	result += vec3(offset);
	result += RGBOffset;
	// multiply
	result *= vec3(multiply);
	result *= RGBMultiply;

	// Gamma - Apparently this is not technically a scene linear gamma adjustment 
	// however this is how Nuke does it sooooo....

	result = pow( abs(result), 1.0/vec3(gamma)) * sign(result);
	result = vec3( 	pow( abs(result.r), 1.0/RGBGamma.r) * sign(result.r),
					pow( abs(result.g), 1.0/RGBGamma.g) * sign(result.g),
					pow( abs(result.b), 1.0/RGBGamma.b) * sign(result.b));

	// Saturation
	float luma = (0.2126 * result.r) + (0.7152 * result.g) + (0.0722 * result.b);
	result.r = luma + t_saturation * (result.r - luma);
	result.g = luma + t_saturation * (result.g - luma);
	result.b = luma + t_saturation * (result.b - luma);

	if(premultiplied == true)
		fragColor = 	vec4( result*vec3(alpha), alpha);
	else
		fragColor = 	vec4( result, alpha);
}


