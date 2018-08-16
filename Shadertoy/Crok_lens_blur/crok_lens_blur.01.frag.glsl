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
// Code original : crok_lens_blur Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_lens_blur Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Source , filter = linear , wrap = clamp
// BBox: iChannel0


// based on https://www.shadertoy.com/view/ldXBzB by luluco250


vec2 res = vec2(iResolution.x, iResolution.y);
float time = iTime * 0.05;



uniform float HDR_CURVE = 4.0; // HDR Curve : 
uniform float threshold = 0.9; // Threshold : ,min=0.0, max=10.0
uniform float gain = 1.0; // Gain : ,min=0.0, max=10.0
uniform float amount = 0.0; // Amount : ,min=0.0



vec3 saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = ( fragCoord.xy / res);
  vec4 col = texture2D(iChannel0, uv);

  float luma = saturation(col.rgb, 0.0).r;
  float t = step(threshold, luma);
  col.rgb = mix(col.rgb, col.rgb * gain * (amount * 1.5 + 1.), t);
  fragColor = col;
}
