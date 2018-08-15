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
// Code original : crok_rift Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_rift Matchbox for Autodesk Flame


// iChannel0: Source,filter=linear,wrap=clamp
// BBox: iChannel0

uniform float kappa1 = 1.0; // Kappa 1 : 
uniform float kappa2 = 1.7; // Kappa 2 : 
uniform float kappa3 = 0.7; // Kappa 3 : 
uniform float kappa4 = 15.0; // Kappa 4 : 

uniform float scaleFactor = 0.9; // Scale : 
uniform float separation = -0.05; // Separation : 

uniform vec2 leftCenter = vec2( 0.25 , 0.5 ); // Left Center : 
uniform vec2 rightCenter = vec2( 0.75 , 0.5 ); // Right Center : 

vec4 kappa = vec4(kappa1, kappa2, kappa3, kappa4);

//vec4 kappa = vec4(1.0,1.7,0.7,15.0);
//const float scaleFactor = 0.9;
//const vec2 leftCenter = vec2(0.25, 0.5);
//const vec2 rightCenter = vec2(0.75, 0.5);
//const float separation = -0.05;

// Scales input texture coordinates for distortion.
vec2 hmdWarp(vec2 LensCenter, vec2 texCoord, vec2 Scale, vec2 ScaleIn) {
	vec2 theta = (texCoord - LensCenter) * ScaleIn;
	float rSq = theta.x * theta.x + theta.y * theta.y;
	vec2 rvector = theta * (kappa.x + kappa.y * rSq + kappa.z * rSq * rSq + kappa.w * rSq * rSq * rSq);
	vec2 tc = LensCenter + Scale * rvector;
	return tc;
}

bool validate(vec2 tc, int left_eye) {
	//keep within bounds of texture
	if ((left_eye == 1 && (tc.x < 0.0 || tc.x > 0.5)) || (left_eye == 0 && (tc.x < 0.5 || tc.x > 1.0)) || tc.y < 0.0 || tc.y > 1.0) {
		return false;
	}
	return true;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 screen = vec2(iResolution.x, iResolution.y);
	 
	float as = float(screen.x / 2.0) / float(screen.y);
	vec2 Scale = vec2(0.5, as);
	vec2 ScaleIn = vec2(2.0 * scaleFactor, 2.0 / as * scaleFactor);
	 
	vec2 texCoord = fragCoord.xy/screen;
	vec2 texCoordSeparated = texCoord;
	vec2 tc = vec2(0);
	vec4 color = vec4(0);
	
	if (texCoord.x < 0.5) {
		texCoordSeparated.x += separation;
		tc = hmdWarp(leftCenter, texCoordSeparated, Scale, ScaleIn );
		color = texture2D(iChannel0, tc);
		if (!validate(tc, 1))
			color = vec4(0);
	} else {
		texCoordSeparated.x -= separation;
		tc = hmdWarp(rightCenter, texCoordSeparated, Scale, ScaleIn);
		color = texture2D(iChannel0, tc);
		if (!validate(tc, 0))
			color = vec4(0);
	}
	fragColor = color;
}
