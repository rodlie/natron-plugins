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
// Code original : crok_parallax Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_parallax Matchbox for Autodesk Flame

// iChannel0: Source, filter = linear
// BBox: iChannel0


uniform float Speed = 1.0; // Speed : (speed), min=-1000, max=1000
uniform float rot = -15.0; // Rotation : (rotation), min=-1000, max=1000
uniform float intensity = 1.0; // Intensity : (intensity), min=0.1, max=100
uniform float layers = 10.0; // Layers : (layers), min=1, max=1000
uniform float spacing = 5.0; // Spacing : (spacing), min=0.1, max=1000

uniform vec2 center;




float time = iTime *.05 * Speed;
vec2 res = vec2(iResolution.x, iResolution.y);


void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 uv = (fragCoord.xy / res.xy) - center;
	vec3 col = vec3(0.0);
	vec3 matte = vec3(1.0);
	
	// rotatation
	float c=cos(rot*0.01),si=sin(rot*0.01);
	uv *=mat2(c,si,-si,c);	

    
    for(float i=0.0; i<layers; i+=1.0) 
	{
    	float s=texture2D(iChannel0,uv*(1.0/i*spacing)+vec2(time)*vec2(0.02,0.501)+vec2(i, i/2.3)).r;
    	col=mix(col,vec3(1.0),smoothstep(0.9,1.0, s * intensity));
		matte=mix(matte,vec3(1.0 / i),smoothstep(0.9, 0.91, s * intensity));
	}

	fragColor = vec4(col,matte);
}