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
// Code original : crok_fbm-pixels Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_fbm-pixels Matchbox for Autodesk Flame



// based on http://glslsandbox.com/e#23659.0
// by RAZIK anass
// i found noise and hash fonctions in a stack overflow answer
// and i tried to modify it to get this pixel effect
// but the fractional brownian motion function was written by me
// enjoy my pixel world radar :D ^^



uniform float Speed = 1.0; // Speed : (speed), min=-1000, max=1000
uniform float Offset = 0.0; // Offset : (offset), min=-1000, max=1000
uniform int itteration = 12; // Iterations : (iterations), min=1, max=12
uniform float scale = 32; // Scale : (scale), min=-1000, max=1000




float time = iTime *.05 * Speed + Offset;
mat2 rotation_mat = mat2(cos(time/5.0),-sin(time/5.0),sin(time/5.0),cos(time/5.0));




float hash(vec2 n)
{
	float dot_prod = dot(n.y, n.y)+dot(n.x, n.x);
	return fract(cos(time+dot_prod));
}




float noise(vec2 intervale)
{
	vec2 i = floor(intervale);
	vec2 f = fract(intervale);
	vec2 u = f*f*(1.0-2.0*f);
	
	return mix(mix(hash(i+vec2(0.0,0.0)),
		       hash(i+vec2(1.0,.0)), u.x),
		   mix(hash(i+vec2(0.0,1.0)),
		       hash(i+vec2(1.0,1.0)),u.x),
		   u.y);
}




//fractional brownian motion function
float fbm(vec2 p)
{
	float f = 0.0;
	float octave = 0.5;
	float sum = 0.0;
	
	for(int i=0;i<itteration;i++){
		sum 	+= octave;
		f 	+= octave*noise(p);
		p 	*= 2.;
		octave	*= .5;
	}
	
	f /= sum;
	
	return f;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy/iResolution.xy*2.0-1.0;
	uv.x *= iResolution.x/iResolution.y;

	float effect = fbm(scale * uv);
	vec3 color = vec3(effect);
	
	fragColor = vec4(color,1.0);
}