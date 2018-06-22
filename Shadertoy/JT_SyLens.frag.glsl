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
// Code original : SyLens Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : SyLens Matchbox for Autodesk Flame


// iChannel0: input1, filter=linear, wrap=clamp
// iChannel1: input2, filter=linear, wrap=clamp
// BBox: iChannel0
  
/*
  Original Lens Distortion Algorithm from SSontech (Syntheyes)
  http://www.ssontech.com/content/lensalg.htm
  
  r2 is radius squared.
  
  r2 = image_aspect*image_aspect*u*u + v*v
  f = 1 + r2*(k + kcube*sqrt(r2))
  u' = f*u
  v' = f*v
 
*/

// Controls 
uniform float kCoeff = -0.01; // Quartic : (Quartic distortion coefficient (the K coefficient). This can be computed automatically in Syntheyes when using 'Calculate Lens Distortion')
uniform float kCube = 0.0; // Cubic : (Cubic distortion (Kcube). Apply this if you are dealing with mustache distortion. Normally you would leave it at 0.)
uniform float uShift = 0.0; // H Off-Centre : (If the optical center of your lens is offset relative to the sensor/film back center add some shift here to distort off-center horizontally.)
uniform float vShift = 0.0; // V Off-Centre : (If the optical center of your lens is offset relative to the sensor/film back center add some shift here to distort off-center vertically.)

uniform float chroma_red = 0.0; // Red : (R chroma aberration multiplier)
uniform float chroma_green = 0.0; // Green : (G chroma aberration multiplier)
uniform float chroma_blue = 0.0; // Blue : (B chroma aberration multiplier)

uniform bool apply_disto = false; // Apply distorsion : (Apply distortion instead of removing it. Make sure you have enough overscan in your input!)




float distortion_f(float r) {
    float f = 1 + (r*r)*(kCoeff + kCube * r);
    return f;
}

// Returns the F multiplier for the passed distorted radius
float inverse_f(float r_distorted)
{
    float input1_frameratio = iResolution.x / iResolution.y;
    // Build a lookup table on the radius, as a fixed-size table.
    // We will use a vec2 since we will store the F (distortion coefficient at this R)
    // and the result of F*radius
    vec2[48] lut;
    
    // Since out LUT is shader-global check if it's been computed alrite
    // Flame has no overflow bbox so we can safely max out at the image edge, plus some cushion
    float max_r = sqrt((input1_frameratio * input1_frameratio) + 1) + 1;
    float incr = max_r / 48;
    float lut_r = 0;
    float f;
    for(int i=0; i < 48; i++) {
        f = distortion_f(lut_r);
        lut[i] = vec2(f, lut_r * f);
        lut_r += incr;
    }
    
    float t;
    // Now find the nehgbouring elements
    // only iterate to 46 since we will need
    // 47 as i+1
    for(int i=0; i < 47; i++) {
        if(lut[i].y < r_distorted && lut[i+1].y > r_distorted) {
            // BAM! our distorted radius is between these two
            // get the T interpolant and mix
            t = (r_distorted - lut[i].y) / (lut[i+1].y - lut[i]).y;
            return mix(lut[i].x, lut[i+1].x, t );
        }
    }
    // Rolled off the edge
    return lut[47].x;
}

float aberrate(float f, float chroma)
{
   return f + (f * chroma);
}

vec3 chromaticize_and_invert(float f)
{
   vec3 rgb_f = vec3(aberrate(f, chroma_red), aberrate(f, chroma_green), aberrate(f, chroma_blue));
   // We need to DIVIDE by F when we redistort, and x / y == x * (1 / y)
   if(apply_disto) {
      rgb_f = 1 / rgb_f;
   }
   return rgb_f;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
   vec2 px, uv;
   float f = 1;
   float r = 1;

   float input1_frameratio = iResolution.x / iResolution.y;

   float override_w = iResolution.x;
   float override_h = iResolution.y;
   
   px = fragCoord.xy;
   
   // Make sure we are still centered
   // and account for overscan
   px.x -= (iResolution.x - override_w) / 2;
   px.y -= (iResolution.y - override_h) / 2;
   
   // Push the destination coordinates into the [0..1] range
   uv.x = px.x / override_w;
   uv.y = px.y / override_h;
       
   // And to Syntheyes UV which are [1..-1] on both X and Y
   uv.x = (uv.x *2 ) - 1;
   uv.y = (uv.y *2 ) - 1;
   
   // Add UV shifts
   uv.x += uShift;
   uv.y += vShift;
   
   // Make the X value the aspect value, so that the X coordinates go to [-aspect..aspect]
   uv.x = uv.x * input1_frameratio;
   
   // Compute the radius
   r = sqrt(uv.x*uv.x + uv.y*uv.y);
   
   // If we are redistorting, account for the oversize plate in the input, assume that
   // the input aspect is the same
   if(apply_disto) {
      r = r / (float(iResolution.x) / float(override_w));
      f = inverse_f(r);
   } else {
      f = distortion_f(r);
   }
   
   vec2[3] rgb_uvs = vec2[](uv, uv, uv);
   
   // Compute distortions per component
   vec3 rgb_f = chromaticize_and_invert(f);
   
   // Apply the disto coefficients, per component
   rgb_uvs[0] = rgb_uvs[0] * rgb_f.rr;
   rgb_uvs[1] = rgb_uvs[1] * rgb_f.gg;
   rgb_uvs[2] = rgb_uvs[2] * rgb_f.bb;
   
   // Convert all the UVs back to the texture space, per color component
   for(int i=0; i < 3; i++) {
       uv = rgb_uvs[i];
       
       // Back from [-aspect..aspect] to [-1..1]
       uv.x = uv.x / input1_frameratio;
       
       // Remove UV shifts
       uv.x -= uShift;
       uv.y -= vShift;
       
       // Back to OGL UV
       uv.x = (uv.x + 1) / 2;
       uv.y = (uv.y + 1) / 2;
       
       rgb_uvs[i] = uv;
   }
   
   // Sample the input plate, per component
   vec4 sampled;
   sampled.r = texture2D(iChannel0, rgb_uvs[0]).r;
   sampled.g = texture2D(iChannel0, rgb_uvs[1]).g;
   sampled.b = texture2D(iChannel0, rgb_uvs[2]).b;
   
   // Alpha from the input2's R channel
   sampled.a = texture2D(iChannel1, rgb_uvs[0]).r;
   
   // and assign to the output
   fragColor.rgba = sampled;
}
