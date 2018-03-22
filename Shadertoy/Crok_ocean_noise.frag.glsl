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
// Code original : crok_ocean_noise Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_ocean_noise Matchbox for Autodesk Flame




uniform float zoom_red = 0.5; // Zoom red : ,min=-10000, max=10000
uniform float Speed_red = -0.5; // Speed red : ,min=-10000, max=10000
uniform float Offset_red = 1.0; // Offset red : ,min=-10000, max=10000

uniform float zoom_green = 2.5; // Zoom green :,min=-10000, max=10000
uniform float Speed_green = 1.5; // Speed green : ,min=-10000, max=10000
uniform float Offset_green = 8.0; // Offset green : ,min=-10000, max=10000

uniform float zoom_blue = 15.0; // Zoom blue :,min=-10000, max=10000
uniform float Speed_blue = -1.5; // Speed blue : ,min=-10000, max=10000
uniform float Offset_blue = 3.0; // Offset blue : ,min=-10000, max=10000

uniform float saturation = 0.0; // Saturation : ,min=0.0, max=1000
uniform float brightness = 0.5; // Brightness : ,min=0.0, max=1000
uniform float contrast = 1.2; // Contrast : ,min=0.0, max=1000

uniform vec3 tint_col = vec3(0.6 , 0.85 , 1.0); // Tint colour : 
uniform float tint = 1.0; // Amount : ,min=0.0, max=1000




float time = iTime *.05;

const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);

// http://pixelshaders.com/examples/noise.html


float random(float p) {
  return fract(sin(p)*10000.);
}

float noise(vec2 p) {
  return random(p.x + p.y*10000.);
}

vec2 sw(vec2 p) {return vec2( floor(p.x) , floor(p.y) );}
vec2 se(vec2 p) {return vec2( ceil(p.x)  , floor(p.y) );}
vec2 nw(vec2 p) {return vec2( floor(p.x) , ceil(p.y)  );}
vec2 ne(vec2 p) {return vec2( ceil(p.x)  , ceil(p.y)  );}

float smoothNoise(vec2 p) {
  vec2 inter = smoothstep(0. , 1., fract(p));
  float s = mix(noise(sw(p)), noise(se(p)), inter.x);
  float n = mix(noise(nw(p)), noise(ne(p)), inter.x);
  return mix(s, n, inter.y);
  return noise(nw(p));
}

float movingNoise_red(vec2 p) {
  float total = 0.0;
  total += smoothNoise(p     - time * Speed_red + Offset_red);
  total += smoothNoise(p*2.  + time * Speed_red + Offset_red) / 2.;
  total += smoothNoise(p*4.  - time * Speed_red + Offset_red) / 4.;
  total += smoothNoise(p*8.  + time * Speed_red + Offset_red) / 8.;
  total += smoothNoise(p*16. - time * Speed_red + Offset_red) / 16.;
  total += smoothNoise(p*32. + time * Speed_red + Offset_red) / 32.;
  total += smoothNoise(p*64. - time * Speed_red + Offset_red) / 64.;
  total += smoothNoise(p*128. + time * Speed_red + Offset_red) / 128.;

  total /= 1. + 1./2. + 1./4. + 1./8. + 1./16. + 1./32. + 1./64. + 1./128.;
  return total;
}

float nestedNoise_red(vec2 p) 
{
  float x = movingNoise_red(p);
  float y = movingNoise_red(p + 10.);
  return movingNoise_red(p + vec2(x, y));
}

float movingNoise_green(vec2 p) {
  float total = 0.0;
  total += smoothNoise(p     - time * Speed_green + Offset_green);
  total += smoothNoise(p*2.  + time * Speed_green + Offset_green) / 2.;
  total += smoothNoise(p*4.  - time * Speed_green + Offset_green) / 4.;
  total += smoothNoise(p*8.  + time * Speed_green + Offset_green) / 8.;
  total += smoothNoise(p*16. - time * Speed_green + Offset_green) / 16.;
  total += smoothNoise(p*32. + time * Speed_green + Offset_green) / 32.;
  total += smoothNoise(p*64. - time * Speed_green + Offset_green) / 64.;
  total += smoothNoise(p*128. + time * Speed_green + Offset_green) / 128.;

  total /= 1. + 1./2. + 1./4. + 1./8. + 1./16. + 1./32. + 1./64. + 1./128.;
  return total;
}

float nestedNoise_green(vec2 p) 
{
  float x = movingNoise_green(p);
  float y = movingNoise_green(p + 10.);
  return movingNoise_green(p + vec2(x, y));
}

float movingNoise_blue(vec2 p) {
  float total = 0.0;
  total += smoothNoise(p     - time * Speed_blue + Offset_blue);
  total += smoothNoise(p*2.  + time * Speed_blue + Offset_blue) / 2.;
  total += smoothNoise(p*4.  - time * Speed_blue + Offset_blue) / 4.;
  total += smoothNoise(p*8.  + time * Speed_blue + Offset_blue) / 8.;
  total += smoothNoise(p*16. - time * Speed_blue + Offset_blue) / 16.;
  total += smoothNoise(p*32. + time * Speed_blue + Offset_blue) / 32.;
  total += smoothNoise(p*64. - time * Speed_blue + Offset_blue) / 64.;
  total += smoothNoise(p*128. + time * Speed_blue + Offset_blue) / 128.;

  total /= 1. + 1./2. + 1./4. + 1./8. + 1./16. + 1./32. + 1./64. + 1./128.;
  return total;
}

float nestedNoise_blue(vec2 p) 
{
  float x = movingNoise_blue(p);
  float y = movingNoise_blue(p + 10.);
  return movingNoise_blue(p + vec2(x, y));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 uv = (fragCoord.xy / iResolution.xy);
    vec3 avg_lum = vec3(0.5, 0.5, 0.5);
	
	float col_red = nestedNoise_red(2.0 * (uv - 0.5) * zoom_red);
	float col_green = nestedNoise_green( 2.0 * (uv - 0.5) * zoom_green);
	float col_blue = nestedNoise_blue( 2.0 * (uv - 0.5) * zoom_blue);
	
	vec3 intensity = vec3(dot(vec3(col_red, col_green, col_blue), LumCoeff));
	vec3 sat_color = mix(intensity, vec3(col_red, col_green, col_blue ), saturation);
    vec3 con_color = mix(avg_lum, sat_color, contrast);
	vec3 brt_color = con_color - 1.0 + brightness;
	vec3 fin_color = mix(brt_color, brt_color * tint_col, tint);
	
		
    fragColor = vec4(fin_color, 1.0);

}