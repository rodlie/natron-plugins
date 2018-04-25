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
// iChannel2: pass3_result, filter=linear, wrap=clamp
// BBox: iChannel0


// based on https://www.shadertoy.com/view/XsBfRG



uniform bool DIR = false; // Switch Direction : 
uniform int view ;



float fromRgb( vec3 v ) {
    return (( v.z * 256.0 + v.y) * 256.0 + v.x) * 255.0;
}

vec4 draw( vec2 uv ) {
  float st = texture2D( iChannel1, uv ).r;
    vec2 dir = DIR ? vec2( 0.0, 1.0 ) : vec2( 1.0, 0.0 );
    float wid = DIR ? iResolution.y : iResolution.x;
    float pos = DIR ? floor( uv.y * iResolution.y ) : floor( uv.x * iResolution.x );

    for ( int i = 0; i < int( wid ); i ++ ) {
        vec2 p = uv + dir * float( i ) / wid;
        if ( p.x < 1.0 && p.y < 1.0 ) {
            float v = fromRgb( texture2D( iChannel2, p ).xyz );
            if ( abs( v - pos ) < 0.5 ) {
                return texture2D( iChannel0, p ) ;
                break;
            }
        }

        p = uv - dir * float( i ) / wid;
        if ( 0.0 < p.x && 0.0 < p.y ) {
            float v = fromRgb( texture2D( iChannel2, p ).xyz ) ;
            if ( abs( v - pos ) < 0.5 ) {
                return texture2D( iChannel0, p );
                break;
            }
        }
    }

    return vec4( 1.0, 0.0, 1.0, 1.0 );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );
  vec4 org = texture2D( iChannel0, uv );
  vec4 col = draw( uv );
  col.rgb = vec3(org.a * col.rgb + (1.0 - org.a) * org.rgb);
  fragColor = vec4(col.rgb, org.a);
    
}
