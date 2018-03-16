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
// Code original : id_Croptastic Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : id_Croptastic Matchbox for Autodesk Flame

// Croptastic (C)2017 Bob Maple
// bobm-matchbox [at] idolum.com


// iChannel0: Source, filter = nearest, wrap = clamp
// iChannel1: Mask, filter = nearest, wrap = clamp


uniform float crop_t; // Top : (top), min=0, max=1000
uniform float crop_b; // Bottom : (bottom), min=0, max=1000
uniform float crop_l; // Left : (left), min=0, max=1000
uniform float crop_r; // Right : (righ), min=0, max=1000



uniform vec2 offset_xy = vec(0.0,0.0);



uniform bool invert = false; // Invert crop : (invert crop)
uniform bool border = false; // Border : (border)
bool border_overadv = false;



uniform float border_size = 20.0; // Border size : (border size), min=0, max=5000


bool aborder_l = false;
bool aborder_r = false;
bool aborder_t = false;
bool aborder_b = false;


uniform     float  aborder_lsize, aborder_rsize, aborder_tsize, aborder_bsize;


float aborder_ltrans = 0;
float aborder_rtrans = 0;
float aborder_ttrans = 0;
float aborder_btrans = 0;


uniform float border_trans = 50; // Border transparency : (border transparency), min=0.0, max=100.0


vec3 aborder_lcolor = vec3(0,0,0);
vec3 aborder_rcolor = vec3(0,0,0);
vec3 aborder_tcolor = vec3(0,0,0);
vec3 aborder_bcolor = vec3(0,0,0);


uniform vec3 border_color = vec3(0,0,0);


// Global variables

vec4 npx;


//

void do_border(vec2 fragCoord) {

    if( (fragCoord.x >= crop_l && fragCoord.x <= crop_l + border_size) || (fragCoord.x <= (iResolution.x - crop_r) && fragCoord.x >= (iResolution.x - crop_r) - border_size) )
        if( fragCoord.y >= crop_b && fragCoord.y <= iResolution.y - crop_t )
            npx = vec4( mix( npx, vec4( border_color, 1.0 ), (border_trans / 100.0) ) );

    if( (fragCoord.y >= crop_b && fragCoord.y <= crop_b + border_size) || (fragCoord.y <= (iResolution.y - crop_t) && fragCoord.y >= (iResolution.y - crop_t) - border_size) )
        if( fragCoord.x >= crop_l + border_size && fragCoord.x <= (iResolution.x - crop_r) - border_size )
            npx = vec4( mix( npx, vec4( border_color, 1.0 ), (border_trans / 100.0) ) );
}

//

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    // Convert pixel coords to UV position for texture2D,
    // fetch the fill and matte pixels and combine them into px

    vec2 uv  = (fragCoord.xy - offset_xy) / vec2( iResolution.x, iResolution.y );
    vec4 px  = vec4( texture2D( iChannel0, uv ).rgb, texture2D( iChannel1, uv ).g );

    vec4 blk = vec4( 0.0, 0.0, 0.0, 0.0 );

    // Initialize this pixel to either the input pixel or black

    npx = invert ? blk : px;

    // Do the cropping

    if( fragCoord.x < crop_l )
        npx = invert ? px : blk;
    if( fragCoord.x > iResolution.x - crop_r )
        npx = invert ? px : blk;

    if( fragCoord.y > iResolution.y - crop_t )
        npx = invert ? px : blk;
    if( fragCoord.y < crop_b )
        npx = invert ? px : blk;

    // Draw standard border if it's supposed to be underneath

    if( border && !border_overadv )
        do_border(fragCoord);


    // Draw Advanced Borders

    if( aborder_l ) {

        if( (fragCoord.x >= crop_l && fragCoord.x <= crop_l + aborder_lsize) && (fragCoord.y >= crop_b && fragCoord.y <= iResolution.y - crop_t) )
            npx = vec4( mix( npx, vec4( aborder_lcolor, 1.0 ), (aborder_ltrans / 100.0) ) );
    }

    if( aborder_r ) {

        if( (fragCoord.x <= (iResolution.x - crop_r) && fragCoord.x >= (iResolution.x - crop_r) - aborder_rsize) && (fragCoord.y >= crop_b && fragCoord.y <= iResolution.y - crop_t) )
            npx = vec4( mix( npx, vec4( aborder_rcolor, 1.0 ), (aborder_rtrans / 100.0) ) );
    }

    if( aborder_t ) {

        if( (fragCoord.y <= (iResolution.y - crop_t) && fragCoord.y >= (iResolution.y - crop_t) - aborder_tsize) && (fragCoord.x >= crop_l && fragCoord.x <= iResolution.x - crop_r) )
            npx = vec4( mix( npx, vec4( aborder_tcolor, 1.0 ), (aborder_ttrans / 100.0) ) );
    }

    if( aborder_b ) {

        if( (fragCoord.y >= crop_b && fragCoord.y <= crop_b + aborder_bsize) && (fragCoord.x >= crop_l && fragCoord.x <= iResolution.x - crop_r) )
            npx = vec4( mix( npx, vec4( aborder_bcolor, 1.0 ), (aborder_btrans / 100.0) ) );
    }


    // Draw standard border if it's supposed to be on top

    if( border && border_overadv )
        do_border(fragCoord);

    fragColor = npx;
}
