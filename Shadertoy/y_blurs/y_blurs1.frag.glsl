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
// Code original : y_blurs Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : y_blurs Matchbox for Autodesk Flame


// iChannel0: Front,filter=linear,wrap=clamp
// iChannel1: Matte,filter=linear,wrap=clamp
// BBox: iChannel0



vec2 res = vec2(iResolution.x, iResolution.y);
vec2 texel  = vec2(1.0) / res;

uniform int i_colorspace = 0; // Colorspace : (orking colorspace. Set this to the current working colorspace. This insures a linear blur (no dark edges).), min=0, max=4
uniform bool invert_matte = false; // Invert Matte : (Invert the matte)

vec3 from_sRGB(vec3 col)
{
    if (col.r >= 0.0) {
        col.r = pow((col.r +.055)/ 1.055, 2.4);
    }

    if (col.g >= 0.0) {
        col.g = pow((col.g +.055)/ 1.055, 2.4);
    }

    if (col.b >= 0.0) {
        col.b = pow((col.b +.055)/ 1.055, 2.4);
    }

    return col;
}

vec3 from_rec709(vec3 col)
{
    if (col.r < .081) {
        col.r /= 4.5;
    } else {
        col.r = pow((col.r +.099)/ 1.099, 1 / .45);
    }

    if (col.g < .081) {
        col.g /= 4.5;
    } else {
        col.g = pow((col.g +.099)/ 1.099, 1 / .45);
    }

    if (col.b < .081) {
        col.b /= 4.5;
    } else {
        col.b = pow((col.b +.099)/ 1.099, 1 / .45);
    }

    return col;
}

vec3 adjust_gamma(vec3 col, float gamma)
{
    col.r = pow(col.r, gamma);
    col.g = pow(col.g, gamma);
    col.b = pow(col.b, gamma);

    return col;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 st = fragCoord.xy / res;
   	vec3 front = texture2D(iChannel0, st).rgb;
    float matte = texture2D(iChannel1, st).a;

    if (invert_matte)
    {
        matte = 1.0 - matte;
    }

    if (i_colorspace == 0) {
        front = from_rec709(front);
    } else if (i_colorspace == 1) {
        front = from_sRGB(front);
    } else if (i_colorspace == 2) {
        //linear
    } else if (i_colorspace == 3) {
        front = adjust_gamma(front, 2.2);
    } else if (i_colorspace == 4) {
        front = adjust_gamma(front, 1.8);
    }

    fragColor = vec4(front, matte);
}
