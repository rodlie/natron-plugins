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
// Code original : crok_pixelstretch Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_pixelstretch Matchbox for Autodesk Flame

// based on https://www.shadertoy.com/view/XdX3zj

// iChannel0: result_pass2, filter=linear, wrap=clamp
// iChannel1: Front, filter=linear, wrap=clamp
// iChannel2: Strength, filter=linear, wrap=clamp
// iChannel3: Matte, filter=linear, wrap=clamp
// BBox: iChannel0









uniform float disp = 0.0; // Amount : , min=-1000, max=1000
uniform float matte_gamma = 1.0; // Matte gamma : ,min=0.01, max=10







vec2 res = vec2(iResolution.x, iResolution.y);
// float iGlobalTime = iTime *0.05;

float maxLOD = 6.0;
#define EPS .5e-2
float level = 0.0;

float gamma(float src, float value)
{
  return pow( max( 0.0, src ), 1.0 / value );
}

vec3 mytexg(vec2 uv)
{
	float matte_col = texture2D(iChannel0, uv).r;
	matte_col = gamma(matte_col, matte_gamma);
	return vec3(matte_col);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = ( fragCoord.xy / res);
	float s = texture2D(iChannel2, uv).r;
	float mode = 0.61;
	if ( disp > 0.0 )
		mode = 0.81;

	level = maxLOD*uv.x*uv.x;

   if(abs(mode-.5)>.1)
	 {
		vec3 tex,texx,texy,texmx,texmy;
		vec2 uvx,uvy,uvmx,uvmy;
		uvx  = uv+vec2(EPS,0.);
		uvy  = uv+vec2(0.,EPS);
		uvmx = uv-vec2(EPS,0.);
		uvmy = uv-vec2(0.,EPS);

		vec2 grad = vec2(0.0);
		float g = 1.0;
		bool isin = (mode>.5);
		float sgn = sign(abs(mode-.5)-.3);
 		for (int i=0; i<abs(disp * s); i++)
		{
			tex = mytexg(uv);
			if (isin)
			{
				uvx  = uv+vec2(EPS,0.);
				uvy  = uv+vec2(0.,EPS);
				uvmx = uv-vec2(EPS,0.);
				uvmy = uv-vec2(0.,EPS);
			}
			texx  = mytexg(uvx );
			texy  = mytexg(uvy );
			texmx = mytexg(uvmx);
			texmy = mytexg(uvmy);
			grad  = sgn*vec2(texx.x-texmx.x,texy.x-texmy.x);

			uv    += EPS*grad;
			uvx.x += EPS*grad.x;
			uvy.y += EPS*grad.y;
			uvmx.x -= EPS*grad.x;
			uvmx.y -= EPS*grad.y;
			}
	}
	vec3 col = texture2D(iChannel1, uv).rgb;
	float m = texture2D(iChannel3, uv).r;

	fragColor = vec4(col, m);
}
