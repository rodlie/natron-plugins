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



uniform vec3 c1 = vec3(0.5, 0.0, 0.1); // Color 1 : 
uniform vec3 c2 = vec3(0.9, 0.1, 0.0); // Color 2 : 
uniform vec3 c3 = vec3(0.2, 0.1, 0.7); // Color 3 : 
uniform vec3 c4 = vec3(1.0, 0.9, 0.1); // Color 4 : 
uniform vec3 c5 = vec3(0.1); // Color 5 : 
uniform vec3 c6 = vec3(0.9); // Color 6 : 

uniform float detail = 1.7; // Detail : 
uniform float globalAmplitude = 0.47; // Noise : 

uniform float shiftt = 1.0; // Vignette : 
uniform float distance = 0.0; // Position offset : 

uniform vec2 speed = vec2(1.2, 0.10); // Speed : 
uniform float acceleration = 1.0; // Acceleration : 
uniform float offset = 0.0; // Speed Offset : 



vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float rand(vec2 n) {
    return fract(sin(cos(dot(n, vec2(12.9898,12.1414)))) * 83758.5453);
}

float noise(vec2 n) {
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n, float detail, float amp) {
    float total = 0.0, amplitude = 1.0;
    for (int i = 0; i <5; i++) {
        total += noise(n) * amplitude;
        n += n*detail;
        amplitude *= amp;
    }
    return total;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord ) {

    float globalSpeed = iTime * acceleration;
    float shift = 1.327+sin(globalSpeed*2.0*shiftt)/2.4;
    float alpha = 1.0;
    
    //change the constant term for all kinds of cool distance versions,
    //make plus/minus to switch between 
    //ground fire and fire rain!
	float dist = 3.5-sin(globalSpeed*0.4)/1.89;
    
    vec2 p = fragCoord.xy * dist / iResolution.xx + distance;
    p.x -= globalSpeed/1.1;
    float q = fbm(p - globalSpeed * 0.01+1.0*sin(globalSpeed)/10.0 , detail , globalAmplitude);
    float qb = fbm(p - globalSpeed * 0.002+0.1*cos(globalSpeed)/5.0 , detail , globalAmplitude);
    float q2 = fbm(p - globalSpeed * 0.44 - 5.0*cos(globalSpeed)/7.0 , detail , globalAmplitude) - 6.0;
    float q3 = fbm(p - globalSpeed * 0.9 - 10.0*cos(globalSpeed)/30.0 , detail , globalAmplitude)-4.0;
    float q4 = fbm(p - globalSpeed * 2.0 - 20.0*sin(globalSpeed)/20.0 , detail , globalAmplitude)+2.0;
    q = (q + qb - .4 * q2 -2.0*q3  + .6*q4)/3.8;
    vec2 r = vec2(fbm (p + q /2.0 + globalSpeed + offset * speed.x - p.x - p.y , detail , globalAmplitude), fbm(p + q - globalSpeed * speed.y , detail , globalAmplitude));
    vec3 c = mix(c1, c2, fbm(p + r , detail , globalAmplitude)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
    vec3 color = vec3(c * cos(shift * fragCoord.y / iResolution.y));
    color += .05;
    color.r *= .8;
    vec3 hsv = rgb2hsv(color);
    hsv.y *= hsv.z  * 1.1;
    hsv.z *= hsv.y * 1.13;
    hsv.y = (2.2-hsv.z*.9)*1.20;
    color = hsv2rgb(hsv);
    fragColor = vec4(color.x, color.y, color.z, alpha);
}