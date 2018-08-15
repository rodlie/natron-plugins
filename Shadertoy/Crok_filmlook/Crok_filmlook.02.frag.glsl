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
// Code original : crok_filmlook Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_filmlook Matchbox for Autodesk Flame

// iChannel0: Source,filter=nearest,wrap=clamp
// iChannel1: pass1_result,filter=nearest,wrap=clamp
// BBox: iChannel0



uniform float m_sat = 1.0; // Saturation : , min=-5.0, max=5.0
uniform float m_con = 1.0; // Contrast : , min=0.0, max=10.0
uniform float m_gam = 1.0; // Gamma : , min=0.001, max=10.0

uniform float blend = 1.0; // Mix : ,min=0.0, max=10.0

uniform float m_slope_r = 1.0; // Red Slope : 
uniform float m_slope_g = 1.0; // Green Slope : 
uniform float m_slope_b = 1.0; // Blue Slope : 

uniform float m_offset_r = 0.0; // Red Offset : 
uniform float m_offset_g = 0.0; // Green Offset : 
uniform float m_offset_b = 0.0; // Blue Offset : 

uniform float m_power_r = 1.0; // Red Power : 
uniform float m_power_g = 1.0; // Green Power : 
uniform float m_power_b = 1.0; // Blue Power : 

uniform int look = 3; // Look : ,min=1, max=18



vec2 resolution = vec2(iResolution.x, iResolution.y);

// Algorithm from Chapter 16 of OpenGL Shading Language
vec3 saturation(vec3 rgb, float adjustment)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

// Real contrast adjustments by  Miles
vec3 contrast(vec3 col, vec4 con)
{
	vec3 c = con.rgb * vec3(con.a);
	vec3 t = (vec3(1.0) - c) / vec3(2.0);
	t = vec3(.5);
	col = (1.0 - c.rgb) * t + c.rgb * col;
	return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / resolution.xy;
    vec3 org = texture2D(iChannel0, uv).rgb;
	float alpha = texture2D(iChannel0, uv).a;
    vec3 res1 = texture2D(iChannel1, uv).rgb;
	
	vec3 c = res1;
	vec3 slope = vec3(1.0);
	vec3 offset = vec3(0.0);
	vec3 power = vec3(1.0);
	float sat = 1.0;
	float con = 1.0;
	float gam = 1.0;
	
	slope = vec3(m_slope_r, m_slope_g, m_slope_b);
	offset = vec3(m_offset_r, m_offset_g, m_offset_b);
	power = vec3(m_power_r, m_power_g, m_power_b);
	sat = m_sat;
	con = m_con;
	gam = m_gam;		

	//apply gamma correction 
	c = pow(c, vec3(gam));
	// apply CDL values
	c = pow(clamp(((c * slope) + offset), 0.0, 1.0), power);
	// apply saturation
	c = saturation(c, (sat));
	// apply contrast
	c = contrast(c, vec4(con));
	// blend original in/out
	c = mix(org, c, blend);
	
    fragColor = vec4(c, alpha);
}