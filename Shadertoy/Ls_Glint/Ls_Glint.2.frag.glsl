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
// Code original : Ls_Glint Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Glint Matchbox for Autodesk Flame


// iChannel0: pass1_result, filter = linear , wrap = clamp
// BBox: iChannel0


// Glint pass 2: Gaussian blur horizontal
// lewis@lewissaunders.com



uniform float blursize = 0.5;     // Blur : , min=0.0, max=10000.0
uniform float blursizer = 1.0;    // Blur weight R : , min=0.0, max=10000.0
uniform float blursizeg = 1.0;    // Blur weight G : , min=0.0, max=10000.0
uniform float blursizeb = 1.0;    // Blur weight B : , min=0.0, max=10000.0



// Return a 1D Gaussian blur from texture tex
// xy: centre of blur in pixels
// res: pixel size of mipmap level selected by lod param
// sizes: sigma of blurs, in pixels
// dir: direction of blur, usually vec2(1.0, 0.0) for horizontal followed by
//      another pass for vertical
vec4 gaussianblur(sampler2D tex, vec2 xy, vec2 res, float sizered, float sizegreen, float sizeblue, float sizealpha, vec2 dir) {
    vec4 sigmas = vec4(sizered, sizegreen, sizeblue, sizealpha);

    // Set up state for incremental coefficient calculation, see GPU Gems
    // We use vec4s to store four copies of the state, for different size
    // red/green/blue/alpha blurs
    vec4 gx = vec4(0.0);
    vec4 gy = vec4(0.0);
    vec4 gz = vec4(0.0);

    gx = 1.0 / (sqrt(2.0 * 3.141592653589793238) * sigmas);
    gy = exp(-0.5 / (sigmas * sigmas));
    gz = gy * gy;
    // vec4 a, centre, sample1, sample2 = vec4(0.0);
    vec4 a = vec4(0.0);
    vec4 centre = vec4(0.0);
    vec4 sample1 = vec4(0.0);
    vec4 sample2 = vec4(0.0);

    // First take the centre sample
    centre = texture2D(tex, xy / res);
    a += gx * centre;
    vec4 energy = gx;
    gx *= gy;
    gy *= gz;

    // Now the other samples
    float support = max(max(max(sigmas.r, sigmas.g), sigmas.b), sigmas.a) * 3.0;
    for(float i = 1.0; i <= support; i++) {
        sample1 = texture2D(tex, (xy - i * dir) / res);
        sample2 = texture2D(tex, (xy + i * dir) / res);
        a += gx * sample1;
        a += gx * sample2;
        energy += 2.0 * gx;
        gx *= gy;
        gy *= gz;
    }
    
    a /= energy;
    
    if(sizered < 0.1) a.r = centre.r;
    if(sizegreen < 0.1) a.g = centre.g;
    if(sizeblue < 0.1) a.b = centre.b;
    
    return a; 
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 res = vec2(iResolution.x, iResolution.y);
    vec2 xy = fragCoord.xy;
    fragColor = gaussianblur(iChannel0, xy, res, blursize*blursizer, blursize*blursizeg, blursize*blursizeb, 0.0, vec2(1.0, 0.0));
}
