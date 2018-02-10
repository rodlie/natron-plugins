// iChannel0: Source (Source image.), filter=linear, wrap=clamp
// BBox: iChannel0

uniform vec3 key = vec3(0.); // key to despill
uniform float lower = 0.; // lower, min=0., max=1.
uniform float upper = 1.; // upper, min=0., max=1.
uniform float gamma = 1.; // gamma,  min=0., max=5.
uniform float desaturation = 1.; // desaturation, min=0., max=1.
uniform float hueshift = 0.; // hue shift, min=0., max=1. 

vec3 rgb2hsl(vec3 rgb) {
  vec3 hsl;

  float mx = max(rgb.r,max(rgb.g, rgb.b));
  float mn = min(rgb.r, min(rgb.g, rgb.b));
  float chroma = mx - mn;

  if (chroma == 0.) {
    hsl.x = 0.;
  } else if (mx == rgb.r) {
    hsl.x = (rgb.g - rgb.b) / chroma;
  } else if (mx == rgb.g) {
    hsl.x = (rgb.b - rgb.r) / chroma + 2;
  } else if (mx == rgb.b) {
    hsl.x = (rgb.r - rgb.g) / chroma + 4;
  } else {
    hsl.x = 0.;
  }
  if (hsl.x < 0) hsl.x += 6.;
  hsl.x /= 6.;
  
  hsl.z = (mx + mn) / 2.;

  if (hsl.z < 1.) {
    hsl.y = chroma / (1.-abs(2.*hsl.z-1.));
  } else {
    hsl.y = 0.;
  }
  return hsl;
}

vec3 hsl2rgb(vec3 hsl) {
  vec3 rgb;
  float chroma = (1. - abs(2. * hsl.z - 1.)) * hsl.y;
  float pos = hsl.x * 6.;
  float x = chroma * (1. - abs(mod(pos, 2.) - 1.));
  if (pos < 1.) rgb = vec3(chroma, x, 0.);
  else if (pos < 2.) rgb = vec3(x, chroma, 0.);
  else if (pos < 3.) rgb = vec3(0., chroma, x);
  else if (pos < 4.) rgb = vec3(0., x, chroma);
  else if (pos < 5.) rgb = vec3(x, 0., chroma);
  else if (pos < 6.) rgb = vec3(chroma, 0., x);
  else rgb = vec3(0., 0., 0.);

  float m = hsl.z - chroma / 2.;
  rgb += m;
  return rgb;
}

float lerp(float v, float fromA, float fromB, float toA, float toB) {
  return (v - fromA) / (fromB - fromA) * (toB - toA) + toA;
}

float levels(float v, float lower, float upper, float gamma) {
  return pow(clamp(lerp(v, lower, upper, 0., 1), 0., 1.), gamma);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
  vec2 uv = fragCoord.xy / iResolution.xy;
  vec3 rgb = texture2D(iChannel0, uv).rgb;
  vec3 hsl = rgb2hsl(rgb); // convert to hsl
  vec3 keyhsl = rgb2hsl(key); // convert to ssl

  float dist = hsl.x - keyhsl.x; // find the distance to the target hue
  if (dist < -0.5) dist += 1.;
  if (dist > 0.5) dist -= 1.;
  float sg = sign(dist); // get the sign
  dist = 2. * abs(dist); // map from (-0.5, 0., 0.5) to (1., 0., 1.)

  dist = levels(dist, lower, upper, gamma); // do levels to the distance

  hsl.y *= pow(dist, desaturation); // desaturate based on hue distance
  hsl.x += hueshift * (1. - dist) * sg; // hue shift to match the surrounding
  while (hsl.x < 0.) hsl.x += 1.;
  while (hsl.x >= 1.) hsl.x -= 1.;
  vec3 final = hsl2rgb(hsl); // convert to rgb
  fragColor = vec4(final, 1.);
}