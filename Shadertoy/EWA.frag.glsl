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
//
// Adapted to Natron by F.Fernandez
//
// EWA filtering
// Filtering code originally from http://www.pmavridis.com/ewa.html
// Hacked up extensively to work on old GPUs by lewis@lewissaunders.com


// iChannel0: front, filter = nearest, wrap=clamp
// BBox: iChannel0



uniform float filterwidth = 1; // Filter width : (filter width), min=0, max=32
uniform float filtersharpness = 4; // Filter sharpness : (filter sharpness), min=0, max=32
uniform int texellimit = 16; // Texel limit : (texel limit), min=1, max=4096



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
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec4 ewa = texture2DEWA(iChannel0, uv);

	fragColor = vec4(ewa);
}