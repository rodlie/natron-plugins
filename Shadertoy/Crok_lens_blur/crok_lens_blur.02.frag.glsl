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
// iChannel0: pass1_result , filter = linear , wrap = clamp
// BBox: iChannel0


// based on https://www.shadertoy.com/view/ldXBzB by luluco250


vec2 res = vec2(iResolution.x, iResolution.y);
float time = iTime * 0.05;
//uniform vec2 direction;

int SAMPLES = 10; // Samples : 
uniform float amount = 0.0; // Amount : ,min=0.0
uniform float aspect = 1.0; // Aspect : ,min=0.01, max=2.0

int ANGLE_SAMPLES = 4 * SAMPLES;
int OFFSET_SAMPLES = 1 * SAMPLES;


float degs2rads(float degrees) {
    return degrees * 0.01745329251994329576923690768489;
}

vec2 rot2D(float offset, float angle) {
    angle = degs2rads(angle);
    return vec2(cos(angle) * offset, sin(angle) * offset);
}

vec3 circle_blur(sampler2D sp, vec2 uv, vec2 scale) {
    vec2 ps = (1.0 / res.xy) * scale * amount;
    vec3 col = vec3(0.0);
    float accum = 0.0;

    for (int a = 0; a < 360; a += 360 / ANGLE_SAMPLES) {
        for (int o = 0; o < OFFSET_SAMPLES; ++o) {
			col += texture2D(sp, uv + ps * rot2D(float(o), float(a))).rgb * float(o * o);
            accum += float(o * o);
        }
    }

    return col / accum;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  /*
  if ( aspect > 1.0 )
    direction.x = (direction.x - 1.0) * 10.0 + 1.0; */
  vec2 dir = vec2(1.0);
  dir = vec2(dir.x / aspect, dir.y * aspect);
  vec2 uv = ( fragCoord.xy / res);
  vec3 col = circle_blur(iChannel0, uv, dir);
  fragColor = vec4(col, 1.0);
}
