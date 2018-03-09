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
// Code original : LS_Contacts pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : LS_Contacts Matchbox for Autodesk Flame
//
// Tiles the inputs into a grid for impressing clients
// lewis@lewissaunders.com
// TODO:
//  o Nonsquare pixels support... eek
//  o Variable width borders look gross, how can we get a nice even spacing?

// iChannel0: Source, filter = linear
// iChannel1: Source, filter = linear
// iChannel2: Source, filter = linear
// iChannel3: Source, filter = linear
// iChannel4: Source, filter = linear
// iChannel5: Source, filter = linear
// BBox: iChannel0

uniform int rows, cols, randomcount, seed;
uniform bool random, perframe, filltiles;
uniform float scale;


// Mysterious dirty random number generator
float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 coords = fragCoord.xy / vec2(iResolution.x, iResolution.y);
	vec2 tilecoords = vec2(0.0, 0.0);
	vec4 o = vec4(0.0);
	float aspectdiff, tilew, tileh;
	int tilex, tiley, tileidx;

	// Figure out how big each tile will be, and which tile we're in
	tilew = iResolution.x / float(cols);
	tileh = iResolution.y / float(rows);
	tilex = int(fragCoord.x / tilew);
	tiley = int((iResolution.y - fragCoord.y) / tileh);
	tileidx = tiley * cols + tilex;
	
	// Randomize the tile index
	if(random) {
		if(perframe) {
			tileidx = int(rand(vec2(float(tilex - seed), float(tiley) + 1234.0 * iTime)) * float(randomcount));
		} else {
			tileidx = int(rand(vec2(float(tilex - seed), float(tiley))) * float(randomcount));
		}
	}

	// Get current coordinates within this tile
	tilecoords.x = mod(fragCoord.x, tilew) / tilew;
	tilecoords.y = mod(fragCoord.y, tileh) / tileh;
	
	// Scale coordinates about the centre of each tile to maintain proportions and do fit/fill
	tilecoords -= vec2(0.5);
	tilecoords *= 100.0 / scale;
	aspectdiff = (tilew / tileh) / (iResolution.x / iResolution.y);
	if(aspectdiff > 1.0) {
		tilecoords.x *= aspectdiff;
		if(filltiles) {
			tilecoords /= aspectdiff;
		}
	} else {
		tilecoords.y /= aspectdiff;
		if(filltiles) {
			tilecoords *= aspectdiff;
		}
	}
	tilecoords += vec2(0.5);
	
	// Finally grab input for the tile we're in
	if(tileidx == 0) {
		o = texture2D(iChannel0, tilecoords);
	} else if(tileidx == 1) {
		o = texture2D(iChannel1, tilecoords);
	} else if(tileidx == 2) {
		o = texture2D(iChannel2, tilecoords);
	} else if(tileidx == 3) {
		o = texture2D(iChannel3, tilecoords);
	} else if(tileidx == 4) {
		o = texture2D(iChannel4, tilecoords);
	} else if(tileidx == 5) {
		o = texture2D(iChannel5, tilecoords);
	}
	
	// Draw black if we're in a border area
	if((tilecoords.x <= 0.0) || (tilecoords.x > 1.0)) {
			o = vec4(0.0);
	}
	if((tilecoords.y <= 0.0) || (tilecoords.y > 1.0)) {
			o = vec4(0.0);
	}
	
	fragColor = o;
}
