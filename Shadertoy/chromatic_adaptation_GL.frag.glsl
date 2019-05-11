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
// Code original : chromatic adaptation pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : chromatic adaptation for Autodesk Flame


// iChannel0: Source, filter = nearest, wrap0=clamp
// BBox: iChannel0


/*
**MIT License
**
**Copyright (c) 2019
**
**Permission is hereby granted, free of charge, to any person obtaining a copy
**of this software and associated documentation files (the "Software"), to deal
**in the Software without restriction, including without limitation the rights
**to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
**copies of the Software, and to permit persons to whom the Software is
**furnished to do so, subject to the following conditions:
**
**The above copyright notice and this permission notice shall be included in all
**copies or substantial portions of the Software.
**
**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
**IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
**FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
**AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
**LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
**OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
**SOFTWARE.
*/


uniform int input_cs = 0; 									// Input Colour Space : (input colour space note that the input must be linear in all cases), min=0, max=5
uniform int input_white_type = 0; 							// Input White Type : (input white point type), min=0, max=4
uniform int input_illuminant = 0; 							// Input Illuminant : (input white point illuminant), min=0, max=3

uniform vec2 InTempTint = vec2(6000.0,0.0);					// Input Temp and Tint : 

uniform bool input_temperature_shift = false; 				// Input Temp Shift : (applies a scaling of the colour temperature by a factor of 1.4388/1.438 to mimic the CIE D-series behavior instead of maintaining the physical exact correlated colour temperature)
uniform vec2 input_coordinates = vec2(0.32168,0.33767); 	// Input Coordinates : (CIE 1931 xy coordinates of the input white point)
uniform vec3 input_colour = vec3(1.0,1.0,1.0); 				// Input Colour : (colour representation of the input white point)
uniform int input_surround = 0; 							// Input Surround : (viewing conditions), min=0, max=2

uniform vec2 InLumBack = vec2(20.0,1.0);					// Input Field Lum / Rel BG : 

uniform int output_cs = 0; 									// Output Colour Space : (output colour space note that the output must be linear in all cases), min=0, max=5
uniform int output_white_type = 0; 							// Output White Type : (output white point type), min=0, max=4
uniform int output_illuminant = 0; 							// Output Illuminant : (output white point illuminant), min=0, max=3

uniform vec2 OutTempTint = vec2(6000.0,0.0);				// Output Temp and Tint : 

uniform bool output_temperature_shift = false; 				// Output Temp Shift : (applies a scaling of the colour temperature by a factor of 1.4388/1.438 to mimic the CIE D-series behavior instead of maintaining the physical exact correlated colour temperature)
uniform vec2 output_coordinates = vec2(0.32168,0.33767); 	// Output Coordinates : (CIE 1931 xy coordinates of the output white point)
uniform vec3 output_colour = vec3(1.0,1.0,1.0); 			// Output Colour : (colour representation of the output white point)
uniform int output_surround = 0; 							// Output Surround : (viewing conditions), min=0, max=2
uniform float output_field_luminance = 20.0; 				// Output Field Luminance : (output field luminance), min=0.0000001, max=1000000.0
uniform float output_rel_background = 1.0; 					// Output Rel BG : (relative output background brightness compared to the scene white), min=0.0000001, max=1000000.0
uniform int method = 0; 									// Method : (Adaptation method), min=0, max=3




const mat3 acescg_to_xyz  = mat3(.6624542,      .2722287,    -.0055746,   .1340042,  .6740818,      .0040607,   .1561877,     .0536895,    1.0103391);
const mat3 aces_to_xyz    = mat3(.9525523959,   .3439664498,  0.,         0.,        .7281660966,   0.,         .0000936786, -.0721325464, 1.0088251844);
const mat3 rec709_to_xyz  = mat3(.4123908,      .212639,      .0193308,   .3575843,  .7151687,      .1191948,   .1804808,     .0721923,    .9505322);
const mat3 rec2020_to_xyz = mat3(.636958,       .2627002,     0.,         .1446169,  .6779981,      .0280727,   .168881,      .0593017,    1.0609851);
const mat3 p3d65_to_xyz   = mat3(.4865709,      .2289746,     0.,         .2656677,  .6917385,      .0451134,   .1982173,     .0792869,    1.0439444);
const mat3 xyz_to_lms     = mat3(.7328,        -.7036,        .003,       .4296,     1.6975,        .0136,     -.1624,        .0061,       .9834);
const mat3 lms_to_hpe     = mat3(.740979,       .285353,     -.00962761,  .218025,   .624202,      -.00569803,  .0410057,     .0904451,    1.01533);
const mat3 hpe_to_lms     = mat3(1.55915,      -.714327,      .0107755,  -.544723,   1.85031,       .00521877, -.0144453,    -.135976,     .984006);
const mat3 lms_to_xyz     = mat3(1.09612,       .454369,     -.00962761, -.278869,   .473533,      -.00569803,  .182745,      .0720978,    1.01533);
const mat3 xyz_to_brdfrd  = mat3(.8951,        -.7502,        .0389,      .2664,     1.7135,       -.0685,     -.1614,        .0367,       1.0296);
const mat3 brdfrd_to_xyz  = mat3(.9869929,      .4323053,    -.0085287,  -.1470543,  .5183603,      .0400428,   .1599627,     .0492912,    .9684867);
const mat3 xyz_to_vkries  = mat3(.40024,       -.2263,        0.,         .7076,     1.16532,       0.,        -.08081,       .0457,       .91822);
const mat3 vkries_to_xyz  = mat3(1.8599364,     .3611914,     0.,        -1.1293816, .6388125,      0.,         .2198974,    -.0000064,    1.0890636);
const mat3 xyz_to_acescg  = mat3(1.6410234,    -.6636629,     .0117219,  -.3248033,  1.6153316,    -.0082844,  -.2364247,     .0167563,    .9883949);
const mat3 xyz_to_aces    = mat3(1.0498110175, -.4959030231,  0.,         0.,        1.3733130458,  0.,        -.0000974845,  .0982400361, .9912520182);
const mat3 xyz_to_rec709  = mat3(3.2409699,    -.9692436,     .0556301,  -1.5373832, 1.8759675,    -.203977,   -.4986108,     .0415551,    1.0569715);
const mat3 xyz_to_rec2020 = mat3(1.7166512,    -.6666844,     .0176399,  -.3556708,  1.6164812,    -.0427706,  -.2533663,     .0157685,    .9421031);
const mat3 xyz_to_p3d65   = mat3(2.4934969,    -.829489,      .0358458,  -.9313836,  1.7626641,    -.0761724,  -.4027108,     .0236247,    .9568845);

const mat3x2 hpe_to_ab = mat3x2(1., .111111111111111, -1.090909090909091, .111111111111111, .090909090909091, -.222222222222222);
const mat3 t_ab_to_l_hpe = mat3(.3278688524590164, .3278688524590164, .3278688524590164, .4782608695652174, -.4782608695652174, 0., 1.744832501781896, 1.353528153955809, -2.950819672131148);

const vec2 aces_white = vec2(.32168,           .33767);
const vec2 hd_white   = vec2(.3127,            .329);
const vec2 dci_white  = vec2(.314,             .351);
const vec2 e_e_white  = vec2(.333333333333333, .333333333333333);

const float cie_f[] = float[](1., .9, .8);
const float cie_c[] = float[](.69, .59, .525);
const float cie_n_c[] = float[](1., .95, .8);

vec3 in_to_xyz(vec3 color) {
    if (input_cs == 0)
        return acescg_to_xyz * color;
    if (input_cs == 1)
        return aces_to_xyz * color;
    if (input_cs == 2)
        return rec709_to_xyz * color;
    if (input_cs == 3)
        return rec2020_to_xyz * color;
    if (input_cs == 4)
        return p3d65_to_xyz * color;
    return color;
}

vec2 get_xy_from_cs(int idx) {
    if (idx == 0 || idx == 1)
        return aces_white;
    if (idx == 2 || idx == 3 || idx == 4)
        return hd_white;
    return e_e_white;
}

vec2 get_xy_from_illuminant(int idx) {
    if (idx == 0)
        return aces_white;
    if (idx == 1)
        return hd_white;
    if (idx == 2)
        return dci_white;
    return e_e_white;
}

vec2 get_xy_from_temp(float cct, float tint, bool temperature_shift) {
    float denom, denom2, cct2, cct3, cct4;
    vec2 xy, dxy_dcct, uv, duv_dcct, tint_vec;
    mat2 jacobi;
    if (temperature_shift)
        cct *= 1.000556328233658;
    if (cct < 4000)
        cct = 4000;
    if (25000 < cct)
        cct = 25000;
    cct2 = cct * cct;
    cct3 = cct2 * cct;
    cct4 = cct2 * cct2;
    if (cct < 7000) {
        xy.x = -4.607e9 / cct3 + 2.9678e6 / cct2 + .09911e3 / cct + .244063;
        dxy_dcct.x = 13.821e9 / cct4 - 5.9356e6 / cct3 - .09911e3 / cct2;
    }
    else {
        xy.x = -2.0064e9 / cct3 + 1.9018e6 / cct2 + .24748e3 / cct + .23704;
        dxy_dcct.x = 6.0192e9 / cct4 - 3.8036 / cct3 - .24748e3 / cct2;
    }
    xy.y = (-3. * xy.x + 2.87) * xy.x - .275;
    dxy_dcct.y = (-6. * xy.x + 2.87) * dxy_dcct.x;
    denom = 1. / (-2. * xy.x + 12. * xy.y + 3.);
    denom2 = denom * denom;
    uv = vec2(4. * xy.x,  6. * xy.y) * denom;
    jacobi = mat2(4. * denom + 8. * xy.x * denom2, 12. * xy.y * denom2, -48. * xy.x * denom2, 6. * denom - 72. * xy.y * denom2);
    duv_dcct = jacobi * dxy_dcct;
    tint_vec = vec2(duv_dcct.y, -duv_dcct.x);
    tint_vec = normalize(tint_vec);
    uv += tint_vec * tint;
    denom = 1. / (uv.x - 4. * uv.y + 2.);
    return vec2(1.5 * uv.x, uv.y) * denom;
}

vec2 get_in_xy(void) {
    vec3 xyz;
    if (input_white_type == 0)
        return get_xy_from_cs(input_cs);
    if (input_white_type == 1)
        return get_xy_from_illuminant(input_illuminant);
    if (input_white_type == 2)
        return get_xy_from_temp(InTempTint.r, InTempTint.g, input_temperature_shift);
    if (input_white_type == 3)
        return input_coordinates;
    xyz = in_to_xyz(input_colour);
    return vec2(xyz.x, xyz.y) / (xyz.x + xyz.y + xyz.z);
}

vec2 get_out_xy(void) {
    vec3 xyz;
    if (output_white_type == 0)
        return get_xy_from_cs(output_cs);
    if (output_white_type == 1)
        return get_xy_from_illuminant(output_illuminant);
    if (output_white_type == 2)
        return get_xy_from_temp(OutTempTint.r, OutTempTint.g, output_temperature_shift);
    if (output_white_type == 3)
        return output_coordinates;
    xyz = in_to_xyz(output_colour);
    return vec2(xyz.x, xyz.y) / (xyz.x + xyz.y + xyz.z);
}

vec3 sign(vec3 x) {
    return vec3(lessThan(vec3(0.), x)) - vec3(lessThan(x, vec3(0.)));
}

vec3 cat02_fwd(vec3 color, vec2 in_w_xy, float f, float c, float n_c, float l_a, float n) {
    float d, k, fl, n_b, z, a, a_w, j, l, h, t, ch;
    vec2 ab;
    vec3 in_tri = vec3(in_w_xy.x / in_w_xy.y, 1., (1. - in_w_xy.x - in_w_xy.y) / in_w_xy.y);
    in_tri = xyz_to_lms * in_tri;
    color = xyz_to_lms * color;
    d = f * (1. - .277777777777778 * exp(-.010869565217391 * (l_a + 42.)));
    color *= d / in_tri + (1 - d);
    in_tri = d + (1 - d) * in_tri;
    color = lms_to_hpe * color;
    in_tri = lms_to_hpe * in_tri;
    k = .2 / (l_a + .2);
    k *= k;
    k *= k;
    fl = 1. - k;
    fl = .2 * k * (5. * l_a) + .1 * fl * fl * pow(5. * l_a, .333333333333333);
    color = sign(color) * pow(fl * abs(color), vec3(.42));
    in_tri = sign(in_tri) * pow(fl * abs(in_tri), vec3(.42));
    color = 4. * color / (27.13 + color) + .001;
    in_tri = 4. * in_tri / (27.13 + in_tri) + .001;
    n_b = .725 * pow(n, -.2);
    z = 1.48 + sqrt(n);
    a = (dot(vec3(2., 1., .05), color) - .00305) * n_b;
    a_w = (dot(vec3(2., 1., .05), in_tri) - .00305) * n_b;
    j = pow(a / a_w, c * z);
    ab = hpe_to_ab * color;
    l = length(ab);
    h = atan(ab.y, ab.x);
    t = 9.615384615384615 * n_c * n_b * (cos(h + 2.) + 3.8) * l / dot(vec3(1., 1., 1.05), color);
    ch = pow(t, .9) * sqrt(j) * pow(1.64 - pow(.29, n), .73);
    return vec3(j, ch, h);
}

vec3 cat02_bwd(vec3 color, vec2 out_w_xy, float f, float c, float n_c, float l_a, float n) {
    float j = color.r, ch = color.g, h = color.b, d, k, fl, n_b, z, a_w, a, t, e;
    vec2 ab;
    vec3 out_tri = vec3(out_w_xy.x / out_w_xy.y, 1., (1. - out_w_xy.x - out_w_xy.y) / out_w_xy.y), out_tri_1;
    out_tri_1 = out_tri = xyz_to_lms * out_tri;
    d = f * (1. - .277777777777778 * exp(-.010869565217391 * (l_a + 42.)));
    out_tri_1 = d + (1 - d) * out_tri_1;
    out_tri_1 = lms_to_hpe * out_tri_1;
    k = .2 / (l_a + .2);
    k *= k;
    k *= k;
    fl = 1. - k;
    fl = .2 * k * (5. * l_a) + .1 * fl * fl * pow(5. * l_a, .333333333333333);
    out_tri_1 = sign(out_tri_1) * pow(fl * abs(out_tri_1), vec3(.42));
    out_tri_1 = 4. * out_tri_1 / (27.13 + out_tri_1) + .001;
    n_b = .725 * pow(n, -.2);
    z = 1.48 + sqrt(n);
    a_w = (dot(vec3(2., 1., .05), out_tri_1) - .00305) * n_b;
    a = a_w * pow(j, 1. / (c * z)) / n_b + .00305;
    t = pow(ch / (sqrt(j) * pow(1.64 - pow(.29, n), .73)), 1.111111111111111);
    t = 9.615384615384615 * n_c * n_b * (cos(h + 2.) + 3.8) / t;
    ab = vec2(cos(h), sin(h));
    color = t_ab_to_l_hpe * vec3(t, ab);
    color *= a / dot(vec3(2., 1., .05), color);
    color = (.02713 - 27.13 * color) / (color - 4.001);
    color = sign(color) * pow(abs(color), vec3(2.380952380952381)) / fl;
    color = hpe_to_lms * color;
    color /= d / out_tri + (1 - d);
    return lms_to_xyz * color;
}

vec3 cat02_smp(vec3 color, vec2 in_w_xy, vec2 out_w_xy) {
    vec3 out_tri = vec3(out_w_xy.x / out_w_xy.y, 1., (1. - out_w_xy.x - out_w_xy.y) / out_w_xy.y);
    vec3 in_tri = vec3(in_w_xy.x / in_w_xy.y, 1., (1. - in_w_xy.x - in_w_xy.y) / in_w_xy.y);
    out_tri = xyz_to_lms * out_tri;
    in_tri = xyz_to_lms * in_tri;
    color = xyz_to_lms * color;
    color *= out_tri / in_tri;
    return lms_to_xyz * color;
}

vec3 bradford(vec3 color, vec2 in_w_xy, vec2 out_w_xy) {
    vec3 out_tri = vec3(out_w_xy.x / out_w_xy.y, 1., (1. - out_w_xy.x - out_w_xy.y) / out_w_xy.y);
    vec3 in_tri = vec3(in_w_xy.x / in_w_xy.y, 1., (1. - in_w_xy.x - in_w_xy.y) / in_w_xy.y);
    out_tri = xyz_to_brdfrd * out_tri;
    in_tri = xyz_to_brdfrd * in_tri;
    color = xyz_to_brdfrd * color;
    color *= out_tri / in_tri;
    return brdfrd_to_xyz * color;
}

vec3 von_kries(vec3 color, vec2 in_w_xy, vec2 out_w_xy) {
    vec3 out_tri = vec3(out_w_xy.x / out_w_xy.y, 1., (1. - out_w_xy.x - out_w_xy.y) / out_w_xy.y);
    vec3 in_tri = vec3(in_w_xy.x / in_w_xy.y, 1., (1. - in_w_xy.x - in_w_xy.y) / in_w_xy.y);
    out_tri = xyz_to_vkries * out_tri;
    in_tri = xyz_to_vkries * in_tri;
    color = xyz_to_vkries * color;
    color *= out_tri / in_tri;
    return vkries_to_xyz * color;
}

vec3 xyz_to_out(vec3 color) {
    if (output_cs == 0)
        return xyz_to_acescg * color;
    if (output_cs == 1)
        return xyz_to_aces * color;
    if (output_cs == 2)
        return xyz_to_rec709 * color;
    if (output_cs == 3)
        return xyz_to_rec2020 * color;
    if (output_cs == 4)
        return xyz_to_p3d65 * color;
    return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float f, c, n_c;
    vec2 in_w_xy = get_in_xy();
    vec2 out_w_xy = get_out_xy();
    vec3 color = texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).rgb;
    color = in_to_xyz(color);
    if (method == 0) {
        f = cie_f[input_surround];
        c = cie_c[input_surround];
        n_c = cie_n_c[input_surround];
        color = cat02_fwd(color, in_w_xy, f, c, n_c, InLumBack.r, InLumBack.g);
        f = cie_f[output_surround];
        c = cie_c[output_surround];
        n_c = cie_n_c[output_surround];
        color = cat02_bwd(color, out_w_xy, f, c, n_c, output_field_luminance, output_rel_background);
        fragColor = vec4(xyz_to_out(color), 1.);
        return;
    }
    if (method == 1) {
        color = cat02_smp(color, in_w_xy, out_w_xy);
        fragColor = vec4(xyz_to_out(color), 1.);
        return;
    }
    if (method == 2) {
        color = bradford(color, in_w_xy, out_w_xy);
        fragColor = vec4(xyz_to_out(color), 1.);
        return;
    }
    color = von_kries(color, in_w_xy, out_w_xy);
    fragColor = vec4(xyz_to_out(color), 1.);
}
