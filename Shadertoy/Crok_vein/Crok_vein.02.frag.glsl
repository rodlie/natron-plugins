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
// Code original : crok_vein Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_vein Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter=linear, wrap=clamp
// BBox: iChannel0

// based on https://www.shadertoy.com/view/Mtc3Dj by cornusammonis



vec2 res = vec2(iResolution.x, iResolution.y);



uniform vec3 bg = vec3(1.0,0.9,0.8); // Background : 
uniform vec3 fg = vec3(0.9,0.3,0.0); // Foreground



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy/res.xy;
    float d = length(texture2D(iChannel0, uv).xy);
    //vec3 tx = texture2D(iChannel1, uv, 1.0).xyz;
    vec3 col = mix(bg, fg, 5.0*d);
	fragColor = vec4(col, 1.0);
}
