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
// Code original : crok_highpass Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : crok_highpass Matchbox for Autodesk Flame
//
// based on: http://www.ozone3d.net/smf/index.php?topic=68.0



// setting inputs names and filtering options
// iChannel0: Source, filter=Nearest, wrap=Clamp
// BBox: iChannel0



uniform float contrast = 1; // contrast : (contrast), min=0., max=20.
uniform float saturation = 1; // saturation : (saturation), min=0., max=1.
uniform bool clamp_values;
uniform bool comp_on_bg;


float step_w = 1.0 / iResolution.x;
float step_h = 1.0 / iResolution.y;


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

vec3 czm_saturation(vec3 rgb, float adjustment)
{
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec3 original = texture2D(iChannel0, uv).rgb;

	vec2 offset[9];
	float kernel[ 9 ];

	offset[ 0 ] = vec2(-step_w, -step_h);
	offset[ 1 ] = vec2(0.0, -step_h);
	offset[ 2 ] = vec2(step_w, -step_h);
	offset[ 3 ] = vec2(-step_w, 0.0);
	offset[ 4 ] = vec2(0.0, 0.0);
	offset[ 5 ] = vec2(step_w, 0.0);
	offset[ 6 ] = vec2(-step_w, step_h);
	offset[ 7 ] = vec2(0.0, step_h);
	offset[ 8 ] = vec2(step_w, step_h);
	kernel[ 0 ] = -1.;
	kernel[ 1 ] = -1.;
	kernel[ 2 ] = -1.;
	kernel[ 3 ] = -1.;
	kernel[ 4 ] = 8.;
	kernel[ 5 ] = -1.;
	kernel[ 6 ] = -1.;
	kernel[ 7 ] = -1.;
	kernel[ 8 ] = -1.;


   int i = 0;
   vec3 col = vec3(0.0);

   for( int i=0; i<9; i++ )
   {
    vec4 tmp = texture2D(iChannel0, uv + offset[i]);
    col += tmp.rgb * kernel[i];
   }
   col = col * contrast + 0.5;

   col = czm_saturation(col, saturation);
   
   if ( clamp_values )
	   col = clamp(col, 0.0, 1.0);
   
   if ( comp_on_bg )
	   col =  overlay(col, original);
   
   fragColor = vec4(col, 1.0);
}