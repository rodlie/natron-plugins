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
// Code original : crok_vhs Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_vhs Matchbox for Autodesk Flame



uniform float contrast = 1.0; // Contrast : (contrast), min=0.001, max=10.0

vec2 res = vec2(iResolution.x, iResolution.y);
float time = iTime * 0.05;


#define ITERATIONS 2
#define HASHSCALE1 .1031

// Real contrast adjustments by  Miles
float adjust_contrast(float col, float con)
{
float t = .18;
col = (1.0 - con) * t + con * col;

return col;
}

float hash12(vec2 p)
{
	vec3 p3  = fract(vec3(p.xyx) * HASHSCALE1);
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.x + p3.y) * p3.z);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = (fragCoord.xy / res.xy);
  vec2 position = fragCoord.xy;
  float a = 0.0;
  for (int t = 0; t < ITERATIONS; t++)
  {
      float v = float(t+1)*.152;
      vec2 pos = (position * v + time * 1500. + 50.0);
      a += hash12(pos);
  }
  float col = a / float(ITERATIONS);
  col = adjust_contrast(col, contrast +0.2);
  fragColor = vec4(col);
}
