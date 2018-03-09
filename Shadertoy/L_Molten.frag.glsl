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
// Code original : L_Molten Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : L_Molten Matchbox for Autodesk Flame

//textured noise for Matchbox based on https://www.shadertoy.com/view/Mss3zn


uniform float speed = 0.1; // Speed : (speed of the blades), min=-1000, max=1000
uniform float offset = 0.0; // Offset : (Use this to offset relative to the current speed), min=-1000, max=1000
uniform float scale = 20.0; // Scale : (scale of effect),  min=0.0001, max=100
uniform float disp = 0.3; // Gradient length : (gradient length), min=0.0001, max=10
uniform vec3 color = vec3(0.45 , 0.03 , 0.35); // Colour : (colour)
uniform float colourMult = 4.0; // Exposure : (exposure), min=1, max=100

const float gamma = 2.2;
const int iters = 1024;

const float origin_z = 0.0;
const float plane_z = 4.0;
const float far_z = 64.0;

const float step = (far_z - plane_z) / float(iters) * 0.025;

const float color_bound = 0.0;
const float upper_bound = 1.0;



float calc_this(vec3 p, float disx, float disy, float disz)
{
	float c = sin(sin((p.x + disx) * sin(sin(p.z + disz)) + (iTime*speed)) + sin((p.y + disy) * cos(p.z + disz) + 2.0 * (iTime*speed)) + sin(3.0*p.z + disz + 3.5 * (iTime*speed)) + sin((p.x + disx) + sin(p.y + disy + 2.5 * (p.z + disz - (iTime*speed)) + 1.75 * (iTime*speed)) - 0.5 * (iTime*speed)) + offset );
	return c;
}

vec3 get_intersection(vec2 fragCoord)
{
	vec2 position = (fragCoord.xy / iResolution.xy - 0.5) * scale;

	vec3 pos = vec3(position.x, position.y, plane_z);
	vec3 origin = vec3(0.0, 0.0, origin_z);

	vec3 dir = pos - origin;
	vec3 dirstep = normalize(dir) * step;

	dir = normalize(dir) * plane_z;


	float c;

	for (int i=0; i<iters; i++)
	{
		c = calc_this(dir, 0.0, 0.0, 0.0);

		if (c > color_bound)
		{
			break;
		}

		dir = dir + dirstep;
	}

	return dir;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	
	vec3 p = get_intersection(fragCoord);
	float dx = color_bound - calc_this(p, disp, 0.0, 0.0);
	float dy = color_bound - calc_this(p, 0.0, disp, 0.0);

	vec3 du = vec3(disp, 0.0, dx);
	vec3 dv = vec3(0.0, disp, dy);
	vec3 normal = normalize(cross(du, dv));

	vec3 light = normalize(vec3(0.0, 0.0, 1.0));
	float l = dot(normal, light);

	float cc = pow(l, gamma);
	fragColor = vec4(cc*color.r*colourMult, cc*color.g*colourMult, cc*color.b*colourMult, 1.0);
}