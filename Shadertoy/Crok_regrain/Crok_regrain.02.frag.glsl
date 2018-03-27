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
// Code original : crok_regrain Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_regrain Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter=linear, wrap=repeat
// BBox: iChannel0

vec2 resolution = vec2(iResolution.x, iResolution.y);
uniform vec3 rgb_blur = vec3(0.0,0.0,0.0); // Softness : 

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 uv = fragCoord.xy / resolution;
    int denominator = 0;
    const float intensity = 1.0;
    vec2 pixelWidth = vec2(1.0)/resolution.xy * intensity;
    const int size = 5;

	vec3 noise = texture2D(iChannel0, uv).rgb;

	if ( rgb_blur != vec3(0.0) )
        {
		    for (int x=-size; x<size; x++) {
		        for (int y=-size; y<size; y++) {

		        	float fx_r = float(x) * pixelWidth.x*rgb_blur.r;
		           	float fy_r = float(y) * pixelWidth.y*rgb_blur.r;
					noise.r += texture2D(iChannel0, uv + vec2(fx_r,fy_r)).r;

		        	float fx_g = float(x) * pixelWidth.x*rgb_blur.g;
		           	float fy_g = float(y) * pixelWidth.y*rgb_blur.g;
					noise.g += texture2D(iChannel0, uv + vec2(fx_g,fy_g)).g;

		        	float fx_b = float(x) * pixelWidth.x*rgb_blur.b;
		           	float fy_b = float(y) * pixelWidth.y*rgb_blur.b;
					noise.b += texture2D(iChannel0, uv + vec2(fx_b,fy_b)).b;

		        	denominator++;
		        }
		    }
			noise /= float(denominator);
        }
		fragColor.rgb = noise;
	}
