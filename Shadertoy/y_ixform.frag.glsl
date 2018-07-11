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
// Code original : y_ixform Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_ixform Matchbox for Autodesk Flame


// iChannel0:Front,filter=linear,wrap=repeat
// iChannel1:Matte,filter=linear,wrap=repeat
// iChannel2:Strength,filter=linear,wrap=repeat
// BBox: iChannel0


float result_frameratio = iResolution.x/iResolution.y;

vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel = vec2(1.0) / res;



uniform float pos_x = 0.0; // Position X : (Horizontal translation.)
uniform float pos_y = 0.0; // Position Y : (Vertical translation.)

uniform float scale = 0.0; // Scale : (Scale.)
uniform float scale_x = 1.0; // Scale X : (Horizontal scale bias.)
uniform float scale_y = 1.0; // Scale Y : (Vertical scale bias.)

uniform float rot = 0.0; // Rotation : (Rotation.)

uniform float skew_x = 0.0; // Skew X : (Horizontal skew.)
uniform float skew_y = 0.0; // Skew Y : (Vertical skew.)

uniform float trans = 0.0; // Transparency : (Transparency.)

uniform bool repeat_texture = true; // Repeat Texture : (Repeat the Texture)
uniform bool warped_only = false; // Wraped Only : (Output warped only. Default is to comp over the original.)

//const vec2 center = vec2(.5);

uniform vec2 center = vec2(0.5,0.5); // Center : (Center of scale and rotation.)

bool isInTex( const vec2 coords )
{
	    return coords.x >= 0.0 && coords.x <= 1.0 &&
		            coords.y >= 0.0 && coords.y <= 1.0;
}


vec2 pre(vec2 coords)
{
	coords -= center;
	coords.x *= result_frameratio;

	return coords;
}

vec2 post(vec2 coords)
{
	coords.x /= result_frameratio;
	coords += center;

	return coords;
}

vec2 rotate_coords(vec2 coords, float rot)
{
	mat2 rm = mat2(
		cos(rot), sin(rot),
		-sin(rot), cos(rot)
	);

	coords = pre(coords);
	coords *= rm;
	coords = post(coords);

	return coords;
}

vec2 scale_coords(vec2 coords, vec2 scale_val)
{
	coords = pre(coords);
	coords /= scale_val + vec2(1.0);
	coords = post(coords);

	return coords;
}

vec2 skew_coords(vec2 coords, vec2 skew_val)
{
	mat2 sm = mat2(
		1.0, skew_val.x,
		skew_val.y, 1.0
	);

	coords *= sm;

	return coords;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec3 back = texture2D(iChannel0, st).rgb;

	float strength = texture2D(iChannel2, st).r;

	vec2 fcoords = st;

	vec2 s = vec2(strength);

	fcoords = scale_coords(fcoords, vec2(scale) * vec2(scale_x, scale_y) * s);
	fcoords = skew_coords(fcoords, vec2(skew_x, skew_y) * s);
	fcoords = fcoords - vec2(pos_x, pos_y) * s;
	fcoords = rotate_coords(fcoords, rot * strength);

	vec3 front = texture2D(iChannel0, fcoords).rgb;
	float matte = texture2D(iChannel1, fcoords).r;

/*
	if (isInTex(fcoords)) {
		front = texture2D(iChannel0, fcoords).rgb;
	} else {
		fcoords = 1.0 - fcoords;
		front = texture2D(iChannel0, fcoords).rgb;
	}
	*/

	if (! repeat_texture && ! isInTex(fcoords)) {
		front = vec3(0.0);
		matte = 0.0;
	}

	float alpha = mix(matte, 0.0, trans);

	vec3 comp = mix(back, front, alpha);
	if (warped_only) {
		comp = front * vec3(alpha) * vec3(strength);
	}

	fragColor = vec4(comp, alpha);
}
