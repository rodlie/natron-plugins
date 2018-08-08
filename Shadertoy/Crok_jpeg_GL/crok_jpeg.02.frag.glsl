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
// Code original : crok_jpeg Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_jpeg Matchbox for Autodesk Flame


// iChannel0: pass1_result,filter=linear,wrap=clamp
// BBox: iChannel0


uniform int amount = 16; // Resolution : (resolution), min=0, max=16

float PI = radians(180.0);
float BSf = float(amount);

float basis1D(int k, int i)
{
    return k == 0 ? sqrt(1. / BSf) :
      sqrt(2. / BSf) * cos(float((2 * i + 1) * k) * PI / (2. * BSf));
}

float basis2D(ivec2 jk, ivec2 xy)
{
    return basis1D(jk.x, xy.x) * basis1D(jk.y, xy.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy;
    vec4 c = vec4(0.0);
    ivec2 coords = ivec2(uv);
    ivec2 inBlock = ivec2(0);
    inBlock.x = int(mod(coords.x, amount));
    inBlock.y = int(mod(coords.y, amount));
    ivec2 block = coords - inBlock;

    for (ivec2 xy = ivec2(0); xy.x < amount; xy.x++) {
        for (xy.y = 0; xy.y < amount; xy.y++) {
            c += texture2D(iChannel0, (vec2(block + xy) + vec2(0.5)) / vec2(iResolution.x, iResolution.y)) * basis2D(xy, inBlock);
        }
    }
    fragColor = c;
}
