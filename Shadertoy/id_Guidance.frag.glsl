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
// Code original : id_Guidance Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : id_Guidance Matchbox for Autodesk Flame


// setting inputs names and filtering options
// iChannel0: Source, filter = nearest
// BBox: iChannel0


// Guidance (C)2017 Bob Maple
// bobm-matchbox [at] idolum.com



uniform bool enable_h = true; // Enable Horizontal : 
uniform bool enable_v = true; // Enable Vertical : 

uniform int amount_h = 1728; // Width : , min=0, max=4096
uniform int amount_v = 972; // Height : , min=0, max=3112


uniform vec2 offset_xy = vec2(0.0,0.0); // Guides offset : (X/Y Offset Amount)
uniform vec3 guide_color = vec3(1.0,1.0,1.0); // Guides color : 
uniform float guide_trans = 100.0; // Guides opacity : , min=0.0, max=100.0
uniform bool thicker = false; // Draw thicker : 





void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    // Convert pixel coords to UV position for texture2D
    // and fetch the input pixel into px

    vec2 uv  = fragCoord.xy / vec2( iResolution.x, iResolution.y );
    vec4 px  = vec4( texture2D( iChannel0, uv ).rgb, 1.0 );

    // Figure out where to draw the guides

    float guide_rx = (iResolution.x / 2.0) + (amount_h / 2.0);
    float guide_lx = (iResolution.x / 2.0) - (amount_h / 2.0 - 1);

    float guide_uy = (iResolution.y / 2.0) + (amount_v / 2.0);
    float guide_ly = (iResolution.y / 2.0) - (amount_v / 2.0 - 1);

    // Add the guide offsets

    guide_rx += floor(offset_xy[0]);
    guide_lx += floor(offset_xy[0]);

    guide_uy += floor(offset_xy[1]);
    guide_ly += floor(offset_xy[1]);

    // Draw the guides

	if( enable_v ) {

		if( floor(fragCoord.x) == guide_lx || floor(fragCoord.x) == guide_rx )
			px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );

		if( thicker )
			if( floor(fragCoord.x) == guide_lx-1 || floor(fragCoord.x) == guide_rx+1 )
				px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );
	}

	if( enable_h ) {

		if( floor(fragCoord.y) == guide_uy || floor(fragCoord.y) == guide_ly )
        	px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );

		if( thicker )
			if( floor(fragCoord.y) == guide_uy+1 || floor(fragCoord.y) == guide_ly-1 )
	        	px = vec4( mix( px, vec4( guide_color, 1.0 ), (guide_trans / 100.0) ) );
	}

	fragColor = px;
}
