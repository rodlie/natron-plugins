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
// Code original : AFX_DeSpill Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : AFX_DeSpill Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Source, filter = nearest
// BBox: iChannel0

uniform float amount = 1; // despill amount : (despill amount), min=0., max=1.
uniform float fineTune = 0.5; // fine tune :, min=0, max=1.
uniform float delta2 = 1; // delta :, min=0, max=1.
uniform int type; // despill type (despill type: 0: green suppress, 1: blue suppress, 2: red suppress), min=-0., max=2.

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 source = texture2D(iChannel0,uv);


	vec4 result 		= texture2D(iChannel0,uv);
	vec4 suppressed 	= texture2D(iChannel0,uv);

	if(type == 0)
		suppressed.g 		= min( ( (source.r*fineTune) + (source.b*fineTune) ), suppressed.g);	
	else if(type == 1)
		suppressed.b 		= min( ( (source.g*fineTune) + (source.r*fineTune) ), suppressed.b);
	else if(type == 2)
		suppressed.r 		= min( ( (source.g*fineTune) + (source.b*fineTune) ), suppressed.r);	

	result					= mix( source, suppressed, amount );

	fragColor 	= 	vec4(result);
}