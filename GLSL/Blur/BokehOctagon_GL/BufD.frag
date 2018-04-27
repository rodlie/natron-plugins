// iChannel0: BufC, filter=linear, wrap=clamp
// iChannel1: Modulate (Image containing a factor to be applied to the Blur size in the first channel), filter=linear, wrap=clamp
// Bbox: iChannel0

const vec2 blurdir = vec2( 1.0, -1.0 );

uniform float blurdist_px = 64.0; // Blur Size (Blur distance in pixels), min=0., max=64
uniform int NUM_SAMPLES = 16; // No. Samples (Number of samples per pass), min=1, max=32
uniform bool perpixel_size = false; // Modulate (Modulate the blur size by multiplying it by the first channel of the Modulate input)

const vec2 iRenderScale = vec2(1.,1.);

//note: uniform pdf rand [0;1[
float hash12n(vec2 p)
{
    p  = fract(p * vec2(5.3987, 5.4421));
    p += dot(p.yx, p.xy + vec2(21.5351, 14.3137));
    return fract(p.x * p.y * 95.4307);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 blurvec = normalize(blurdir);
    vec2 uv = fragCoord / iResolution.xy;
    float blurdist = blurdist_px * iRenderScale.x;
    if (perpixel_size) {
        blurdist *= texture2D(iChannel1, (fragCoord.xy-iChannelOffset[1].xy)/iChannelResolution[1].xy).x;
    }

    vec2 p0 = fragCoord - 0.5 * blurdist * blurvec;
    vec2 p1 = fragCoord + 0.5 * blurdist * blurvec;
    vec2 stepvec = (p1-p0) / float(NUM_SAMPLES)/ iResolution.xy;
    vec2 p = p0 / iResolution.xy + (hash12n(uv+iGlobalTime)-0.5) * stepvec;

    vec4 sumcol = vec4(0.0);
    for (int i=0;i<NUM_SAMPLES;++i)
    {
     	sumcol += texture2D( iChannel0, p, -10.0 );
        p += stepvec;
    }
    sumcol /= float(NUM_SAMPLES);

    fragColor = sumcol;
}
