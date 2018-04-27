// iChannel0: BufA, filter=linear, wrap=clamp
// iChannel1: BufB, filter=linear, wrap=clamp
// iChannel2: BufC, filter=linear, wrap=clamp
// iChannel3: BufD, filter=linear, wrap=clamp
// Bbox: iChannel1

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
	
    //vec4 s0 = texture2D( iChannel0, uv, -10.0 );
    vec4 s1 = texture2D( iChannel1, uv, -10.0 );

    //vec4 s2 = texture2D( iChannel2, uv, -10.0 );
    vec4 s3 = texture2D( iChannel3, uv, -10.0 );
    
    fragColor = min( s1, s3 ); //octagon
    //fragColor = max( s1, s3 ); //star
}
