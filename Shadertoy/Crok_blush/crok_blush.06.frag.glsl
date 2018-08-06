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
// Code original : crok_blush Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_blush Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: result_pass1,filter=linear,wrap=clamp
// iChannel1: result_pass3,filter=linear,wrap=clamp
// iChannel2: result_pass5,filter=linear,wrap=clamp
// BBox: format


// loading high blur and low blur doing the bandpass


uniform float gain = 1.0; // Gain : (gain), min=-1000.0, max=1000.0
uniform float contrast = 1.0; // Contrast : (contrast), min=0.0, max=10.0
uniform float saturation = 1.0; // Saturation : (saturation), min=0.0, max=10.0

uniform int output_selection = 2; // Selection : ,min=0, max=2

// Real contrast adjustments by  Miles
vec3 adjust_contrast(vec3 col, vec4 con){
vec3 c = con.rgb * vec3(con.a);
vec3 t = (vec3(1.0) - c) / vec3(2.0);
t = vec3(.18);
col = (1.0 - c.rgb) * t + c.rgb * col;
return col;
}

vec3 adjust_saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

float overlay( float s, float d )
{
	return (d < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
}

vec3 overlay( vec3 s, vec3 d )
{
	vec3 c;
	c.x = overlay(s.x,d.x);
	c.y = overlay(s.y,d.y);
	c.z = overlay(s.z,d.z);
	return c;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y);
	vec3 h_blur = texture2D(iChannel1, uv).rgb;
	vec3 l_blur = texture2D(iChannel2, uv).rgb;
  vec3 f = texture2D(iChannel0, uv).rgb;
  float m = texture2D(iChannel0, uv).a;

	//doing the bandpass
	vec3 c = l_blur - h_blur;

	//adjust gain
	c *= gain;

	// adjust contrast
	c = adjust_contrast(c, vec4(contrast));

  // adjust saturation
  c = adjust_saturation(c, saturation);

  // output bandpass only
  if( output_selection == 0 ){
    // add a pure gray to it
    c = c;
  }

  // output bandpass + pure gray
  else if( output_selection == 1 ){
    // add a pure gray to it
    c += 0.5;
  }

  else if( output_selection == 2 ){
    // overlay processed front and original via matte
    c += 0.5;
    c = overlay( c, f );
    c = vec3(m * c + (1.0 - m) * f);
  }

	fragColor = vec4(c, m);
}
