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
// Code original : y_flicker pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_flicker for Autodesk Flame


// iChannel0: Source,filter=linear,wrap=clamp
// iChannel1: LockFrame,filter=linear,wrap=clamp
// BBox: iChannel0


#extension GL_ARB_shader_texture_lod : enable

float adsk_getLuminance( vec3 rgb )
{
    // Algorithm from Chapter 10 of Graphics Shaders.
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    return dot(rgb, W);
}


vec2 res = vec2(iResolution.x, iResolution.y);


uniform float lod = 10.0; // Average : (Level of detail. Higher is lower and usually what you want.), min=0.0, max=10.0
uniform int operation = 0; // Operation : (Choose to remove flicker from input 1, or copy the flicker of input 1 to input 2.), min=0, max=1
uniform bool match_chroma = false; // Match Chroma : (Try and match the chroma as well as luma.)


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 st = fragCoord.xy / res;

	vec3 front = vec3(0.0);
	vec3 front_avg = texture2DLod(iChannel0, st, lod).rgb;
	vec3 lock_frame = texture2DLod(iChannel1, st, lod).rgb;

	vec3 new_gain = vec3(0.0);

	if (operation == 1) {
		if (lock_frame.r != 0.0) {
			new_gain.r = front_avg.r / lock_frame.r;
		}
		if (lock_frame.g != 0.0) {
			new_gain.g = front_avg.r / lock_frame.g;
		}
		if (lock_frame.b != 0.0) {
			new_gain.b = front_avg.b / lock_frame.b;
		}
		front = texture2D(iChannel1, st).rgb;
	} else {
		new_gain = lock_frame / max(front_avg, vec3(.00001));

		if (front_avg.r != 0.0) {
			new_gain.r = lock_frame.r / front_avg.r;
		}
		if (front_avg.g != 0.0) {
			new_gain.g = lock_frame.r / front_avg.g;
		}
		if (front_avg.b != 0.0) {
			new_gain.b = lock_frame.b / front_avg.b;
		}

		front = texture2D(iChannel0, st).rgb;
	}

	new_gain = clamp(new_gain, -5.0, 5.0);

	float gdif = adsk_getLuminance(new_gain.rgb);

	if (match_chroma) {
		front *= new_gain;
	} else {
		front *= gdif;
	}

	fragColor.rgb = front;
}
