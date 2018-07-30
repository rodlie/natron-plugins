// https://www.shadertoy.com/view/4dcXWs

// A simple HDR bloom.

// Probably not the best (or most efficient) way to create a blur, but works for what I've done. I've also exaggerated the blur to show it off, because the videos aren't HDR :P

// iChannel0: Source, filter=linear, wrap=clamp
// iChannel1: LensDirt, filter=mipmap, wrap=repeat
// BBox: iChannel0

//Bloom Settings
uniform float BLOOM_THRESHOLD = 0.7; // Bloom Threshold : (how bright a pixel needs to be to become blurred)
uniform float BLOOM_INTENSITY = 3.0; // Bloom Intensity : (how bright the bloom effect is)

//Blur Settings
uniform float BLUR_ITERATIONS = 3;   // Blur Iterations : (how many times a blur is created)
uniform float BLUR_SIZE = 0.03;      // Blur Size : (the radius of the bloom)
uniform int BLUR_SUBDIVISIONS = 32;  // Blur Subdivisions : (how many times the texture is sampled per iteration)


uniform bool LENS_DIRT = false;      // Use Lens Dirt : (draws lens dirt on the screen)
uniform float DIRT_INTENSITY = 2.5;  // Dirt Intensity : (how intense the dirt effect is)

uniform bool BLOOM_ONLY = false; // Bloom Only : (only shows the blur created by bloom)



vec3 getHDR(vec3 tex) {
 
    return max((tex - BLOOM_THRESHOLD) * BLOOM_INTENSITY, 0.);
    
}

vec3 gaussian(sampler2D sampler, vec2 uv) {
 
    vec3 sum = vec3(0.);
    
    for(int i = 1; i <= BLUR_ITERATIONS; i++) {
     
        float angle = 360. / float(BLUR_SUBDIVISIONS);
        
        for(int j = 0; j < BLUR_SUBDIVISIONS; j++) {
         
            float dist = BLUR_SIZE * (float(i+1) / float(BLUR_ITERATIONS));
            float s    = sin(angle * float(j));
            float c	   = cos(angle * float(j));
            
            if (LENS_DIRT)
            {
                sum += getHDR(texture2D(sampler, uv + vec2(c,s)*dist).xyz);
            }

            else
            {
                vec3 dirt = texture2D(iChannel1, uv).rgb * DIRT_INTENSITY;
                sum += getHDR(texture2D(sampler, uv+vec2(c,s)*dist).xyz) * dirt;
            }
            
        }
        
    }
    
    sum /= float(BLUR_ITERATIONS * BLUR_SUBDIVISIONS);
    return sum * BLOOM_INTENSITY;
    
}

vec3 blend(vec3 a, vec3 b) {
 
    return 1. - (1. - a)*(1. - b);
    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 tx = texture2D(iChannel0, uv);
    
    fragColor.xyz = gaussian(iChannel0, uv);
    fragColor.a   = tx.a;

    if (BLOOM_ONLY)
    {
        fragColor.xyz = blend(tx.xyz, fragColor.xyz);
    }

}
