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
// Code original : crok_beer Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_beer Matchbox for Autodesk Flame

// iChannel0: Texture, filter = nearest
// BBox: iChannel0

vec2 resolution = vec2(iResolution.x, iResolution.y);
float time = iTime*.05;




uniform float sphsize = 1.0; // Sphere size : (sphere size), min=-10000, max=10000
uniform float dist = 1.0; // Distorsion : (distorsion), min=-10000, max=10000
uniform float perturb = 50.0; // Flow noise : (flow noise), min=-10000, max=10000
uniform float stepsize = 1.0; // Step size : (step size), min=-10000, max=10000
uniform float brightness = 0.8; // Brightness (brightness), min=0.0, max=100.0

uniform vec3 tint = vec3(1.0,0.65,0.35); // Colour : (colour)
uniform vec3 Speed = vec3(0.0,0.0,0.1); // Speed : (speed)

uniform float fade = 0.0; // Fade : (fade), min=0.0, max=1.0
uniform float glow = 1.5; // Glow : (glow), min=0.0, max=100.0

uniform int iterations = 11; // Iterations : (iterations), min=1, max=11

uniform vec2 center = vec2(0.0,0.0); // Center : (center)

uniform float size = 1.0; // Zoom : (zoom), min=-10000, max=10000
uniform float fractparam = 0.7; // Fractal Param : (fractal param), min=0.0, max=2.0

const vec3 offset=vec3(20.54,142.,-1.55); // Offset : (offset)
const float steps = 16.0; // Steps : (steps)
const float displacement = 1.0; // Displacement : (displacement)


float wind(vec3 p) {
	float d=max(0.,dist-max(0.,length(p)-sphsize)/sphsize)/dist;
	float x=max(0.2,p.x*2.);
	p.y*=1.+max(0.,-p.x-sphsize*.25)*1.5;
	p-=d*normalize(p)*perturb;
	p+=vec3(time*Speed.x,time*Speed.y,time*Speed.z);
	p=abs(fract((p+offset)*.1)-.5);
	for (int i=0; i<iterations; i++) {  
		p=abs(p)/dot(p,p)-fractparam;
	}
	return length(p)*(1.2+d*glow*x)+d*glow*x;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 uv = 0.15 * size * ( 2.0 * fragCoord.xy - resolution.xy ) / (0.5 * (resolution.x + resolution.y)) - center;
	vec3 dir=vec3(uv,1.);
	dir.x*=resolution.x/resolution.y;
	vec3 from=vec3(0.,0.,-2.+texture2D(iChannel0,uv*.5+time).x*0.07*stepsize); //from+dither
	float v=0., l=-0.0001, t=time*Speed.x*.2;
    vec3 p;
    float tx;
	for (float r=10.;r<steps;r++) {
		p=from+r*dir*0.07*stepsize;
		tx=texture2D(iChannel0,uv*.2+vec2(t,0.)).x*displacement;
		
        v+=min(50.,wind(p))*max(0.,1. - 0.7 - r*0.015*fade); 
	}
	
    v/=steps; v*=brightness;
	vec3 col=vec3(v*tint.r,v*tint.g,v*tint.b);

	col *= (0.75-length(sqrt(3.0 * uv*uv)));
	col *= length(col) * 50.0;
	fragColor = vec4(col,1.0);
}