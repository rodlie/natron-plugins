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
// Code original : threshold Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : threshold Matchbox for Autodesk Flame


// iChannel0:Source, filter=nearest,wrap=clamp
// BBox: iChannel0

/*
**MIT License
**
**Copyright (c) 2018
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









uniform int type = 0; // Type : (selector for the threshold type), min=0, max=3
uniform int data_source = 0; // Source : (selector for the data source the threshold filter will be applied to), min=0, max=4
uniform int rgb_mode = 0; // RGB Operation : (selector for the boolean operation combining the individual channel thresholds), min=0, max=2

uniform float red_luminance = 0.2676; // Red to Lum : (linear scaling factor of the red channel for the luminance value should add up to 1 with green and blue scaling), min=0, max=1
uniform float green_luminance = 0.6744; // Green to Lum : (linear scaling factor of the green channel for the luminance value should add up to 1 with red and blue scaling), min=0, max=1
uniform float blue_luminance = 0.0580; // Blue to Lum : (linear scaling factor of the blue channel for the luminance value should add up to 1 with red and green scaling), min=0, max=1

uniform bool luminance_preview = false; // Luminance Preview : (shows a monochrome image of the luminance)

uniform float red_threshold = 0.5; // Red Threshold : (threshold value for the red channel), min=0, max=1
uniform float green_threshold = 0.5; // Green Threshold : (threshold value for the green channel), min=0, max=1
uniform float blue_threshold = 0.5; // Blue Threshold : (threshold value for the blue channel), min=0, max=1

uniform vec3 rgb_threshold = vec3(0.5,0.5,0.5); // RGB Threshold : (threshold color for the individual red blue and green channels)
uniform float lum_threshold = 0.5; // Lum Threshold : (threshold value for the luminance), min=0, max=1








bool compare_f(float threshold, float data) {
    if (type == 0)
        return threshold < data;
    if (type == 1)
        return threshold <= data;
    if (type == 2)
        return data <= threshold;
    return data < threshold;
}

bvec3 compare_v(vec3 threshold, vec3 data) {
    if (type == 0)
        return lessThan(threshold, data);
    if (type == 1)
        return lessThanEqual(threshold,data);
    if (type == 2)
        return lessThanEqual(data, threshold);
    return lessThan(data, threshold);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    if (data_source == 0) {
        fragColor = vec4(vec3(compare_f(red_threshold, texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).r)), 0.);
        return;
    }
    if (data_source == 1) {
        fragColor = vec4(vec3(compare_f(green_threshold, texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).g)), 0.);
        return;
    }
    if (data_source == 2) {
        fragColor = vec4(vec3(compare_f(blue_threshold, texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).b)), 0.);
        return;
    }
    if (data_source == 3) {
        if (rgb_mode == 0) {
            fragColor = vec4(vec3(all(compare_v(rgb_threshold, texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).rgb))), 0.);
            return;
        }
        if (rgb_mode == 1) {
            fragColor = vec4(vec3(any(compare_v(rgb_threshold, texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).rgb))), 0.);
            return;
        }
        fragColor = vec4(compare_v(rgb_threshold, texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).rgb), 0.);
        return;
    }
    if (luminance_preview) {
        fragColor = vec4(vec3(dot(vec3(red_luminance, green_luminance, blue_luminance), texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).rgb)), 0.);
        return;
    }
    fragColor = vec4(vec3(compare_f(lum_threshold, dot(vec3(red_luminance, green_luminance, blue_luminance), texture2D(iChannel0, fragCoord.xy / vec2(iResolution.x, iResolution.y)).rgb))), 0.);
}
