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
//                 MM.  .MMM            	   M        MMM.  .MM
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
// Adaptation pour Natron par F. Fernandez
// Code original : crok_convolve Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_convolve Matchbox for Autodesk Flame

// created by Pitzik4 in 16/5/2013


// setting inputs names and filtering options
// iChannel0: Source, filter = nearest
// BBox: iChannel0



uniform float pCv = 1; // blur radius (blur radius), min=-0., max=20.
uniform float quality = 5; // blur quality (blur quality), min=-0.1., max=20

#define PI 3.141592
#define PI2 6.283184


vec4 colorat(vec2 uv) 
{
	return texture2D(iChannel0, uv);
}


vec4 convolve(vec2 uv) 
{
	vec4 col = vec4(0.0);
	for(float r0 = 0.0; r0 < 1.0; r0 += 0.1 / quality )
	 {
		float r = r0 * pCv*.01;
		for(float a0 = 0.0; a0 < 1.0; a0 += 0.1 / quality) 
		{
			float a = a0 * PI2;
			col += colorat(uv + vec2(cos(a), sin(a)) * r);
		}
	}
	col *= 0.1 / quality * 0.1 / quality;
	return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	fragColor = convolve(uv);
}