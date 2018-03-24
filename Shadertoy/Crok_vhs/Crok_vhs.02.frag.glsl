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
// Code original : crok_vhs Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_vhs Matchbox for Autodesk Flame



  // iChannel0: result_pass1, filter = nearest
  // iChannel1: Source, filter = linear
  // BBox: iChannel1

  // based on https://www.shadertoy.com/view/MdffD7 by FMS_Cat

  vec2 res = vec2(iResolution.x, iResolution.y);


  uniform float vhs_res = 0.17; // Resolution : , min=0.0, max=1.0

  uniform float tape_wave = 2.0; // Tape wave : ,min=0.0, max=100.0
  uniform float tape_crease = 1.0; // Tape crease : , min=-100.0, max=100.0

  uniform float ac_beat = 1.0; // AC beat : ,min=-10000, max=10000

  uniform bool enable_bleed = true;
  uniform float color_bleeding = 1.0; // Bleeding amount : , min=-1.0, max=10.0
  uniform vec3 bleed_offset = vec3(0.0,2.0,4.0); // Bleed offset : 

  uniform bool enable_tint = true;
  uniform float yiq_blend = 1.0; // Tint amount : , min=-10000, max=10000
  uniform vec3 yiq_offset = vec3(0.7,2.0,3.4); // Tint offset : 






  uniform float speed = 1.0; // Speed : ,min=-10000, max=10000
  uniform float offset = 0.0; // Offset : ,min=-10000, max=10000

  #define V vec2(0.,1.)
  #define PI 3.14159265
  #define HUGE 1E9
  #define saturate(i) clamp(i,0.,1.)
  #define lofi(i,d) floor(i/d)*d
  #define validuv(v) (abs(v.x-0.5)<0.5&&abs(v.y-0.5)<0.5)

  float time = iTime * 0.05 * speed + offset;
  vec2 VHSRES = vec2(iResolution.x * vhs_res, iResolution.y * vhs_res);

  float v2random( vec2 uv ) {
    return texture2D( iChannel0, mod( uv, vec2( 1.0 ) ) ).x;
  }

  vec3 vhsTex2D( vec2 uv ) {
    if ( validuv( uv ) ) {
      return texture2D( iChannel1, uv ).xyz;
    }
    return vec3( 0.1, 0.1, 0.1 );
  }

  vec3 rgb2yiq( vec3 rgb ) {
    return mat3( 0.299, 0.596, 0.211, 0.587, -0.274, -0.523, 0.114, -0.322, 0.312 ) * rgb;
  }

  vec3 yiq2rgb( vec3 yiq ) {
    return mat3( 1.000, 1.000, 1.000, 0.956, -0.272, -1.106, 0.621, -0.647, 1.703 ) * yiq;
  }



  void mainImage( out vec4 fragColor, in vec2 fragCoord )
  {

    vec2 uv = (fragCoord.xy / VHSRES.xy);
    vec2 uvn = uv;
    vec3 col = vec3(0.0);
    // tape wave
    uvn.x += ( v2random( vec2( uvn.y / 10.0, time / 10.0 ) / 1.0 ) - 0.5 ) / VHSRES.x * tape_wave;
    uvn.x += ( v2random( vec2( uvn.y, time * 10.0 ) ) - 0.5 ) / VHSRES.x * tape_wave;
    // tape crease
    float tcPhase = smoothstep( 0.9, 0.96, sin( uvn.y * 8.0 - ( time + 0.14 * v2random( time * vec2( 0.67, 0.59 ) ) ) * PI * 1.2 ) );
    float tcNoise = smoothstep( 0.3, 1.0, v2random( vec2( uvn.y * 4.77, time ) ) );
    float tc = tcPhase * tcNoise;
    uvn.x = uvn.x - tc / VHSRES.x * 8.0 * tape_crease;
    // switching noise
    float snPhase = smoothstep( 6.0 / VHSRES.y, 0.0, uvn.y );
    uvn.y += snPhase * 0.3;
    uvn.x += snPhase * ( ( v2random( vec2( uv.y * 100.0, time * 10.0 ) ) - 0.5 ) / VHSRES.x * 24.0 );
    // fetch
    col = vhsTex2D( uvn );
    // crease noise
    float cn = tcNoise * ( 0.3 + 0.7 * tcPhase );
    if ( 0.29 < cn ) {
      vec2 uvt = ( uvn + V.yx * v2random( vec2( uvn.y, time ) ) ) * vec2( 0.1, 1.0 );
      float n0 = v2random( uvt );
      float n1 = v2random( uvt + V.yx / VHSRES.x );
      if ( n1 < n0 ) {
        col = mix( col, 2.0 * V.yyy, pow( n0, 5.0 ) );
      }
    }
    // switching color modification
    col = mix(col, col.yzx, snPhase * 0.4);
    // ac beat
    col *= 1.0 + 0.1 * smoothstep( 0.4, 0.6, v2random( vec2( 0.0, 0.1 * ( uv.y + time * 0.2 ) ) / 10.0 * ac_beat ) );
    // color bleeding
    if ( enable_bleed )
    {
      for ( int x = -5; x < 2; x ++ ) {
        col.xyz += vec3(
          vhsTex2D( uvn + vec2( float( x ) - bleed_offset.x, 0.0 ) / VHSRES ).x,
          vhsTex2D( uvn + vec2( float( x ) - bleed_offset.y, 0.0 ) / VHSRES ).y,
          vhsTex2D( uvn + vec2( float( x ) - bleed_offset.z, 0.0 ) / VHSRES ).z
        ) * 0.25 * color_bleeding;
      }
      col *= 0.5 / (0.5 + color_bleeding);
    }
    // color noise, colormod
    col *= 0.9 + 0.1 * texture2D( iChannel0, mod( uvn * vec2( .2, 1.0 ) + time * vec2( 0.97, 0.45 ), vec2( 1.0 ) ) ).xyz;
    col = saturate( col );
    // yiq
    if ( enable_tint )
    {
      vec3 col_org = col;
      col = rgb2yiq( col );
      col = vec3( 0.1, -0.1, 0.0 ) + vec3( yiq_offset ) * col;
      col = yiq2rgb( col );
      col = mix(col_org, col, yiq_blend);
    }
    fragColor = vec4( col, 1.0 );
  }
