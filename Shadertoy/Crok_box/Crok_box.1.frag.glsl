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
// Code original : crok_box Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_box Matchbox for Autodesk Flame

// pass2 : scale box

// based on https://www.shadertoy.com/view/Xs33DN



uniform float corner = 0.0; // Roundness : ,min=0.0, max=10000
uniform vec2 Scale = vec2(0.99,0.99); // Aspect : 
uniform bool square = true; // Square : 

vec2 res = vec2(iResolution.x, iResolution.y);


float udRoundBox( vec2 p, vec2 b, float r )
{
	return length(max(abs(p)-b+r,0.0))-r;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 coord = fragCoord.xy;
    float myFrameratio = iResolution.x / iResolution.y;
	
	
	if ( square == true )
	{
		coord.x -= ((iResolution.x - iResolution.y) / 2.0 );
		res.x /= myFrameratio / 1;
	}
	
    float w = Scale.x * res.x;
    float h = Scale.y * res.y;
	
    coord.x -= ( res.x / 2.0 ) - ( w / 2.0 );
    res.x = w;

    coord.y -= ( res.y / 2.0 ) - ( h / 2.0 );
    res.y = h;
	
	

    float f = udRoundBox( coord.xy-(res.xy - 1500.0)/2.0, (res.xy - 1500.0)/2.0, corner + 1.0);
	float s = udRoundBox( (coord.xy-res.xy/2.0), res.xy/2.0, corner + 1.0);
    f = ((f>0.0) ? 0.0 : 1.0);
    fragColor = vec4(s * -1.);
}