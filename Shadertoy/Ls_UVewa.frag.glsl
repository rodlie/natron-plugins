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
// Code original : Ls_UVewa Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : Ls_UVewa Matchbox for Autodesk Flame
//
// UV mapping with EWA filtering
// Filtering code originally from http://www.pmavridis.com/ewa.html
// Hacked up extensively to work on old GPUs by lewis@lewissaunders.com

// Intrepid Matchbox developers can take the texture2DEWA() function and use
// it instead of texture2D() in other shaders for better filtering

// TODO:
//  o Distort a matte input also
//  o Linear filtering for magnification a la Action's EWA + Linear
//  o Overall transform mult
//  o Option to remove messy edges from UV map




// iChannel0: front, filter = nearest, wrap=clamp
// iChannel1: matte, filter = nearest, wrap=clamp
// iChannel2: uv, filter = nearest, wrap=clamp
// BBox: iChannel0





uniform float filterwidth = 1; // Filter width : (filter width), min=0, max=32
uniform float filtersharpness = 4; // Filter sharpness : (filter sharpness), min=0, max=32

uniform float lin4mag = 0.5; // +Lin breakpoint : (+Lin breakpoint), min=0, max=1
uniform float emult = 1; // Effect mult : (Effect mult), min=0, max=1


uniform bool flin = false; // Linear everywhere, no EWA : (linear everywhere, no EWA)
uniform bool outputdfdx = false; // Output minification factor : (output minification factor)
uniform bool convertoffsetuv = false; // Convert offset UVs to absolute : (convert offset UVs to absolut)

uniform int texellimit = 16; // Texel limit : (texel limit), min=1, max=4096
uniform vec2 offset = vec2(0, 0); // Offset : (offset)







vec4 texture2DEWA(sampler2D tex0, vec2 p0) {
	vec2 du = dFdx(p0);
	vec2 dv = dFdy(p0);
	float scale = iResolution.x;

	p0 -=vec2(0.5,0.5)/scale;
	vec2 p = scale * p0;

	float ux = filterwidth * du.s * scale;
	float vx = filterwidth * du.t * scale;
	float uy = filterwidth * dv.s * scale;
	float vy = filterwidth * dv.t * scale;

	// compute ellipse coefficients 
	// A*x*x + B*x*y + C*y*y = F.
	float A = vx*vx+vy*vy+1.0;
	float B = -2.0*(ux*vx+uy*vy);
	float C = ux*ux+uy*uy+1.0;
	float F = A*C-B*B/4.0;

	// Compute the ellipse's (u,v) bounding box in texture space
	float bbox_du = 2.0 / (-B*B+4.0*C*A) * sqrt((-B*B+4.0*C*A)*C*F);
	float bbox_dv = 2.0 / (-B*B+4.0*C*A) * sqrt(A*(-B*B+4.0*C*A)*F);

	// Clamp the ellipse so that the bbox includes at most TEXEL_LIMIT texels.
	// This is necessary in order to bound the run-time, since the ellipse can be arbitrarily large
	// Note that here we are actually clamping the bbox directly instead of the ellipse.
	if(bbox_du*bbox_dv>float(texellimit)) {
		float ll = sqrt(bbox_du*bbox_dv / float(texellimit));
		bbox_du/=ll;
		bbox_dv/ll;
	}

	// The ellipse bbox			    
	int u0 = int(floor(p.s - bbox_du));
	int u1 = int(ceil (p.s + bbox_du));
	int v0 = int(floor(p.t - bbox_dv));
	int v1 = int(ceil (p.t + bbox_dv));

	// Heckbert MS thesis, p. 59; scan over the bounding box of the ellipse
	// and incrementally update the value of Ax^2+Bxy*Cy^2; when this
	// value, q, is less than F, we're inside the ellipse so we filter
	// away...
	vec4 num= vec4(0.0, 0.0, 0.0, 1.0);
	float den = 0.0;
	float ddq = 2.0 * A;
	float U = float(u0) - p.s;

	for (int v = v0; v <= v1; ++v) {
		float V = float(v) - p.t;
		float dq = A*(2.0*U+1.0) + B*V;
		float q = (C*V + B*U)*V + A*U*U;
		for (int u = u0; u <= u1; ++u) {
			if (q < F) {
				float r2 = q / F;
				// Gaussian filter weights
				float weight = exp(-filtersharpness * r2);
			
				num += weight * texture2D(tex0, vec2(float(u)+0.5,float(v)+0.5)/scale);
				den += weight;
			}
			q += dq;
			dq += ddq;
		}
	}
	vec4 color = num*(1./den);
	return color;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 coords = fragCoord.xy / iResolution.xy;
	vec2 uv = texture2D(iChannel2, coords).rg;
	if(convertoffsetuv) {
		uv += coords;
	}
	uv += offset / 100.0;
	vec2 uvcoords = mix(coords, uv, emult);

	uvcoords = clamp(uvcoords, 0.0, 1.0);

	vec4 df = vec4(dFdx(uvcoords.x), dFdy(uvcoords.x), dFdx(uvcoords.y), dFdy(uvcoords.y));

	vec4 ewa = texture2DEWA(iChannel0, uvcoords);
	vec4 ewa_matte = texture2DEWA(iChannel1, uvcoords);
	vec4 lin = texture2D(iChannel0, uvcoords);
	vec4 lin_matte = texture2D(iChannel1, uvcoords);
	
	float linblend = smoothstep(1.0, 0.1/lin4mag * 4000.0, 1.0/length(df));
	vec4 o = mix(ewa, lin, linblend);
	vec4 m = mix(ewa_matte, lin_matte, linblend);

	if(flin) {
		o = lin;
		m = lin_matte;
	}
	
	if(outputdfdx) {
		o = vec4(length(df) * 10.0);
		m = vec4(length(df) * 10.0);
	}
	
	fragColor = vec4(o.rgb, m.g);
}



// Portions of the above were adapted from the demo source code published with the paper "High Quality Elliptical Texture Filtering on GPU"
// found at http://www.pmavridis.com/ewa.html
// MIT license text follows:
// Copyright (c) 2010-2011 Pavlos Mavridis
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
