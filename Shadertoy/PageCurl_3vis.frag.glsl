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
// Code original : PageCurl_3vis Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : PageCurl_3vis Matchbox for Autodesk Flame


// iChannel0: FrontBack,filter=linear,wrap=repeat
// iChannel1: Back,filter=linear,wrap=repeat
// iChannel2: Front,filter=linear,wrap=repeat
// BBox: iChannel0

//*****************************************************************************/
// 
// Filename: PageCurl_3vis.glsl
// Author: Eric Pouliot
// Based on code from http://labs.calyptus.eu/pagecurl/  and  rectalogic.github.io/webvfx/examples_2transition-shader-pagecurl_8html-example.html
// Copyright (c) 2013 3vis, Inc.
//
//*****************************************************************************/




uniform float time = 0.3; // Amount : (Turn completion), min=0.0, max=1.1

uniform float roll_angle = 30.0; // Roll angle : (roll angle), min=0.0, max=100.0

uniform float back_trans = 15.0; // Back transparency : (background transparency), min=0.0, max=500.0

uniform float shadow_top = 30.0; // Shadow top : (shadow top), min=0.0, max=1000.0
uniform float shadow_bottom = 0.5; // Shadow bottom : (shadow bottom), min=0.0, max=1000.0


uniform float r_offset_1 = 0.0; // r offset 1 : ,min=-10.0, max=10.0
uniform float r_offset_2 = 0.0; // r offset 2 : ,min=-10.0, max=10.0
uniform float r_offset_3 = 0.12; // r offset 3 : ,min=-10.0, max=10.0
uniform float r_offset_4 = 0.258; // r offset 4 : ,min=-10.0, max=10.0
uniform float r_offset_5 = 1.0; // r offset 5 : ,min=-10.0, max=10.0

uniform float rr_offset_1 = 0.0; // rr offset 1 : ,min=-10.0, max=10.0
uniform float rr_offset_2 = 0.0; // rr offset 2 : ,min=-10.0, max=10.0
uniform float rr_offset_3 = 0.15; // rr offset 3 : ,min=-10.0, max=10.0
uniform float rr_offset_4 = -0.5; // rr offset 4 : ,min=-10.0, max=10.0
uniform float rr_offset_5 = 1.0; // rr offset 5 : ,min=-10.0, max=10.0




const float MIN_AMOUNT = -0.25;
const float MAX_AMOUNT = 1.3;

float amount = time * (MAX_AMOUNT - MIN_AMOUNT) + MIN_AMOUNT;

const float PI = 3.141592653589793;

const float scale = 512.0;
const float sharpness = 3.0;

float cylinderCenter = amount;
// 360 degrees * amount
float cylinderAngle = 2.0 * PI * amount;

const float cylinderRadius = 1.0 / PI / 2.0;

vec3 hitPoint(float hitAngle, float yc, vec3 point, mat3 rrotation) {
    float hitPoint = hitAngle / (2.0 * PI);
    point.y = hitPoint;
    return rrotation * point;
}


vec4 antiAlias(vec4 color1, vec4 color2, float distance) {
    distance *= scale;
    if (distance < 0.0) return color2;
    if (distance > 2.0) return color1;
    float dd = pow(1.0 - distance / 2.0, sharpness);
    return ((color2 - color1) * dd) + color1;
}

float distanceToEdge(vec3 point) {
    float dx = abs(point.x > 0.5 ? 1.0 - point.x : point.x);
    float dy = abs(point.y > 0.5 ? 1.0 - point.y : point.y);
    if (point.x < 0.0) dx = -point.x;
    if (point.x > 1.0) dx = point.x - 1.0;
    if (point.y < 0.0) dy = -point.y;
    if (point.y > 1.0) dy = point.y - 1.0;
    if ((point.x < 0.0 || point.x > 1.0) && (point.y < 0.0 || point.y > 1.0)) return sqrt(dx * dx + dy * dy);
    return min(dx, dy);
}

vec4 seeThrough(float yc, vec2 p, mat3 rotation, mat3 rrotation, vec2 fragCoord) {

	vec2 texCoord = fragCoord.xy / vec2(iResolution.x, iResolution.y);
	
	float hitAngle = PI - (acos(yc / cylinderRadius) - cylinderAngle);
    vec3 point = hitPoint(hitAngle, yc, rotation * vec3(p, 1.0), rrotation);

    if (yc <= 0.0 && (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0)) {
        return texture2D(iChannel1, texCoord);
    }

    if (yc > 0.0) return texture2D(iChannel2, p);

    vec4 color = texture2D(iChannel2, point.xy);
    vec4 tcolor = vec4(0.0);

    return antiAlias(color, tcolor, distanceToEdge(point));
}

vec4 seeThroughWithShadow(float yc, vec2 p, vec3 point, mat3 rotation, mat3 rrotation, vec2 fragCoord) {
    float shadow = distanceToEdge(point) * shadow_top;
    shadow = (1.0 - shadow) / 3.0;
    if (shadow < 0.0) shadow = 0.0;
    else shadow *= amount;

    vec4 shadowColor = seeThrough(yc, p, rotation, rrotation, fragCoord);
    shadowColor.r -= shadow;
    shadowColor.g -= shadow;
    shadowColor.b -= shadow;
    return shadowColor;
}

vec4 backside(float yc, vec3 point) {
    vec4 color = texture2D(iChannel0, point.xy);
    float gray = (color.r + color.b + color.g) / back_trans;
    gray += (8.0 / 10.0) * (pow(1.0 - abs(yc / cylinderRadius), 2.0 / 10.0) / 2.0 + (5.0 / 10.0));
    color.rgb = vec3(gray);
    return color;
}

vec4 behindSurface(float yc, vec3 point, mat3 rrotation, vec2 fragCoord) {

	vec2 texCoord = fragCoord.xy / vec2(iResolution.x, iResolution.y);

	float shado = (1.0 - ((-cylinderRadius - yc) / amount * 7.0)) / 6.0;
    shado *= 1.0 - abs(point.x - 0.5);

    yc = (-cylinderRadius - cylinderRadius - yc);

    float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;
    point = hitPoint(hitAngle, yc, point, rrotation);

    if (yc < 0.0 && point.x >= 0.0 && point.y >= 0.0 && point.x <= 1.0 && point.y <= 1.0 && (hitAngle < PI || amount > 0.5)){
        shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / (71.0 / 100.0));
        shado *= pow(-yc / cylinderRadius, 3.0);
        shado *= shadow_bottom;
    } else
        shado = 0.0;

    return vec4(texture2D(iChannel1, texCoord).rgb - shado, 1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 texCoord = fragCoord.xy / vec2(iResolution.x, iResolution.y);

	float angle = roll_angle * PI / 180.0;

    float c = cos(-angle);
    float s = sin(-angle);

    mat3 rotation = mat3(
        c, s, r_offset_1,
        -s, c, r_offset_2,
        r_offset_3, r_offset_4, r_offset_5
    );

    c = cos(angle);
    s = sin(angle);

    mat3 rrotation = mat3(
        c, s, rr_offset_1,
        -s, c, rr_offset_2,
        rr_offset_3, rr_offset_4, rr_offset_5
    );

    vec3 point = rotation * vec3(texCoord, 1.0);

    float yc = point.y - cylinderCenter;

    if (yc < -cylinderRadius) {
        // Behind surface
        fragColor = behindSurface(yc, point, rrotation, fragCoord);
        return;
    }

    if (yc > cylinderRadius) {
        // Flat surface
        fragColor = texture2D(iChannel2, texCoord);
        return;
    }

    float hitAngle = (acos(yc / cylinderRadius) + cylinderAngle) - PI;

    float hitAngleMod = mod(hitAngle, 2.0 * PI);
    if ((hitAngleMod > PI && amount < 0.5) || (hitAngleMod > PI/2.0 && amount < 0.0)) {
        fragColor = seeThrough(yc, texCoord, rotation, rrotation, fragCoord);
        return;
    }

    point = hitPoint(hitAngle, yc, point, rrotation);

    if (point.x < 0.0 || point.y < 0.0 || point.x > 1.0 || point.y > 1.0) {
        fragColor = seeThroughWithShadow(yc, texCoord, point, rotation, rrotation, fragCoord);
        return;
    }

    vec4 color = backside(yc, point);

    vec4 otherColor;
    if (yc < 0.0) {
        float shado = 1.0 - (sqrt(pow(point.x - 0.5, 2.0) + pow(point.y - 0.5, 2.0)) / 0.71);
        shado *= pow(-yc / cylinderRadius, 3.0);
        shado *= 0.5;
        otherColor = vec4(0.0, 0.0, 0.0, shado);
    } else {
        otherColor = texture2D(iChannel2, texCoord);
    }

    color = antiAlias(color, otherColor, cylinderRadius - abs(yc));

    vec4 cl = seeThroughWithShadow(yc, texCoord, point, rotation, rrotation, fragCoord);
    float dist = distanceToEdge(point);

    fragColor = antiAlias(color, cl, dist);
}