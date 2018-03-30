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
// Code original : crok_nightvision Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : crok_nightvision Matchbox for Autodesk Flame
//
// iChannel0: pass5_result, filter=linear, wrap=clamp

// add noise




uniform float overall = 3.0; // Noise : ,min=0.0, max=5.0
uniform float pScanline = 2.0; // Scanlines : ,min=0.005, max=2.0
uniform float v_scale = 1.0; // Size : ,min=0.0, max=10.0
uniform float v_soft = 1.0; // Softness : ,min=0.001, max=10.0

uniform bool e_vignette = true; // Enable Vignette : 



vec2 res = vec2(iResolution.x, iResolution.y);
float time = iTime *.05;

float overlay( float s, float d )
{
	return (d < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
}

vec3 overlay( vec3 s, vec3 d )
{
	vec3 c;
	c.x = overlay(s.x,d.x);
	c.y = overlay(s.y,d.y);
	c.z = overlay(s.z,d.z);
	return c;
}

float rand2(vec2 co) 
{
	return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 noise(vec2 uv) {
	vec2 c = res.x*vec2(1.,(res.y/res.x));
	vec3 col = vec3(0.0);

   	float noise = rand2(vec2((2.+time) * floor(uv.x*c.x / 1.0)/c.x / 1.0, (2.+time) * floor(uv.y*c.y / 1.0)/c.y / 1.0));

	col = vec3( noise );

	return col;
}

vec3 screen( vec3 s, vec3 d )
{
	return s + d - s * d;
}

float scanline(vec2 uv) 
{
	return sin(res.y * uv.y * pScanline );
}

float vignette(vec2 uv) {
	uv = (uv - 0.5) * 0.98;
	return clamp(pow(cos(uv.x * 3.1415), v_scale *.25) * pow(cos(uv.y * 3.1415), v_scale *.25) / v_soft, 0.0, 1.0);
}
	

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y);
	vec3 col = texture2D(iChannel0, uv).rgb;
	
	vec3 grain = noise(uv);
	vec3 grau = vec3 (0.5);
	vec3 c = vec3(0.0);

	// add scanlines
	col.rgb *= mix(vec3(scanline(uv)), col.rgb, 0.75);
	
	// Black and White Noise
	grain = mix(grau, grain, overall * .1);
	grain = vec3(grain.r);
	col = overlay(grain, col);
	
	
	if ( e_vignette )
		{
			// simple rectangle vignette
			col *= pow( 4.0*uv.y*(1.0-uv.y), 0.15 );
			//advanced vignette
			col *= vignette(uv);
		}		
	col = clamp(col, 0.0, 1.0); 
	col = screen(col, col);
	
	fragColor = vec4(col, 1.0);
}	