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
// Code original : y_source pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_source for Autodesk Flame


// iChannel0: Front,filter=linear,wrap=repeat
// iChannel1: Back,filter=nearest,wrap=clamp
// iChannel2: Matte,filter=linear,wrap=clamp
// BBox: iChannel1



vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;




uniform float transparency = 0.0; // Transparency : (Transparency), min=0.0, max=100.0

uniform vec3 front_pos = vec3(0.0,0.0,0.0); // Front Position : (Translate the front source)
uniform vec3 front_scale = vec3(100.0,100.0,100.0); // Front Scale : (Scale the front source)
uniform float front_rotate = 0.0; // Front Rotation : (Rotate the front source)
uniform vec2 front_center = vec2(0.5,0.5); // Front Center : (Center location for scaling and rotation)

uniform vec3 matte_pos = vec3(0.0,0.0,0.0); // Matte Position : (Translate the matte source)
uniform vec3 matte_scale = vec3(100.0,100.0,100.0); // Matte Scale : (Scale the matte source)
uniform float matte_rotate = 0.0; // Matte Rotation : (Rotate the matte source)
uniform vec2 matte_center = vec2(0.5,0.5); // Matte Center : (Center location for scaling and rotation)

uniform bool front_is_back = false; // Front is back : (Comp result on front, not back.)



vec2 scale_coords(vec2 coords, vec3 scale, vec2 center)
{
	vec2 scale_val = vec2(scale.x, scale.y) / vec2(100) * vec2(scale.z) / vec2(100);
	coords -= center;
	coords /= scale_val;
	coords += center;

	return coords;
}

vec2 rot_coords(vec2 coords, float rot, vec2 center, vec2 res)
{
	float rotation = radians(rot);
	mat2 rm = mat2( cos(-rotation), -sin(-rotation),
	                sin(-rotation), cos(-rotation) );

	float ratio = res.x / res.y;

	coords -= center;
	coords.x *= ratio;
	coords *= rm;
	coords.x /= ratio;
	coords += center;

	return coords;
}

vec2 trans_coords(vec2 coords, vec3 pos)
{
	coords -= vec2(.5);
	coords -= pos.xy * texel;
	coords += vec2(.5);

	coords = scale_coords(coords, vec3(pos.z) + vec3(100), vec2(.5));

	return coords;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec2 front_coords = st;

	front_coords = scale_coords(front_coords, front_scale, front_center);
	front_coords = rot_coords(front_coords, front_rotate, front_center, res);
	front_coords = trans_coords(front_coords, front_pos);
	vec3 front = texture2D(iChannel0, front_coords).rgb;

	vec2 matte_coords = st;

	matte_coords = scale_coords(matte_coords, matte_scale, matte_center);
	matte_coords = rot_coords(matte_coords, matte_rotate, matte_center, res);
	matte_coords = trans_coords(matte_coords, matte_pos);

	float matte = texture2D(iChannel2, matte_coords).r;

	vec3 back = texture2D(iChannel1, st).rgb;

	if (front_is_back) {
		back = texture2D(iChannel0, st).rgb;
	}


	vec3 comp = mix(back, front, matte * ((100 - transparency) / 100.0));

	fragColor = vec4(comp,matte * ((100 - transparency) / 100.0));
}
