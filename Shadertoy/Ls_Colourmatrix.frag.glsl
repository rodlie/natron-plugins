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
// Code original : Ls_Colourmatrix Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : Ls_Colourmatrix Matchbox for Autodesk Flame


// iChannel0: Source, filter = nearest
// iChannel1: Strength, filter = nearest
// BBox: iChannel0



// Colour matrix shader for Matchbox
// I apologise for the incredibly stupid variable names but it's 3am yo
// lewis@lewissaunders.com



uniform float r2r = 1.0; // Input R : ,min=-5, max=5
uniform float g2r = 0.0; // Input G : ,min=-5, max=5
uniform float b2r = 0.0; // Input B : ,min=-5, max=5
uniform vec3 or = vec3(1.0,0.0,0.0); // Push R into my : 



uniform float r2g = 0.0; // Input R : ,min=-5, max=5
uniform float g2g = 1.0; // Input G : ,min=-5, max=5
uniform float b2g = 0.0; // Input B : ,min=-5, max=5
uniform vec3 og = vec3(0.0,1.0,0.0); // Push G into my : 



uniform float r2b = 0.0; // Input R : ,min=-5, max=5
uniform float g2b = 0.0; // Input G : ,min=-5, max=5
uniform float b2b = 1.0; // Input B : ,min=-5, max=5
uniform vec3 ob = vec3(0.0,0.0,1.0); // Push B into my : 



uniform vec3 ir = vec3(1.0,0.0,0.0); // R becomes : 
uniform vec3 ig = vec3(0.0,1.0,0.0); // G becomes :
uniform vec3 ib = vec3(0.0,0.0,1.0); // B becomes :



uniform float effect = 1.0; // Multiply effect : , min=-10, max=10
uniform float gain = 1.0; // RGB gain : , min=0, max=10
uniform float mixx = 1.0; // Mix : , min=0, max=1




void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 coords = fragCoord.xy / vec2(iResolution.x, iResolution.y);
	float mixx_here = mixx * texture2D(iChannel1, coords).r;
	vec4 i = texture2D(iChannel0, coords);
	vec3 ii = vec3(r2r*i.r + g2r*i.g + b2r*i.b, r2g*i.r + g2g*i.g + b2g*i.b, r2b*i.r + g2b*i.g + b2b*i.b);
	vec3 iii = ii * mat3(or, og, ob);
	vec3 iv = mat3(ir, ig, ib) * iii;
	vec3 v = effect*iv + (1.0-effect)*i.rgb;
	vec3 vi = gain * v;
	vec3 vii = mixx_here*vi + (1.0-mixx_here)*i.rgb;
	fragColor = vec4(vii, i.a);
}
