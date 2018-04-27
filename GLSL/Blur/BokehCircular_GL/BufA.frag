// iChannel0: Source, filter=mipmap, wrap=clamp
// iChannel1: Modulate (Image containing a factor to be applied to the Blur size in the first channel), filter=linear, wrap=clamp
// Bbox: iChannel0

uniform float blurdist_px = 8.0; // Blur Size (The blur size, in pixels.), min=0., max=100.
uniform int NUM_SAMPLES = 6; // No. Samples (The number of samples used at each level. Higher values yield less noise.), min=1, max=20.
uniform bool perpixel_size = false; // Modulate (Modulate the blur size by multiplying it by the first channel of the Modulate input)
const float blur_factor = 0.25; // factor on the blur size (empirical)

const vec2 iRenderScale = vec2(1.,1.);

float hash12n(vec2 p)
{
    p  = fract(p * vec2(5.3987, 5.4421));
    p += dot(p.yx, p.xy + vec2(21.5351, 14.3137));
    return fract(p.x * p.y * 95.4307);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    float blur_r = blurdist_px * iRenderScale.x * blur_factor;
    if (perpixel_size) {
        blur_r *= texture2D(iChannel1, (fragCoord.xy-iChannelOffset[1].xy)/iChannelResolution[1].xy).x;
    }

    float da = 6.283 / float(NUM_SAMPLES);
    float a = da * hash12n(uv+iGlobalTime);

    vec4 sumcol = vec4(0.0);
    for (int i=0;i<NUM_SAMPLES;++i)
    {
        vec2 ofs = vec2( cos(a), sin(a) ) * blur_r;
        vec2 p = uv + ofs / iResolution.xy;

	vec4 sample = texture2D( iChannel0, p, -10.0 );
        sumcol += sample;

        a += da;
    }
    sumcol /= float(NUM_SAMPLES);
    sumcol = max( sumcol, 0.0 );

    fragColor = sumcol;
}
