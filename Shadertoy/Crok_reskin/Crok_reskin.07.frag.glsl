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
// Code original : crok_reskin Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_reskin Matchbox for Autodesk Flame

// iChannel0: pass1_result, filter=linear, wrap=clamp
// iChannel1: pass2_result, filter=linear, wrap=clamp
// iChannel2: pass4_result, filter=linear, wrap=clamp
// iChannel3: pass6_result, filter=linear, wrap=clamp
// BBox: iChannel0

// divide and multiply to get a highpass image
// then comp the clean skin with the pimple matte
// after that divide and multiply everything to get back to a healed image;)


uniform bool en_highpass = false; // Enable highpass : 

vec2 res = vec2(iResolution.x, iResolution.y);

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = ( fragCoord.xy / res);
	// load original image
	vec3 o = texture2D(iChannel0, uv).rgb;
	// get pimple matte
	float m = texture2D(iChannel0, uv).a;
	// load clean skin image
	vec3 s = texture2D(iChannel1, uv).rgb;
	//load blurred original image
	vec3 b = texture2D(iChannel2, uv).rgb;
	//load blurred clean skin
	vec3 bs = texture2D(iChannel3, uv).rgb;

	// divide org by blurred source
	vec3 c = o / (b + 0.000000001);

	// multiply with gray image to get highpass image
	c = 0.5 * c;
	vec3 high_c = c;

	// divide clean skin by blurred skin
	vec3 cs = s / (bs + 0.000000001);

	// multiply with gray image to get highpass image
	cs = 0.5 * cs;

	//comp clean fg on top of source with pimple matte
	c = vec3(m * cs + (1.0 - m) * c);

	// divide cleaned highpass image by mid gray
	c = c / 0.5;
	// multiply with blurred image to get back to normal image
	c = b * c;

	if ( en_highpass )
		c = high_c;

	fragColor = vec4(c, m);
}
