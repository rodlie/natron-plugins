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
// Code original : Ls_Glint Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Glint Matchbox for Autodesk Flame


// iChannel0: Source, filter = linear , wrap = clamp
// iChannel1: Mask, filter = linear , wrap = clamp
// BBox: iChannel0


// Glint pass 1: convolve with a dynamically generated star function
// lewis@lewissaunders.com


// TODO: option to downres / process / upres, as request by GP-M



uniform float threshold = 0.6;              // Threshold : (Highlights darker than this are ignored), min=0.0, max=200.0
uniform float thresholdclamp = 5.0;         // Threshold Clamp : (Highlights brighter than this don't increase the glint further, to avoid hot pixels creating huge stars), min=0.0, max=200.0

uniform float gain = 40.0;                  // Gain : (Overall brightness of stars), min=0.0, max=2000.0
uniform float size = 50.0;                  // Size : (Size of the stars), min=0.01, max=400.0
uniform float rays = 6.0;                   // Rays : (How many points each star has), min=0.0, max=100.0
uniform float spin = 48.0;                  // Spin : (Rotate the stars), min=-360.0, max=360.0
uniform float falloff = 1.9;                // Falloff : (Dissolves away ends of rays), min=-2.0, max=4.0
uniform float twirl = 0.0;                  // Twirl : (Bend the arms of the stars), min=-1080.0, max=1080.0
uniform float barrel = 0.0;                 // Barrel Distort : (Bend stars around center of frame), min=-10.0, max=10.0
uniform float barrelbend = 2.0;             // Barrel Bend : (Bendiness of barrel distortion), min=1.0, max=20.0
uniform float saturation = 0.7;             // Saturation : (How much star colour comes from the underlying image), min=-10.0, max=10.0
uniform float extrasize = 1.0;              // Extra Size : (Extra multiplier on size if you want extra big glints - it will get slow, be careful!), min=0.01, max=20.0
uniform float extrarays = 1.0;              // Extra Rays : (Extra multiplier on ray count if you want many more ray arms - it will get slow, be careful!), min=0.01, max=20.0

uniform vec3 tint = vec3( 1.0 , 1.0 , 1.0); // Tint : (Tint the stars towards this colour)

uniform bool dirton = false; // Use Noise : 
uniform bool usematte = false; // Use Matte on Glint Source : (Generate glints only from highlights inside the matte; the matte can also be RGB to selectively tint the stars)
uniform bool useblendmatte = false; // Use Matte to Blend (faster) : (Only processes pixels inside the matte - this is really fast for small mattes, but glints will be cut off at the matte edge)

uniform vec2 dirtParam = vec2( 0.1, 5.0 ); // Dirt Parameters : 

uniform vec3 dispDispOffsetDispCycles = vec3( 0.25 , -45.0 , 1.0 ); // Dispersion Parameters : 

uniform vec2 aspectAA = vec2( 1.0 , 1.4 ); // Aspect and AA samples : 



#define realsize (size*extrasize)
#define samples (size*extrasize*aspectAA.y)
#define tau (2.0*3.1415926535)

// RGB to Rec709 YPbPr
vec3 yuv(vec3 rgb) {
    return mat3(0.2215, -0.1145, 0.5016, 0.7154, -0.3855, -0.4556, 0.0721, 0.5, -0.0459) * rgb;
}

// Rec709 YPbPr to RGB
vec3 rgb(vec3 yuv) {
    return mat3(1.0, 1.0, 1.0, 0.0, -0.1870, 1.8556, 1.5701, -0.4664, 0.0) * yuv;
}

// Noise
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453) - 0.5;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / vec2(iResolution.x, iResolution.y);
    vec3 frontpix = texture2D(iChannel0, uv).rgb;
    vec3 mattepix = texture2D(iChannel1, uv).rgb;
    vec3 sample, glint = vec3(0.0);
    vec2 offset;
    float angle;

    // If matte is being used to blend with, we can take a massive shortcut where it's black
    if(useblendmatte && (length(mattepix) < 0.0001)) {
        fragColor = vec4(frontpix, 0.0);
        return;
    }

    // Iterate around rays
    for(float ray = 0.0; ray < floor(rays*extrarays); ray++) {
        // Figure out what angle this ray is at
        angle = ray * tau/floor(rays*extrarays);

        // Spin rotates entire glint
        angle -= spin/360.0 * tau;

        // Iterate along arm of ray
        for(float i = realsize/samples; i < realsize; i += realsize/samples) {
            // Twirl ray around further as we move out
            angle -= (twirl/samples * i/realsize)/360.0 * tau;

            // Offset along ray direction
            offset = i/vec2(iResolution.x, iResolution.y) * vec2(cos(angle), sin(angle));

            // Horizontal stretch/squash for anamorphic glints
            offset.x *= aspectAA.x;

            // Barrel pushes ends of rays away towards edge of frame
            offset -= pow((i/realsize), barrelbend) * 0.1 * barrel * (-uv+vec2(0.5, 0.5));

            // Read a pixel
            sample = texture2D(iChannel0, uv + offset).rgb;

            // Affect it by the matte
            if(usematte) {
                sample *= texture2D(iChannel1, uv + offset).rgb;
            }

            // Only keep pixels over threshold
            sample = min(sample, thresholdclamp);
            sample *= max(sample - threshold, 0.0);

            // Falloff darkens the ray ends
            if(falloff > 1.0) {
                sample *= max(0.0, mix(1.0, -falloff+2.0, i/realsize));
            } else {
                sample *= max(0.0, mix(falloff, 1.0, i/realsize));
            }

            // Do saturation in YUV
            vec3 sampley = yuv(sample);
            sampley.gb *= saturation;

            // Hue varies along length of ray
            float hue = dispDispOffsetDispCycles.b * tau *-i/realsize;
            hue -= dispDispOffsetDispCycles.g/360.0 * tau;

            // I'm adventurously using YUV to do a rainbow tint here
            // The discontinuities in the usual HSV method bug me
            // and are probably slower than this, which just requires
            // matrix mults and a bit of trig
            // Hue is the angle around centre of UV plane
            vec2 rainbow = vec2(cos(hue), sin(hue)) * sampley.r;
            sampley.gb = mix(sampley.gb, rainbow, dispDispOffsetDispCycles.r * i/realsize);
            sample = rgb(sampley);

            if(dirton) {
                // Multiply by a bit of noise texture
                float noiz = rand(vec2(42.1, 12.4) + 0.01 * vec2(dirtParam.y/100.0)   * offset);
                noiz +=      rand(vec2(4.1, 1.4)   + 0.01 * vec2(dirtParam.y/1000.0)  * offset);
                noiz +=      rand(vec2(2.1, 2.4)   + 0.01 * vec2(dirtParam.y/10000.0) * offset);
                sample *= mix(1.0, clamp(10.0 * noiz, 0.0, 99.0), dirtParam.x);
            }

            // Accumulate
            glint += sample;
        }
    }
    // Normalise all our accumulated samples
    glint /= floor(rays*extrarays) * samples;

    // Master brightness
    glint *= gain;

    // Tint in YUV space
    vec3 glinty = yuv(glint);
    vec3 tinty = yuv(tint);
    tinty.gb *= glinty.r; // If U/V aren't 0 when Y is black, bad things happen...
    glinty.gb = mix(glinty.gb, tinty.gb, 4.0*length(tinty.gb));
    glint = rgb(glinty);

    fragColor = vec4(glint, 0.0);
}
