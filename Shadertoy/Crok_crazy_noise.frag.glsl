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
// Code original : crok_crazy_noise Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_crazy_noise Matchbox for Autodesk Flame


// iChannel0: Source, filter=linear, wrap=clamp
// BBox: iChannel0

uniform float Speed = 5.0; // Speed : (speed)
uniform float Offset = 0.0; // Offset : (offset)
uniform float Contrast = 5.0; // Contrast : (contrast)
uniform float Steps = 3.0; // Steps : (steps)
uniform float Resolution_X = 2.5; // Resolution x : (resolution x)
uniform float Resolution_Y = 2.1;; // Resolution y : (resolution y)
uniform float Morph = 100.0; // Morph : (morph)
uniform float Zoom = 2.0; // Zoom : (zoom)
uniform float Detail = 5.0; // Detail : (detail)
uniform float Density = 0.3; // Density : (density)




float myGlobalTime = iTime*.004;

// created by ztri


float time = 0.0;
	 
vec3 rotate(vec3 r, float v){ return vec3(r.x*cos(v)+r.z*sin(v),r.y,r.z*cos(v)-r.x*sin(v));}

float noise( in vec3 x )
{
	float  z = x.z*Morph;
	vec2 offz = vec2(0.437,0.123);
	vec2 offt = vec2(time*0.001,time*-0.005);
	vec2 uv1 = x.xy + offz*floor(z) + offt; 
	vec2 uv2 = uv1  + offz;
	return mix(texture2D( iChannel0, uv1 ,-100.0).x,texture2D( iChannel0, uv2 ,-100.0).x,fract(z))-0.5;
}

float noises( in vec3 p){
	float a = 0.0;
	p.y *= Resolution_Y;
	for(float i=1.0;i<Steps;i++){
		a += noise(p)/i;
		p = p*Resolution_X + vec3(i*a*0.1,a*0.1,a*0.0);
	}
	return a;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{	
    time        = myGlobalTime*Speed+Offset;
    vec2 uv     = fragCoord.xy/(iResolution.xx*0.5)-vec2(1.0,iResolution.y/iResolution.x);
    vec3 cam    = vec3(time*0.5,cos(time*0.2)*10.0,0.0);
    vec3 ray   = rotate(normalize(vec3(uv.x,uv.y,0.5).xyz),sin(time*0.3));
    vec3 pos    = cam+ray*-Zoom; 
        	
    float test  = 0.0;
    float dist   = 0.0;
    for(int i=0;i<20;i++){
        test = noises(pos*Density*.05)*Detail-0.2; 
        pos += ray*test;
		dist += test;
    }
	
	vec4 col = vec4((vec3(1.0,1.0,0.95)+ray.y*0.3+(sin(pos*0.1)*0.03)-abs(dist*Contrast*.03)+dot(uv,uv)*0.3),1.0);
	col = sqrt(abs(col+0.001));
	fragColor = col;
}