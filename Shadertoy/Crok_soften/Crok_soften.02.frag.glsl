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
// Code original : crok_soften Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_soften Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter = linear , wrap = clamp
// BBox: iChannel0

// based on Timothy Lottes "FXAA"
// aa front



uniform float aa_mix = 1.0; // AA Amount : , min=0.0, max=1.0



float getLuminance( vec3 rgb )
{
   return dot(rgb, vec3(0.299, 0.587, 0.114));
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 pix = vec2(1.0) / vec2( iResolution.x, iResolution.y );
   vec2 uv = fragCoord.xy * pix;
   vec4 o = texture2D( iChannel0, uv);

   float l  = getLuminance( texture2D( iChannel0, uv ).rgb);
   float nw = getLuminance( texture2D( iChannel0, uv + pix * vec2(-1.0, -1.0) ).rgb);
   float ne = getLuminance( texture2D( iChannel0, uv + pix * vec2(1.0, -1.0) ).rgb);
   float sw = getLuminance( texture2D( iChannel0, uv + pix * vec2(-1.0, 1.0) ).rgb);
   float se = getLuminance( texture2D( iChannel0, uv + pix * vec2(1.0, 1.0) ).rgb);

   vec2 lb = vec2( min( l, min( min( nw, ne ), min( sw, se ))), max( l, max( max( nw, ne) , max( sw, se ))));
   vec2 g = vec2(((sw + se) - (nw + ne)), ((nw + sw) - (ne + se)));

   float gr = max(( nw + ne + sw + se ) * 0.03125, 0.0078125 );
   float gz = 1.0 / ( min(abs(g.x), abs(g.y))+ gr );
   g = min( vec2(8.0), max( vec2(-8.0), g*gz)) * pix;
   vec4 col_a = 0.5 * ( texture2D(iChannel0,  uv + g * -0.16666666666667) + texture2D(iChannel0,  uv + g * 0.16666666666667));
   vec4 col_b = col_a * 0.5 + 0.25 * ( texture2D(iChannel0,  uv + g * -0.5) + texture2D(iChannel0,  uv + g * 0.5));
   float l_b = getLuminance( col_b.rgb );

   vec4 c = (( l_b < lb.x ) || ( l_b > lb.y )) ? col_a : col_b;
   c = mix(o, c, aa_mix);
   fragColor = c;
}
