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
// Code original : crok_scanlines Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_scanlines Matchbox for Autodesk Flame


// iChannel0: Source, filter = linear
// BBox: iChannel0

uniform bool RGB_BAR = false; // RGB BAR :
uniform bool RGB_TRIAD = false; // RGB TRIAD :
uniform bool MG_BAR = false; // MG BAR :

vec2 rubyOutputSize = vec2(iResolution.x, iResolution.y);
vec2 rubyInputSize = vec2(iResolution.x, iResolution.y);
vec2 FrontSize = rubyInputSize;


#define SPOT_WIDTH  0.9
#define SPOT_HEIGHT 0.65

#define COLOR_BOOST 2.45

#define GAMMA_IN(color) color
#define GAMMA_OUT(color) color

#define TEX2D(coords)   GAMMA_IN( texture2D(iChannel0, coords) )

#define WEIGHT(w) \
if(w>1.0) w=1.0; \
w = 1.0 - w * w; \
w = w * w;

vec2 onex = vec2( 1.0/FrontSize.x, 0.0 );
vec2 oney = vec2( 0.0, 1.0/FrontSize.y );

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 coords = ( uv * FrontSize );
	vec2 pixel_center = floor( coords ) + vec2(0.5);
	vec2 texture_coords = pixel_center / FrontSize;
    vec4 color = TEX2D( texture_coords );

    float dx = coords.x - pixel_center.x;

    float h_weight_00 = dx / SPOT_WIDTH;
    WEIGHT(h_weight_00);
	color *= vec4( h_weight_00  );


    vec2 coords01;
    if (dx>0.0) {
		coords01 = onex;
        dx = 1.0 - dx;
	} else {
		coords01 = -onex;
        dx = 1.0 + dx;
	}
	vec4 colorNB = TEX2D( texture_coords + coords01 );

    float h_weight_01 = dx / SPOT_WIDTH;
    WEIGHT( h_weight_01 );
	color = color + colorNB * vec4( h_weight_01 );

	float dy = coords.y - pixel_center.y;
    float v_weight_00 = dy / SPOT_HEIGHT;
    WEIGHT(v_weight_00);
    color *= vec4( v_weight_00 );


    vec2 coords10;
	if (dy>0.0) {
		coords10 = oney;
        dy = 1.0 - dy;
	} else {
		coords10 = -oney;
        dy = 1.0 + dy;
	}
	colorNB = TEX2D( texture_coords + coords10 );
	float v_weight_10 = dy / SPOT_HEIGHT;
    WEIGHT( v_weight_10 );
	color = color + colorNB * vec4( v_weight_10 * h_weight_00 );
	colorNB = TEX2D(  texture_coords + coords01 + coords10 );
	color = color + colorNB * vec4( v_weight_10 * h_weight_01 );
	color *= vec4( COLOR_BOOST );
	
	if ( RGB_BAR )
		{

			vec2 output_coords = floor(uv * rubyOutputSize);
		
			float modulo = mod(output_coords.x,3.0);
			
            if ( modulo == 0.0 )
                    color = color * vec4(1.4,0.5,0.5,0.0);
                else if ( modulo == 1.0 )
                    color = color * vec4(0.5,1.4,0.5,0.0);
                else
                    color = color * vec4(0.5,0.5,1.4,0.0);
			}

		if ( RGB_TRIAD )
		{
        vec2 output_coords = floor(uv * rubyOutputSize / rubyInputSize * FrontSize);
		float modulo = mod(output_coords.x,2.0);
		if ( modulo < 1.0 )
        modulo = mod(output_coords.y,6.0);
        else
        modulo = mod(output_coords.y + 3.0, 6.0);
		if ( modulo < 2.0 )
                    color = color * vec4(1.0,0.0,0.0,0.0);
                else if ( modulo < 4.0 )
                    color = color * vec4(0.0,1.0,0.0,0.0);
                else
                    color = color * vec4(0.0,0.0,1.0,0.0);
			}

        if ( MG_BAR )
		{
                vec2 output_coords = floor(uv * rubyOutputSize);

                float modulo = mod(output_coords.x,2.0);
                if ( modulo == 0.0 )
                    color = color * vec4(1.0,0.1,1.0,0.0);
                else
                    color = color * vec4(0.1,1.0,0.1,0.0);
			}


                fragColor = GAMMA_OUT(color), 0.0, 1.0;
        }

