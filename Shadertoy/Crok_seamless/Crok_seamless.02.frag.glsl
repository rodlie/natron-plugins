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
// Code original : crok_seamless Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_seamless Matchbox for Autodesk Flame


// iChannel0: Front, filter=linear, wrap=repeat
// iChannel0: pass1_result, filter=linear, wrap=repeat
// BBox: iChannel0


// based on https://www.shadertoy.com/view/Xtl3zf
// The MIT License
// Copyright © 2017 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction,
//including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// One way to avoid texture tile repetition one using one small texture to cover a huge area.
// Basically, it creates 8 different offsets for the texture and picks two to interpolate
// between.
//
// Unlike previous methods that tile space (https://www.shadertoy.com/view/lt2GDd or
// https://www.shadertoy.com/view/4tsGzf), this one uses a random low frequency texture
// (cache friendly) to pick the actual texture's offset.



uniform float shuffle1 = 9.0; // Shuffle : ,min=0.0, max=10000
uniform float zoom1 = 3.0; // Detail : ,min=0.0001, max=10000
uniform float noise_scale = 1.0; // Noise Scale : ,min=0.0001, max=10000


vec2 res = vec2(iResolution.x, iResolution.y);

float sum( vec3 v ) { return v.x+v.y+v.z; }

vec3 textureNoTile( in vec2 x, float v )
{
    float k = texture2D( iChannel1, 0.0007*x*noise_scale ).x; // cheap (cache friendly) lookup
    float l = k*8.0;
    float i = floor( l );
    float f = fract( l );
    vec2 offa = sin(vec2(3.0,7.0)*(i+0.0)); // can replace with any other hash
    vec2 offb = sin(vec2(3.0,7.0)*(i+1.0)); // can replace with any other hash
		vec3 cola = texture2D( iChannel0, x + v*offa).xyz;
		vec3 colb = texture2D( iChannel0, x + v*offb).xyz;
    return mix( cola, colb, smoothstep(0.2,0.8,f-0.1*sum(cola-colb)) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = 2.0 * ((fragCoord.xy / res.xy) - 0.5) * zoom1;
    vec3 col = textureNoTile(uv, shuffle1 );
	fragColor = vec4( col, 1.0 );
}
