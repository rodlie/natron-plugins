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
// Code original : crok_snow Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_snow Matchbox for Autodesk Flame




uniform int Layers = 11; // Layers : (lyers), min=1, max=1000
uniform float Depth = 3; // Depth : (depth), min=0.01, max=5.0
uniform float Wind = 1; // Wind :  (wind), min=-10, max=10
uniform float Speed = 20; // Speed : (speed), min=0, max=10

uniform vec2 Position = vec2(0.5,0.5); // Position : 
uniform float size = 7.0; // Smoothness : (smoothness), min=-7.9, max=500
uniform float rot = 0.0; // Rotation : (rotation), min=-1000, max=1000




vec2 myResolution = vec2(iResolution.x, iResolution.y);
float myGlobalTime = iTime*.05;

// Copyright (c) 2013 Andrew Baldwin (twitter: baldand, www: http://thndl.com)
// License = Attribution-NonCommercial-ShareAlike (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

// "Just snow"
// Simple (but not cheap) snow made from multiple parallax layers with randomly positioned 
// flakes and directions. Also includes a DoF effect. Pan around with mouse.

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	const mat3 p = mat3(13.323122,23.5112,21.71123,21.1212,28.7312,11.9312,21.8112,14.7212,61.3934);
	vec2 uv = (fragCoord.xy / myResolution.xy) - Position;	
	
	float c=cos(rot*0.01),si=sin(rot*0.01);
	uv=(vec2(uv.x- .5, uv.y-1.))*mat2(c,si,-si,c);	
	
	vec3 acc = vec3(0.0);
	float dof = 5.*sin(myGlobalTime*.1);
	for (int i=0;i<Layers;i++) {
		float fi = float(i);
		vec2 q = uv*(1.+fi * Depth);
		q += vec2(q.y*(Wind*mod(fi*7.238917,1.)-Wind*.5),Speed*myGlobalTime/(1.+fi*Depth*.03));
		vec3 n = vec3(floor(q),31.189+fi);
		vec3 m = floor(n)*.00001 + fract(n);
		vec3 mp = (31415.9+m)/fract(p*m);
		vec3 r = fract(mp);
		vec2 s = abs(mod(q,1.)-.5+.9*r.xy-.45);
		s += .01*abs(2. *fract(10.* q.yx)-1.); 
		float d = .6*max(s.x-s.y,s.x+s.y)+max(s.x,s.y)-.01;
		float edge = .005+.05*min(.5 * abs(fi-5.-dof),1.);
		acc += vec3(smoothstep(edge,-edge,d)*(r.x/(1.0 + size/fi)));
	}
	fragColor = vec4(vec3(acc),1.0);
}