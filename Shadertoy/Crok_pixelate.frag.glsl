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
// Code original : crok_pixelate Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_pixelate Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest, wrap = clamp
// iChannel1: Mask, filter = nearest, wrap = clamp
// BBox: iChannel0

uniform float Detail = 100; // details : (details), min=0., max=500.
uniform bool Aspect = true; // keep aspect ratio : (keep aspect ratio).
uniform bool perpixel_matte = true; // Modulate (Modulate the amplitude by multiplying it by the first channel of the Modulate input)
uniform int maskChannel = 3; // Channel : (Channel used as mask.), min=0, max=3


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 resolution = (fragCoord.xy , iResolution.xy);
	vec2 uv = fragCoord.xy / iResolution.xy;

	vec2 aspect = vec2(1.0);
	
	if ( Aspect )
	    aspect = vec2(1.0, resolution.x/resolution.y);
			
    vec2 size = vec2(aspect.x/Detail, aspect.y/Detail);
    vec2 pix_uv = uv - mod(uv - 0.5,size);

	vec4 color1 = vec4( texture2D(iChannel0, pix_uv ).rgba);
	vec4 original = vec4( texture2D(iChannel0, uv ) );
	vec4 matte =  vec4( texture2D(iChannel1, pix_uv).a);

	if(maskChannel == 0)
		matte.a = matte.r;
	if(maskChannel == 1)
		matte.a = matte.g;
	if(maskChannel == 2)
		matte.a = matte.b;



	if (perpixel_matte)
		fragColor = vec4 (mix(original.rgb, color1.rgb, matte.a) , mix(original.a, color1.a, matte.a) );
		
    else
    	fragColor = vec4 (color1.rgb,color1.a);
}