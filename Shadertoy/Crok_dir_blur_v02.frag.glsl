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
// Code original : crok_dir_blur Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_dir_blur Matchbox for Autodesk Flame


// iChannel0: Source, filter = linear, wrap = repeat
// iChannel1: Mask, filter = nearest, wrap = clamp
// BBox: iChannel0


uniform float gain = 1; // gain : (gain), min = 0., max = 50.
uniform float iterations = 10; // iterations : (iterations), min = 2, max = 50.
uniform float blur_x = 1; // X blur : (X blur), min = 0, max = 1000.
uniform float blur_y = 0; // Y blur : (Y blur), min = 0, max = 1000.

uniform bool perpixel_size = false; // Modulate (Modulate the amplitude by multiplying it by the first channel of the Modulate input)
uniform int maskChannel = 3; // Mask : (mask channel), min=0, max=3

float random(vec3 scale, float seed)
{
    return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 8643.5453 + seed);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 mask = texture2D(iChannel1, uv);
	vec2 direction;
	direction = vec2(blur_x,blur_y);
    float noise = random(vec3(543.12341, 74.30434, 13123.4234234), 2.0);
    vec4 color = vec4(0.0);
    float ws = 0.0;

    if (perpixel_size)
    {
    	if (maskChannel == 1)
    	{
    		mask.r = mask.g;
    	}

    	if (maskChannel == 2)
    	{
    		mask.r = mask.b;
    	}

    	if (maskChannel == 3)
    	{
    		mask.r = mask.a;
    	}
    }

    else
    {
    	mask.r = 1;
    }
    

	for(float steps = -iterations; steps <= iterations; steps++)
    {
        float p = (steps + noise - 0.5) / 16.0 * mask.r;
        float w = 1.0 - abs(p) * mask.r;
        color += texture2D(iChannel0, uv + direction*.02 * p) * w;
        ws += w;
    }

	fragColor = vec4(color.rgb / ws * gain, 1.0);

}