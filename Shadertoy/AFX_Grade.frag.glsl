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


// iChannel0: Source, filter=nearest, wrap=clamp
// iChannel1: Mask, filter=nearest, wrap=clamp
// BBox: iChannel0

uniform vec3 s_whitePoint = vec3(1, 1, 1); // White point : (white point)


uniform float temp = 0.0; // Temperature : (Temperature.), min=-1, max=1
uniform float tint = 0.0; // Tint : (Tint), min=-1, max=1
uniform float t_saturation = 1.0; // Saturation : (Saturation.), min=0.0, max=2.0

uniform float offset = 0.0; // Offset : (Offset.), min=-10, max=10
uniform vec3 RGBOffset = vec3(0, 0, 0); // RGB offset : (RGB offset.)

uniform float gamma = 1.0; // Gamma : (Gamma.), min=0.0, max=10
uniform vec3 RGBGamma = vec3(1, 1, 1); // RGB gamma : (RGB gamma.)

uniform float multiply = 1.0; // Multiply : (Multiply.), min=0, max=10
uniform vec3 RGBMultiply = vec3(1, 1, 1); // RGB multiply : (RGB multiply.)

uniform bool premultiplied = false; // Premultiplied : (Source is premultiplied.)
uniform bool useMask = false; // Mask : (Use mask.)

uniform float mixR = 1; // Mix : (Mix.), min=0, max=1




const float ONE_THIRD  = 0.3333333333333333333;
const float TWO_THIRDS = 0.6666666666666666667;




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = vec2(fragCoord.xy / vec2( iResolution.x, iResolution.y ));
	vec4 Source = texture2D(iChannel0, uv);
	float Mask = texture2D(iChannel1, uv).a;	
	vec4 tempResult = vec4(0.0);
	

	vec4 result = Source;
	
	if(premultiplied == true)
		if (Source.a !=0.0)
			result.rgb = Source.rgb / vec3(Source.a);
		else
			result = vec4(0.0);

	if(useMask == false)
		Mask = 1.0;

	// White Balance Pre (adjust tint & temp of white point)
	vec3 x_whitePoint = s_whitePoint;
	vec3 t_whitepoint = vec3(	x_whitePoint.r -=(tint*ONE_THIRD)+(temp*0.5),
								x_whitePoint.g +=(tint*TWO_THIRDS),
								x_whitePoint.b -=(tint*ONE_THIRD)-(temp*0.5));
	

	// Perform Averaged White Balance of Source
	result.rgb = vec3(	result.r / (t_whitepoint.r/((t_whitepoint.r + t_whitepoint.g + t_whitepoint.b)*ONE_THIRD)),
					result.g / (t_whitepoint.g/((t_whitepoint.r + t_whitepoint.g + t_whitepoint.b)*ONE_THIRD)),
					result.b / (t_whitepoint.b/((t_whitepoint.r + t_whitepoint.g + t_whitepoint.b)*ONE_THIRD)) );

	// offset
	result.rgb += vec3(offset);
	result.rgb += RGBOffset;

	// multiply
	result.rgb *= vec3(multiply);
	result.rgb *= RGBMultiply;

	// Gamma - Apparently this is not technically a scene linear gamma adjustment 
	// however this is how Nuke does it sooooo....

	result.rgb = pow( abs(result.rgb), 1.0/vec3(gamma)) * sign(result.rgb);
	result.rgb = vec3( 	pow( abs(result.r), 1.0/RGBGamma.r) * sign(result.r),
					pow( abs(result.g), 1.0/RGBGamma.g) * sign(result.g),
					pow( abs(result.b), 1.0/RGBGamma.b) * sign(result.b));

	// Saturation
	float luma = (0.2126 * result.r) + (0.7152 * result.g) + (0.0722 * result.b);
	result.r = luma + t_saturation * (result.r - luma) ;
	result.g = luma + t_saturation * (result.g - luma) ;
	result.b = luma + t_saturation * (result.b - luma) ;

	if(premultiplied == true)
	{
		tempResult = vec4( result.rgb*vec3(Source.a), Source.a);
		fragColor = mix(Source,tempResult,mixR);
	}
	else
	{
		tempResult = vec4( result.rgb, Source.a);
		fragColor = mix(Source,tempResult,mixR);
	}
}