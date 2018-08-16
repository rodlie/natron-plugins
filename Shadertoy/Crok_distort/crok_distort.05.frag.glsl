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
// Code original : crok_distort Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_distort Matchbox for Autodesk Flame


// iChannel0: Source , filter = linear , wrap = clamp
// iChannel1: pass4_result , filter = linear , wrap = clamp
// iChannel2: pass2_result , filter = linear , wrap = clamp
// BBox: iChannel0



#extension GL_ARB_shader_texture_lod : enable



uniform int style = 0; // Style : ,min=0, max=1

uniform float amount = 5.0; // Glossy Amount : 
uniform float glossy = 20.0; // Glossy Displace : 
uniform float softness = 10.0; // Glossy Softness : , min=0.01
uniform float aspect = 0.10; // Glossy Rotate : 

uniform float d_amount = 5.0; // Emboss Amount : 
uniform float height = 10.0; // Emboss Height : 
uniform float l_amount = 0.5; // Light Amount : 

uniform vec3 offset = vec3( 1.0 , 1.0 , 2.0 ); // Offset : 
uniform vec3 light = vec3( 0.0 , 1.0 , 0.05 ); // Light : 

uniform float blend = 1.0; // Strength Amount : , min=0.0, max=1.0

uniform bool enable_aa = false; // Enable Oversampling : 
uniform int oversamples = 3; // Samples : , min=1, max=16



float strength(vec2 uv)
{
	return texture2D(iChannel2, uv).r;
}


float lens(vec2 uv)
{
	float l_a = texture2D(iChannel1, uv).r;
	float s_a = strength(uv);
	return mix(l_a, l_a * s_a, blend);

}

vec2 norm(vec2 uv)
{
    vec2 e = vec2(0.001 * height, 0.0);
    return vec2(lens(uv+e.xy)-lens(uv-e.xy), lens(uv+e.yx)-lens(uv-e.yx));
}

vec3 color(vec2 p, vec2 fragCoord)
{
	vec3 c = vec3(0.0);
	if ( enable_aa )
	{
           for( int m=0; m<oversamples; m++ )
           for( int n=0; n<oversamples; n++ )
           {
		   		vec2 resolution = vec2(iResolution.x, iResolution.y);
				vec2 of = vec2( float(m), float(n) ) / float(oversamples);
			   vec2 uv = (fragCoord.xy + of) / resolution;

			   float w = lens(uv);
		       vec3 nn = normalize(vec3(norm(uv),w*w/4.));
		       vec3 o = vec3(uv,w);
		       vec3 off = normalize(vec3(0.5 - offset));
		       off = refract(off,nn,0.13);
		       o += off*w/20.0 * d_amount;
		       off = refract(off,vec3(nn.xy,-nn.z),0.76);
		   	   vec3 base = texture2D(iChannel0, vec2(o.xy)).rgb;
		       float highlite = abs(pow(abs(max(0.0,dot(normalize(0.5 - light),nn))),8.0 / l_amount));
			   c += base + highlite;
		   }
		   c /= float(oversamples * oversamples);
	}
	else
	{
	    float w = lens(p);
	    vec3 n = normalize(vec3(norm(p),w*w/4.0));
	    vec3 o = vec3(p,w);
	    vec3 off = normalize(vec3(0.5 - offset));
	    off = refract(off,n,0.13);
	    o += off*w/20.0 * d_amount;
	    off = refract(off,vec3(n.xy,-n.z),0.76);
		vec3 base = texture2D(iChannel0, vec2(o.xy)).rgb;
	    float highlite = abs(pow(abs(max(0.0,dot(normalize(0.5 - light),n))),8.0 / l_amount));
	    c = base + highlite;
	}
	return c;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 resolution = vec2(iResolution.x, iResolution.y);
	vec2 uv = fragCoord.xy / resolution;

	float distort = lens(uv);
	vec3 d = vec3 (0.0);
	vec3 col = vec3(0.0);

	if ( style == 1 )
	{
		col = color(uv, fragCoord);
	}

	if ( style == 0 )
	{
		if ( enable_aa )
		{
	           for( int m=0; m<oversamples; m++ )
	           for( int n=0; n<oversamples; n++ )
	           {
	               vec2 offf = vec2( float(m), float(n) ) / float(oversamples);
				   vec2 p = (fragCoord.xy + offf) / resolution;
				   d = normalize(vec3(distort - lens(p+vec2(0.001 * glossy * aspect, 0.0)), distort - lens(p+vec2(0.0, 0.001 / aspect)), softness * 0.1));
				   p += d.xy * - amount * 0.1;
				   col += texture2D(iChannel0, p).rgb;
			   }
			   col /= float(oversamples * oversamples);
		}


		else
		{
			d = normalize(vec3(distort - lens(uv+vec2(0.001 * glossy * aspect, 0.0)), distort - lens(uv+vec2(0.0, 0.001 / aspect)), softness * 0.1));
			uv += d.xy * - amount * 0.1;
			col = texture2D(iChannel0, uv).rgb;
		}
	}

	fragColor = vec4(col, 1.0);
}
