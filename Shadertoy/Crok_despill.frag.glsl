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
// Code original : crok_despill Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_despill Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Foreground, filter = nearest, wrap=clamp
// iChannel1: Background, filter = nearest, wrap=clamp
// iChannel2: Alpha, filter = nearest, wrap=clamp
// iChannel3: Despilled, filter = nearest, wrap=clamp


uniform float minInput = 0.0; // Min input : (min input), min=0.0, max=10.0
uniform float maxInput = 0.5; // Max input : (max input), min=0.0, max=10.0


vec3 saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

vec3 multiply( vec3 s, vec3 d )
{
	return s*d;
}

vec3 difference( vec3 s, vec3 d )
{
	return abs(d - s);
}

vec3 linearDodge( vec3 s, vec3 d )
{
	return s + d;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec3 c = vec3(0.0);
	
	// front 
	vec3 f = texture2D(iChannel0, uv).rgb;
	// back
	vec3 b = texture2D(iChannel1, uv).rgb;
	// matte
	float m = texture2D(iChannel2, uv).r;
	// despilled front
	vec3 d = texture2D(iChannel3, uv).rgb;
	// difference despilled FG and FG
	c = difference(d,f);
	
	
	// do some 2D Histogramm adjustments
	c = min(max(c - vec3(minInput), vec3(0.0)) / (vec3(maxInput) - vec3(minInput)), vec3(1.0));
	// desaturate the image
	c = saturation(c, 0.0);
	
	// multiply Result and BG
    c = multiply(c,b);
	
	// add despilled FG on top of Result
   	c =  linearDodge(d,c);
	
	// add beautiful despilled result ontop of the BG with a Matte
    c = vec3(m * c + (1.0 - m) * b);
	
	
	fragColor = vec4(c, m);
}