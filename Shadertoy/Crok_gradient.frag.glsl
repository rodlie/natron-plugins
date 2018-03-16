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
// Code original : crok_gradient Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_gradient Matchbox for Autodesk Flame


// based on https://www.shadertoy.com/view/ltjXDt by anastadunbar


// extra parameters

uniform int style = 0; // Style : (style), min=0, max=4
uniform float bias_adj = 0.25; // Bias : (bias), min=0.01, max=0.99

uniform vec3 col1 = vec3(1,1,1); // Color 1 : 
uniform vec3 col2= vec3(0,0,0); // Color 2 :

uniform float scale = 1.0; // Scale : (scale), min=0.01, max=1000
uniform float aspect = 1.0; // Aspect : (aspect), min=0.01, max=50

uniform vec2 point1 = vec2(0.5,0.0); // Stop : (stop)
uniform vec2 point2 = vec2(0.5,1.0); // Start : (start)

uniform vec2 point3 = vec2(0.5,0.5); // Center : (center)
uniform vec2 point4 = vec2(1.0,0.5); // Outer edge : (outer edge)

uniform vec2 point5 = vec2(0.0,0.5); // Left : (left)
uniform vec2 point6 = vec2(1.0,0.5); // Right : (right)

uniform bool invert = false;

uniform float blend = 1.0; //Blend : (blend), min=0, max=1



// constants variables

vec2 resolution = vec2(iResolution.x, iResolution.y);
#define PI 3.141592653589793238462



// functions

vec2 rotation(float rot,vec2 pos)
{
    mat2 rotation = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    return vec2(pos*rotation);
}

float gradient_linedist(vec2 uv, vec2 p1, vec2 p2) {
    return abs(((p2.x-p1.x)*(p1.y-uv.y))-((p1.x-uv.x)*(p2.y-p1.y)))/length(p1-p2);
}

float gradient_radial(vec2 uv, vec2 p3, vec2 p4)
{
    return length(uv-p3)/length(p3-p4);
}

float gradient_diamond(vec2 uv, vec2 p1, vec2 p2) {
    float a = (atan(p1.x-p2.x,p1.y-p2.y)+PI)/(PI*2.);
    vec2 d = rotation((a*PI*2.)+(PI/4.),uv-p1);
    vec2 d2 = rotation((a*PI*2.)+(PI/4.),p1-p2);
    return max(abs(d.x),abs(d.y))/max(abs(d2.x),abs(d2.y));
}

float gradient_angle(vec2 uv, vec2 p1, vec2 p2) {
    float a = (atan(p1.x-p2.x,p1.y-p2.y)+PI)/(PI*2.);
    return fract((atan(p1.x-uv.x,p1.y-uv.y)+PI)/(PI*2.)-a);
}
float gradient_linear(vec2 uv, vec2 p1, vec2 p2) {
    float a = (atan(p1.x-p2.x,p1.y-p2.y)+PI)/(PI*2.);
    uv -= p1;
    uv = uv/length(p1-p2);
    uv = rotation((a*PI*2.)-(PI/2.),uv);
    return uv.x;
}

float bias(float x, float b)
{
    b = -log2(1.0 - b);
    return 1.0 - pow(1.0 - pow(x, 1./b), b);
}



// main program

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / resolution.xy;
	vec3 front = texture2D(iChannel0, uv).rgb;
	float frameratio = iResolution.x/iResolution.y;
    uv.x *= frameratio * aspect;
	vec2 p_point1 = vec2(point1.x * frameratio, point1.y);
	vec2 p_point2 = vec2(point2.x * frameratio, point2.y);
	vec2 p_point3 = vec2(point3.x * frameratio * aspect, point3.y);
	vec2 p_point4 = vec2(point4.x * frameratio * aspect, point4.y);
	vec2 p_point5 = vec2(point5.x * frameratio, point5.y);
	vec2 p_point6 = vec2(point6.x * frameratio, point6.y);

	float drawing = 0.;

	if ( style == 0 )
	{
		drawing = gradient_linear(uv,p_point1,p_point2);
		if ( invert )
			drawing = 1.0 - drawing;
	}

	else if ( style == 1 )
	{
		drawing = gradient_radial(uv,p_point3,p_point4);
		if ( invert )
			drawing;
		else
			drawing = 1.0 - drawing;
	}

	else if ( style == 2 )
	{
		drawing = gradient_linedist(uv,p_point5,p_point6);
		if ( invert )
			drawing = 1.0 - drawing;
	}

	else if ( style == 3 )
    	drawing = gradient_diamond(uv,p_point1,p_point2);

	else if ( style == 4 )
		drawing = gradient_angle(uv,p_point1,p_point2);

	// post fx
  drawing = clamp(drawing, 0.0, 1.0);
  drawing = bias(drawing, bias_adj);

	vec3 col = vec3(drawing * col1 + (1.0 - drawing) * col2);
	col = mix(front, col, blend );
    fragColor = vec4(col, drawing);
}
