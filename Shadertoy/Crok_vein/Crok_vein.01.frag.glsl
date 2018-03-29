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


// iChannel0: Texture, filter=linear, wrap=clamp
// iChannel1: Source, filter=linear, wrap=clamp
// BBox: iChannel0


#extension GL_ARB_shader_texture_lod : enable
// based on https://www.shadertoy.com/view/Mtc3Dj by cornusammonis



vec2 res = vec2(iResolution.x, iResolution.y);
float myGlobalTime = iTime *.05;





uniform int STEPS = 40; // Steps : ,min=1.0, max=1000

uniform float amp = 1.0; // Amplification : ,min=0.0, max=100
uniform float ts = 0.2; // Advection curl : ,min=0.0, max=100

uniform float ls = 0.05; // Laplacian : ,min=0.0, max=100
uniform float ps = -2.5; // Lap. Divergence : ,min=-100.0, max=100
uniform float cs = -2.0; // Curl : ,min=-100.0, max=100

uniform float ds = -0.4; // Divergence : ,min=-100.0, max=100
uniform float dp = -0.03; // Div. Update : ,min=-100.0, max=100
uniform float upd = 0.4; // Update : ,min=0.0, max=100

uniform float pl = 0.3; // Divergence : ,min=0.0, max=100

uniform bool adsk_accum_no_prev_frame = false; // No prev frame : 

#define _D 0.6    // diagonal weight

#define _K0 -20.0/6.0 // laplacian center weight
#define _K1 4.0/6.0   // laplacian edge-neighbors
#define _K2 1.0/6.0   // laplacian vertex-neighbors

#define _G0 0.25      // gaussian center weight
#define _G1 0.125     // gaussian edge-neighbors
#define _G2 0.0625    // gaussian vertex-neighbors


vec2 normz(vec2 x) {
	return x == vec2(0.0, 0.0) ? vec2(0.0, 0.0) : normalize(x);
}

#define T(d) texture2D(iChannel0, fract(aUv+d)).xyz

vec3 advect(vec2 ab, vec2 vUv, vec2 texel, out float curl, out float div, out vec3 lapl, out vec3 blur) {

    vec2 aUv = vUv - ab * texel;
    vec4 t = vec4(texel, -texel.y, 0.0);

    vec3 uv =    T( t.ww); vec3 uv_n =  T( t.wy); vec3 uv_e =  T( t.xw);
    vec3 uv_s =  T( t.wz); vec3 uv_w =  T(-t.xw); vec3 uv_nw = T(-t.xz);
    vec3 uv_sw = T(-t.xy); vec3 uv_ne = T( t.xy); vec3 uv_se = T( t.xz);

    curl = uv_n.x - uv_s.x - uv_e.y + uv_w.y + _D * (uv_nw.x + uv_nw.y + uv_ne.x - uv_ne.y + uv_sw.y - uv_sw.x - uv_se.y - uv_se.x);
    div  = uv_s.y - uv_n.y - uv_e.x + uv_w.x + _D * (uv_nw.x - uv_nw.y - uv_ne.x - uv_ne.y + uv_sw.x + uv_sw.y + uv_se.y - uv_se.x);
    lapl = _K0*uv + _K1*(uv_n + uv_e + uv_w + uv_s) + _K2*(uv_nw + uv_sw + uv_ne + uv_se);
    blur = _G0*uv + _G1*(uv_n + uv_e + uv_w + uv_s) + _G2*(uv_nw + uv_sw + uv_ne + uv_se);

    return uv;
}

vec2 rot(vec2 v, float th) {
	return vec2(dot(v, vec2(cos(th), -sin(th))), dot(v, vec2(sin(th), cos(th))));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{


    vec2 vUv = fragCoord.xy / res.xy;
    vec2 texel = 1.0 / res.xy;

    vec3 lapl, blur;
    float curl, div;

    vec3 uv = advect(vec2(0), vUv, texel, curl, div, lapl, blur);

    float sp = ps * lapl.z;
    float sc = cs * curl;
	float sd = uv.z + dp * div + pl * lapl.z;
    vec2 norm = normz(uv.xy);

    vec2 off = uv.xy;
    vec2 offd = off;
    vec3 ab = vec3(0);

    for(int i = 0; i < STEPS; i++) {
        advect(off, vUv, texel, curl, div, lapl, blur);
        offd = rot(offd,ts*curl);
        off += offd;
    	ab += blur / float(STEPS);
    }

    vec2 tab = amp * ab.xy + ls * lapl.xy + norm * sp + uv.xy * ds * sd;
    vec2 rab = rot(tab,sc);

    vec3 abd = mix(vec3(rab,sd), uv, upd);

    // initialize with noise
    vec3 init = texture2D(iChannel1, vUv, 5.0).xyz;
    abd.z = clamp(abd.z, -1.0, 1.0);
    abd.xy = clamp(length(abd.xy) > 1.0 ? normz(abd.xy) : abd.xy, -1.0, 1.0);
    fragColor = vec4(abd, 0.0);
    if(adsk_accum_no_prev_frame)  fragColor = 1.0 * vec4(-0.5 + init, 1);

}
