const vec2 blurdir = vec2( 1.0, 0.0 );

const float blurdist_px = 8.0;
const int NUM_SAMPLES = 6;

vec3 srgb2lin(vec3 c) { return c*c; }
vec3 lin2srgb(vec3 c) { return sqrt(c); }

//note: uniform pdf rand [0;1[
float hash12n(vec2 p)
{
	p  = fract(p * vec2(5.3987, 5.4421));
    p += dot(p.yx, p.xy + vec2(21.5351, 14.3137));
	return fract(p.x * p.y * 95.4307);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;

    float blur_r = (iMouse.z>0.5) ? 32.0 * iMouse.x/iResolution.x : blurdist_px;
    blur_r *= 2.0; //empiric constant...
    
    float da = 6.283 / float(NUM_SAMPLES);
    float a = da * hash12n(uv+fract(iTime) + 4.2);
    
    
    vec3 sumcol = vec3(0.0);
    for (int i=0;i<NUM_SAMPLES;++i)
    {
        vec2 ofs = vec2( cos(a), sin(a) ) / iResolution.xy * blur_r;
        vec2 p = uv + ofs;
       	sumcol += srgb2lin(texture(iChannel0, p, -10.0).rgb);
        a += da;
    }
    sumcol /= float(NUM_SAMPLES);
    sumcol = max( sumcol, 0.0 );
    
    fragColor = vec4( lin2srgb( sumcol ), 1.0 );
}

