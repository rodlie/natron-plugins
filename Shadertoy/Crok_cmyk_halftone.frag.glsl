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
// Code original : crok_cmyk_halftone Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_cmyk_halftone Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Source, filter = linear
// iChannel1: Mask, filter = nearest
// BBox: iChannel0


uniform float pMin = 2; // minimum : (minimum), min=0., max=20.
uniform float pMax = 4; // maximum : (maximum), min=0., max=20.

uniform float pDotsize = 3; // gain : (gain), min=0., max=20.
uniform float pScale = 8; // scale : (scale), min=0., max=20.
uniform bool useMask = false; // Use mask : (Use mask input.)

float currentFrame = iFrame *.5;

#define D2R(d) radians(d)
#define SST 0.888
#define SSQ 0.288

vec2 ORIGIN = 0.5*iResolution.xy;
float S = pMin+(pMax-pMin)*(0.5-0.5*cos(0.57*currentFrame));
float R = 0.57*0.333*currentFrame;

vec4 rgb2cmyki(in vec4 c)
{
	float k = max(max(c.r,c.g),c.b);
	return min(vec4(c.rgb/k,k),1.0);
}

vec4 cmyki2rgb(in vec4 c)
{
	return vec4(c.rgb*c.a,1.0);
}

vec2 px2uv(in vec2 px)
{
	return vec2(px/iResolution.xy);
}

vec2 grid(in vec2 px)
{
	//return px-mod(px,S);
	return floor(px/S)*S; // alternate
}

vec4 ss(in vec4 v)
{
	return smoothstep(SST-SSQ,SST+SSQ,v);
}

vec4 halftone(in vec2 fc,in mat2 m)
{
	vec2 smp = (grid(m*fc)+0.5*S)*m;
	float s = min(length(fc-smp)/(pDotsize*0.5*S),1.0);
	vec4 c = rgb2cmyki(texture2D(iChannel0,px2uv(smp+ORIGIN)));
	return c+s;
}

mat2 rotm(in float r)
{
	float cr = cos(r);
	float sr = sin(r);
	return mat2(
		cr,-sr,
		sr,cr
	);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	{
		S = pMin+(pMax-pMin)*2.0*abs(pScale-ORIGIN.x)/iResolution.x;
		R = D2R(180.0*(0.0-ORIGIN.y)/iResolution.y);
	}
	
	vec2 fc = fragCoord.xy-ORIGIN;
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 original = vec4( texture2D(iChannel0, uv ) );
	vec4 mask = vec4( texture2D(iChannel1, uv ) );
	
	mat2 mc = rotm(R+D2R(15.0));
	mat2 mm = rotm(R+D2R(75.0));
	mat2 my = rotm(R);
	mat2 mk = rotm(R+D2R(45.0));
	
	float k = halftone(fc,mk).a;
	vec4 c = cmyki2rgb(ss(vec4(
		halftone(fc,mc).r,
		halftone(fc,mm).g,
		halftone(fc,my).b,
		halftone(fc,mk).a
	)));

	if (useMask)
		fragColor = vec4 (mix(original.rgb, c.rgb, mask.a) , mix(original.a, c.a, mask.a) );
		
    else
    	fragColor = c;
}