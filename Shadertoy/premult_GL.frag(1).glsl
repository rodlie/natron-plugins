// iChannel0: rgba, filter = nearest
// BBox: iChannel0


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 source = texture2D(iChannel0, uv);
	source.rgb *= source.a;

	fragColor = source;
}