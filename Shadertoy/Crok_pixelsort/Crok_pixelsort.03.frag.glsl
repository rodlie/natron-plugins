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
// Code original : crok_pixelsort Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_pixelsort Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter=linear, wrap=clamp
// iChannel1: pass2_result, filter=linear, wrap=clamp
// BBox: iChannel0



// based on https://www.shadertoy.com/view/XsBfRG




uniform bool SHADOW = false; // Switch to Shadow
uniform bool REVERSE = false; // Invert direction : 
uniform float amount = 0.97; // Amount : (amount), min=0.0, max=1.0
uniform bool DIR = false; // Switch Direction : 

float THR = amount * -1.0 + 1.0;

float gray( vec3 c ) {
  return dot( c, vec3( 0.299, 0.587, 0.114 ) );
}

vec3 toRgb( float i ) {
    return vec3(
        mod( i, 256.0 ),
        mod( floor( i / 256.0 ), 256.0 ),
        floor( i / 65536.0 )
    ) / 255.0;
}

bool thr( float v ) {
  return SHADOW ? ( 1.0 - THR < v ) : ( v < THR );
}

vec4 draw( vec2 uv ) {
    vec2 dir = DIR ? vec2( 0.0, 1.0 ) : vec2( 1.0, 0.0 );
    float wid = DIR ? iResolution.y : iResolution.x;
    float pos = DIR ? floor( uv.y * iResolution.y ) : floor( uv.x * iResolution.x );

    float val = gray( texture2D( iChannel1, uv ).xyz );

    if ( !thr( val ) ) {
        float post = pos;
        float rank = 0.0;
        float head = 0.0;
        float tail = 0.0;

        for ( int i = 0; i < int( wid ); i ++ ) {
            post -= 1.0;
            if ( post == -1.0 ) { head = post + 1.0; break; }
            vec2 p = dir * ( post + 0.5 ) / wid + dir.yx * uv;
            float v = gray( texture2D( iChannel1, p ).xyz );
            if ( thr( v ) ) { head = post + 1.0; break; }
            if ( v <= val ) { rank += 1.0; }
        }

        post = pos;
        for ( int i = 0; i < int( wid ); i ++ ) {
            post += 1.0;
            if ( wid == post ) { tail = post - 1.0; break; }
            vec2 p = dir * ( post + 0.5 ) / wid + dir.yx * uv;
            float v = gray( texture2D( iChannel1, p ).xyz );
            if ( thr( v ) ) { tail = post - 1.0; break; }
            if ( v < val ) { rank += 1.0; }
        }

        pos = REVERSE ? ( tail - rank ) : ( head + rank );
    }

    return vec4( toRgb( pos ), 1.0 );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
  vec4 col = draw( uv );
  fragColor = col;
}
