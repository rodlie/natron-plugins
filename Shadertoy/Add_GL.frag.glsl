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
// iChannel0: B, filter = nearest
// iChannel1: A, filter = nearest
// iChannel2: Mask, filter = nearest
// BBox: iChannel0


uniform int blendingMode = 17; // Operation : (blending mode), min=0., max=25.
uniform float opacity = 1; // Mix : (mix), min=0., max=1.

uniform bool Ar = true; // A.Red
uniform bool Ag = true; // A.Green
uniform bool Ab = true; // A.Blue
uniform bool Aa = true; // A.Alpha

uniform bool Br = true; // B.Red
uniform bool Bg = true; // B.Green
uniform bool Bb = true; // B.Blue
uniform bool Ba = true; // B.Alpha



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 uv = fragCoord.xy / iResolution.xy;

	// source texture (upper layer)
	vec4 s = texture2D(iChannel1, uv);
	
	// destination texture (lower layer)
	vec4 d = texture2D(iChannel0, uv);

	// mask texture (mask entry)
	vec4 mask = texture2D(iChannel2, uv);


	if(Ar == false)
		s.r = 0;

	if(Ag == false)
		s.g = 0;

	if(Ab == false)
		s.b = 0;

	if(Aa == false)
		s.a = 0;

	if(Br == false)
		d.r = 0;

	if(Bg == false)
		d.g = 0;

	if(Bb == false)
		d.b = 0;

	if(Ba == false)
		d.a = 0;

		
	vec4 result = s + d;


	// multiplying the result by the opacity
	fragColor = mix(d, result, mask.a*opacity);
}