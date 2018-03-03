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
// Code original : L_Fstop Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_Fstop Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=clamp
// iChannel1: Modulate (Image containing a factor to be applied to the Exposure in the first channel), filter=linear, wrap=clamp
// BBox: iChannel0

const vec2 iRenderScale = vec2(1.,1.);
const vec2 iChannelOffset[4] = vec2[4]( vec2(0.,0.), vec2(0.,0.), vec2(0.,0.), vec2(0.,0.) );

uniform float valR = 1; // R_Exposure, min=-0., max=10.
uniform float valG = 1; // G_Exposure, min=-0., max=10.
uniform float valB = 1; // B_Exposure, min=-0., max=10.

uniform float valRGB = 1.0; // RGB_Exposure, min=-0., max=10.

uniform bool perpixel_matte = false; // Modulate (Modulate the amplitude by multiplying it by the first channel of the Modulate input)



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
		
    vec4 color0 = texture(iChannel0, uv);
    vec4 color1 = texture(iChannel1, uv);

    color1.r = color1.a;
    color1.g = color1.a;
    color1.b = color1.a;

    // activation ou désactivation de l'entrée modulate
    if (perpixel_matte) {
    					}
    else {
    	 color1.r = 1;
         color1.g = 1;
         color1.b = 1;
         }


    float sumR = valRGB + valR -2;
    float sumG = valRGB + valG -2;
    float sumB = valRGB + valB -2;

	float red0 = ( color0.r * pow ( 2, sumR ) ) ;
	float redResult = (red0 * color1.r) + ( color0.r * (1 - color1.r) );
	

	float green0 = ( color0.g *  pow ( 2, sumG ) ) ;
	float greenResult = (green0 * color1.g) + ( color0.g * (1 - color1.g) );


	float blue0 = ( color0.b *  pow ( 2, sumB ) ) ;
	float blueResult = (blue0 * color1.b) + ( color0.b * (1 - color1.b) );


	fragColor = vec4(redResult, greenResult, blueResult, 1);
}
