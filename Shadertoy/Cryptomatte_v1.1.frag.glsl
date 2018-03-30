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
// Code original : Cryptomatte Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Cryptomatte Matchbox for Autodesk Flame

// iChannel0: Crypto_ID 1, filter=linear, wrap=clamp
// iChannel1: Crypto_ID 2, filter=linear, wrap=clamp
// iChannel2: Crypto_ID 3, filter=linear, wrap=clamp
// BBox: iChannel0


/* Cryptomatte
     Given a set of ID/coverage pairs, extract up to four mattes
     See https://github.com/Psyop/Cryptomatte
     This shader by lewis@lewissaunders.com
     TODO: allow picking using the standard colour pots if the 65504.0
           limit is ever removed
*/



// Our colour picker widgets and whether they're enabled
uniform vec3 pickr = vec3( 0.0 , 0.0 , 0.0 );        // ID for R : 
uniform vec3 pickg = vec3( 0.0 , 0.0 , 0.0 );        // ID for G : 
uniform vec3 pickb = vec3( 0.0 , 0.0 , 0.0 );        // ID for B : 
uniform vec3 pickm = vec3( 0.0 , 0.0 , 0.0 );        // ID for Matte : 

uniform vec3 pickresult = vec3( 0.0 , 0.0 , 0.0);    // ID for result : 

uniform bool enabler = true; // Enable R : 
uniform bool enableg = true; // Enable G : 
uniform bool enableb = true; // Enable B : 
uniform bool enablem = true; // Enable Matte : 

uniform bool enableresult = true; // Enable Result : 

// Whether we should output a single matte on RGB, or three separate mattes
uniform bool separatergb = false; // Output 3 mattes in RGB : 

// Whether we should output the sum of all picked mattes
uniform bool combine = false; // Combine all mattes : 

// Dummy button with tooltip to remind about using the floating colour sampler
uniform bool reminder = false;

// Widget which is temporarily draggable over the image to inspect available mattes
vec2 inspect = vec2(iMouse.xy/iResolution.xy - 0.5); // Quick inspector : 








void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  // Convert fragment coords in pixels to texel coords in [0..1]
  vec2 res = vec2(iResolution.x, iResolution.y);
  vec2 xy = fragCoord.xy / res;




  // In these vectors the first element is the ID, the second the coverage
  vec2 rank0 = texture2D(iChannel0, xy).rg;
  vec2 rank1 = vec2(texture2D(iChannel0, xy).b, texture2D(iChannel0, xy).a);
  vec2 rank2 = texture2D(iChannel1, xy).rg;
  vec2 rank3 = vec2(texture2D(iChannel1, xy).b, texture2D(iChannel1, xy).a);
  vec2 rank4 = texture2D(iChannel2, xy).rg;
  vec2 rank5 = vec2(texture2D(iChannel2, xy).b, texture2D(iChannel2, xy).a);




  // Accumulate opacity from the ranks for each picked ID
  vec4 result = vec4(0.0);
  if(separatergb == true) {
    if(enabler) {
      if(rank0.x == pickr.r) result.r += rank0.y;
      if(rank1.x == pickr.r) result.r += rank1.y;
      if(rank2.x == pickr.r) result.r += rank2.y;
      if(rank3.x == pickr.r) result.r += rank3.y;
      if(rank4.x == pickr.r) result.r += rank4.y;
      if(rank5.x == pickr.r) result.r += rank5.y;
    }
    if(enableg == true) {
      if(rank0.x == pickg.r) result.g += rank0.y;
      if(rank1.x == pickg.r) result.g += rank1.y;
      if(rank2.x == pickg.r) result.g += rank2.y;
      if(rank3.x == pickg.r) result.g += rank3.y;
      if(rank4.x == pickg.r) result.g += rank4.y;
      if(rank5.x == pickg.r) result.g += rank5.y;
    }
    if(enableb) {
      if(rank0.x == pickb.r) result.b += rank0.y;
      if(rank1.x == pickb.r) result.b += rank1.y;
      if(rank2.x == pickb.r) result.b += rank2.y;
      if(rank3.x == pickb.r) result.b += rank3.y;
      if(rank4.x == pickb.r) result.b += rank4.y;
      if(rank5.x == pickb.r) result.b += rank5.y;
    }
  } else {
    if(enableresult == true) {
      if(rank0.x == pickresult.r) result.rgb += vec3(rank0.y);
      if(rank1.x == pickresult.r) result.rgb += vec3(rank1.y);
      if(rank2.x == pickresult.r) result.rgb += vec3(rank2.y);
      if(rank3.x == pickresult.r) result.rgb += vec3(rank3.y);
      if(rank4.x == pickresult.r) result.rgb += vec3(rank4.y);
      if(rank5.x == pickresult.r) result.rgb += vec3(rank5.y);
    }
  }

  if(enablem == true) {
    if(rank0.x == pickm.r) result.a += rank0.y;
    if(rank1.x == pickm.r) result.a += rank1.y;
    if(rank2.x == pickm.r) result.a += rank2.y;
    if(rank3.x == pickm.r) result.a += rank3.y;
    if(rank4.x == pickm.r) result.a += rank4.y;
    if(rank5.x == pickm.r) result.a += rank5.y;
  }

  if(combine == true) {
    // Combine the picked mattes.  Since our mattes are disjoint, we just add them,
    // although if for some reason the user has picked the same ID multiple times, this will
    // result in values over 1.0
    if(separatergb == true) {
      result = vec4(result.r + result.g + result.b + result.a);
    } else {
      result = vec4(result.r + result.a);
    }
  }

  // If the temporary inspector widget is inside the image, output the first three mattes under
  // it into RGB
  if(0.0 < inspect.x && inspect.x < 1.0 && 0.0 < inspect.y && inspect.y < 1.0) {
    vec2 inspectrank0 = texture2D(iChannel0, inspect).rg;
    vec2 inspectrank1 = vec2(texture2D(iChannel0, inspect).b, texture2D(iChannel0, inspect).a);
    vec2 inspectrank2 = texture2D(iChannel1, inspect).rg;
    vec2 inspectrank3 = vec2(texture2D(iChannel1, inspect).b, texture2D(iChannel1, inspect).a);
    vec2 inspectrank4 = texture2D(iChannel2, inspect).rg;
    vec2 inspectrank5 = vec2(texture2D(iChannel2, inspect).b, texture2D(iChannel2, inspect).a);
    result = vec4(0.0);
    if(rank0.x == inspectrank0.r) result.ra += rank0.yy;
    if(rank1.x == inspectrank0.r) result.ra += rank1.yy;
    if(rank2.x == inspectrank0.r) result.ra += rank2.yy;
    if(rank3.x == inspectrank0.r) result.ra += rank3.yy;
    if(rank4.x == inspectrank0.r) result.ra += rank4.yy;
    if(rank5.x == inspectrank0.r) result.ra += rank5.yy;

    if(rank0.x == inspectrank1.r) result.g += rank0.y;
    if(rank1.x == inspectrank1.r) result.g += rank1.y;
    if(rank2.x == inspectrank1.r) result.g += rank2.y;
    if(rank3.x == inspectrank1.r) result.g += rank3.y;
    if(rank4.x == inspectrank1.r) result.g += rank4.y;
    if(rank5.x == inspectrank1.r) result.g += rank5.y;

    if(rank0.x == inspectrank2.r) result.b += rank0.y;
    if(rank1.x == inspectrank2.r) result.b += rank1.y;
    if(rank2.x == inspectrank2.r) result.b += rank2.y;
    if(rank3.x == inspectrank2.r) result.b += rank3.y;
    if(rank4.x == inspectrank2.r) result.b += rank4.y;
    if(rank5.x == inspectrank2.r) result.b += rank5.y;
  }

  fragColor = result;
}
