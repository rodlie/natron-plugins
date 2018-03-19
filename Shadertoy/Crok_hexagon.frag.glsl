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
// Code original : crok_hexagon Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_hexagon Matchbox for Autodesk Flame


// iChannel0: Source, filter=nearest, wrap=clamp
// BBox: iChannel0

// based on https://www.shadertoy.com/view/ls23Dc by pyalot
// http://www.gamedev.net/page/resources/_/technical/game-programming/coordinates-in-hexagon-based-tile-maps-r1800
// nearest hexagon sampling, not quite sure if it's correct



uniform float size = 100.0; // Size : (size), min=0.0, max=10000.0
uniform float edge = 1.0; // Edge : (edge), min=-100.9, max=100.0

uniform vec2 offset = vec2(0.0,0.0); // Offset : (offset)





vec2 resolution = vec2(iResolution.x, iResolution.y);


float PI = 3.14159265359;
float TAU = 2.0*PI;
float deg30 = TAU/12.0;

float hexDist(vec2 a, vec2 b){
	vec2 p = abs(b-a);
	float s = sin(deg30);
	float c = cos(deg30);

	float diagDist = s*p.x + c*p.y;
	return max(diagDist, p.x)/c;
}

vec2 nearestHex(float s, vec2 st)
{
	float h = sin(deg30)*s;
	float r = cos(deg30)*s;
	float b = s + 2.0*h;
	float a = 2.0*r;
	float m = h/r;

	vec2 sect = st/vec2(2.0*r, h+s);
	vec2 sectPxl = mod(st, vec2(2.0*r, h+s));

	float aSection = mod(floor(sect.y), 2.0);

	vec2 coord = floor(sect);
	if(aSection > 0.0){
		if(sectPxl.y < (h-sectPxl.x*m)){
			coord -= 1.0;
		}
		else if(sectPxl.y < (-h + sectPxl.x*m)){
			coord.y -= 1.0;
		}

	}
	else{
		if(sectPxl.x > r){
			if(sectPxl.y < (2.0*h - sectPxl.x * m)){
				coord.y -= 1.0;
			}
		}
		else{
			if(sectPxl.y < (sectPxl.x*m)){
				coord.y -= 1.0;
			}
			else{
				coord.x -= 1.0;
			}
		}
	}

	float xoff = mod(coord.y, 2.0)*r;
	return vec2(coord.x*2.*r-xoff, coord.y*(h+s))+vec2(r*2.0, s);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	float s = resolution.x / size;
	vec2 offs = resolution * 0.5 + offset;
	vec2 nearest = nearestHex(s, fragCoord.xy - offs);
	vec4 texel = texture2D(iChannel0, (nearest + offs)/resolution.xy);
	float dist = hexDist(fragCoord.xy - offs, nearest);
	float interiorSize = s;
	float interior = 1.0 - smoothstep(interiorSize - edge, interiorSize, dist * edge);
	fragColor = vec4(texel.rgb*interior, 1.0);
}
