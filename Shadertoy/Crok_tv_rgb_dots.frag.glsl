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
// Code original : crok_tv_rgb_dots Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_tv_rgb_dots Matchbox for Autodesk Flame


// iChannel0: Source, filter = linear, wrap = mirror
// BBox: iChannel0


uniform int pCellsize = 9; // Cell size : (cell size), min=1, max=1000




// RGB display
// created by Daniil in 17/6/2013

float CELL_SIZE_FLOAT = float(pCellsize);
int RED_COLUMNS = int(CELL_SIZE_FLOAT/3.);
int GREEN_COLUMNS = pCellsize-RED_COLUMNS;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 p = floor(fragCoord.xy / CELL_SIZE_FLOAT)*CELL_SIZE_FLOAT;
	int offsetx = int(mod(fragCoord.x,CELL_SIZE_FLOAT));
	int offsety = int(mod(fragCoord.y,CELL_SIZE_FLOAT));

	vec4 sum = texture2D(iChannel0, p / iResolution.xy);
	
	fragColor = vec4(0.,0.,0.,1.);
	if (offsety < pCellsize-1) {		
		if (offsetx < RED_COLUMNS) fragColor.r = sum.r;
		else if (offsetx < GREEN_COLUMNS) fragColor.g = sum.g;
		else fragColor.b = sum.b;
	}
	
}