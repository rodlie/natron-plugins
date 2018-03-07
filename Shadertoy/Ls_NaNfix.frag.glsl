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
// Code original : Ls_NaNfix Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : Ls_NaNfix Matchbox for Autodesk Flame
//
// NaNfix - interpolate NaN pixels from surroundings
// lewis@lewissaunders.com 

// iChannel0: rgba, filter = nearest, wrap=clamp
// BBox: iChannel0



uniform int radius = 1; // Radius : (radius), min=1, max=10





bool isnan(float f) {
  // Try a few things.  Some drivers optimise some of them away :/
  if(f != f) {
    return true;
  }
  if(f < 0.0 || 0.0 < f || f == 0.0) {
    return false;
  } else {
    return true;
  }
}

bool anynans(vec3 v) {
  if(isnan(v.r)) return true;
  if(isnan(v.g)) return true;
  if(isnan(v.b)) return true;
  return false;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 res = vec2(iResolution.x, iResolution.y);
    vec2 xy = fragCoord.xy;

    vec3 o = texture2D(iChannel0, xy / res).rgb;
    float m = 0.0;
    
    if(anynans(o)) {
      o = vec3(0.0);
      m = 1.0;
      float count = 0.0;
      float r = float(radius);
      for(float i = -r; i <= r; i += 1.0) {
        for(float j = -r; j <= r; j += 1.0) {
          vec3 here = texture2D(iChannel0, (xy + vec2(i, j))/res).rgb;
          if(!anynans(here)) {
            o += here;
            count += 1.0;
          }
        }
      }
      if(count == 0.0) {
        // Couldn't find any good pixels in surroundings! Output black.
        o = vec3(0.0);
      } else {
        o /= count;
      }
    }
    
    fragColor = vec4(o, m);
}
