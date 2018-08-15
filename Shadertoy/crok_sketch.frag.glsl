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
// Code original : crok_sketch Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_sketch Matchbox for Autodesk Flame


// iChannel0: Source, filter=linear, wrap=clamp
// iChannel1: Noise, filter=linear, wrap=clamp
// BBox: iChannel0


// based on https://www.shadertoy.com/view/XtVGD1 by flockaroo
// created by florian berger (flockaroo) - 2016
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// trying to resemle some hand drawing style


uniform int AngleNum = 3; // Strokes : (Strokes), min=1, max=32
uniform int SampNum = 16; // Steps : (Steps), min=1, max=64
uniform float amount = 400.0; // Amount : (Amount)
uniform bool vignette = true; // Enable Vignette : (Enable vignette)

uniform int style = 0; // Fill/Outline : ,min=0, max=2
uniform int paper = 0; // Paper : , min=0, max=1
uniform int blendModes = 0; // Blend Modes : , min=0, max=13

uniform float p_amount = 1.0; // Amount : , min=0.0

uniform float out_blend = 1.0; // Blend Outline : , min=0.0, max=1.0
uniform float out_blend2 = 1.0; // Blend : , min=0.0, max=1.0

uniform float fill_blend = 1.0; // Blend Fill : , min=0.0, max=1.0
uniform float fill_blend2 = 1.0; // Blend : , min=0.0, max=1.0


float myGlobalTime = iTime *.05;


//********************* fonctions ***********************//

float overlay( float s, float d )
{
	return (d < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
}

float softLight( float s, float d )
{
	return (s < 0.5) ? d - (1.0 - 2.0 * s) * d * (1.0 - d) 
		: (d < 0.25) ? d + (2.0 * s - 1.0) * d * ((16.0 * d - 12.0) * d + 3.0) 
					 : d + (2.0 * s - 1.0) * (sqrt(d) - d);
}

float hardLight( float s, float d )
{
	return (s < 0.5) ? 2.0 * s * d : 1.0 - 2.0 * (1.0 - s) * (1.0 - d);
}

float vividLight( float s, float d )
{
	return (s < 0.5) ? 1.0 - (1.0 - d) / (2.0 * s) : d / (2.0 * (1.0 - s));
}

float pinLight( float s, float d )
{
	return (2.0 * s - 1.0 > d) ? 2.0 * s - 1.0 : (s < 0.5 * d) ? 2.0 * s : d;
}


vec4 getBlendedValue( int blendType, vec4 srcColor, vec4 dstColor )
{
	vec4 blendResult = vec4(0,0,0,0);


	if (blendType == 0)
	{
		// None
		blendResult = dstColor;
	}

	if (blendType == 1)
	{
		// Add
		blendResult = srcColor + dstColor;
	}

	if (blendType == 2)
	{
		// Substract
		blendResult = srcColor - dstColor;
	}

	if (blendType == 3)
	{
		// Multiply
		blendResult = srcColor * dstColor;
	}

	if (blendType == 4)
	{
		// Linear Burn
		blendResult = srcColor + dstColor - 1.0;
	}

	if (blendType == 5)
	{
		// Spot light Blend
		blendResult = dstColor * srcColor + dstColor;
	}

	if (blendType == 6)
	{
		// Soft light
		blendResult.x = softLight(srcColor.x,dstColor.x);
		blendResult.y = softLight(srcColor.y,dstColor.y);
		blendResult.z = softLight(srcColor.z,dstColor.z);	
	}

	if (blendType == 7)
	{
		// Hard light
		blendResult.x = hardLight(srcColor.x,dstColor.x);
		blendResult.y = hardLight(srcColor.y,dstColor.y);
		blendResult.z = hardLight(srcColor.z,dstColor.z);	
	}

	if (blendType == 8)
	{
		// Pin light
		blendResult.x = pinLight(srcColor.x,dstColor.x);
		blendResult.y = pinLight(srcColor.y,dstColor.y);
		blendResult.z = pinLight(srcColor.z,dstColor.z);	
	}

	if (blendType == 9)
	{
		// Screen
		blendResult = 1 - ( 1 - srcColor ) * ( 1 - dstColor );
	}

	if (blendType == 10)
	{
		// Overlay
		blendResult.x = overlay(srcColor.x,dstColor.x);
		blendResult.y = overlay(srcColor.y,dstColor.y);
		blendResult.z = overlay(srcColor.z,dstColor.z);		
	}

	if (blendType == 11)
	{
		// Difference
		blendResult = abs(srcColor - dstColor);
	}

	if (blendType == 12)
	{
		// Exclusion
		blendResult = srcColor + dstColor - 2.0 * srcColor * dstColor;
	}

	if (blendType == 13)
	{
		// Linear light
		blendResult = 2.0 * srcColor + dstColor - 1.0;
	}

	return blendResult;
}


float getLuminance( vec3 rgb )
{
	return dot(rgb, vec3(0.299, 0.587, 0.114));
}

vec3 hsv2rgb( vec3 c )
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

#define Res iResolution.xy
#define PI2 6.28318530717959







vec4 getRand(vec2 pos)
{
    return texture2D(iChannel1, pos / Res / Res.y * Res.y);
}

vec4 getCol(vec2 pos)
{
    vec2 uv = ((pos - Res.xy * 0.5) / Res.y * Res.y) / Res.xy + 0.5;
    vec4 c1 = texture2D(iChannel0, uv);
    vec4 e = smoothstep(vec4(-0.05), vec4(0.0), vec4(uv,vec2(1.0) - uv));
    c1 = mix(vec4(1.0, 1.0, 1.0, 0.0), c1, e.x * e.y * e.z * e.w);
    float d = clamp(dot(c1.xyz, vec3(-0.5, 1.0, -0.5)), 0.0, 1.0);
    vec4 c2 = vec4(0.7);
    return min(mix(c1, c2, 1.8 * d), 0.7);
}

vec4 getColHT(vec2 pos)
{
 	return smoothstep(0.95, 1.05, getCol(pos) * 0.8 + 0.2 + getRand(pos * 0.7));
}

float getVal(vec2 pos)
{
    vec4 c = getCol(pos);
 	return pow(abs(dot(c.xyz, vec3(0.333))), 1.0);
}

vec2 getGrad(vec2 pos, float eps)
{
   	vec2 d = vec2(eps, 0.0);
    return vec2(
        getVal(pos+d.xy)-getVal(pos-d.xy),
        getVal(pos+d.yx)-getVal(pos-d.yx)
    ) / eps / 2.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 pos = fragCoord.xy + 4.0 * Res.y / amount;
	vec2 uv = fragCoord.xy / Res;
	vec3 org = texture2D(iChannel0, uv).rgb;
	vec4 f_col = vec4(0.0);
	float c_out = 0.0;
    vec3 c_fill = vec3(0.0);
    float sum = 0.0;
    for(int i=0; i<AngleNum; i++)
    {
        float ang = PI2 / float(AngleNum) * (float(i) + 0.8);
        vec2 v = vec2(cos(ang),sin(ang));
        for(int j=0; j<SampNum; j++)
        {
            vec2 dpos  = v.yx * vec2(1.0, -1.0) * float(j) * Res.y / amount;
            vec2 dpos2 = v.xy * float(j*j) / float(SampNum) * Res.y / amount;
	        vec2 g = vec2(0.0);
            float fact = 0.0;
            float fact2 = 0.0;

            for(float s=-1.0; s<=1.0; s+=2.0)
            {
                vec2 pos2 = pos + s * dpos + dpos2;
                vec2 pos3 = pos + (s * dpos + dpos2).yx * vec2(1.0, -1.0) * 2.0;
            	g = getGrad(pos2, 0.4);
            	fact = dot(g, v) - 0.5 * abs(dot(g, v.yx * vec2(1.0, -1.0))) * 1.6;
            	fact2 = dot(normalize(g + vec2(0.0001)), v.yx * vec2(1.0,-1.0));
                fact = clamp(fact, 0.0, 0.05);
                fact2 = abs(fact2);
                fact *= 1.0 - float(j) / float(SampNum);
            	c_out += fact;
            	c_fill += fact2 * getColHT(pos3).xyz;
            	sum += fact2;
            }
        }
    }
    c_out /= float(SampNum * AngleNum) * 0.75 / sqrt(Res.y);
    c_fill /= sum;
    c_out = 1.0 - c_out;
    c_out *= c_out * c_out;

	// add paper texture
	vec3 p_text=vec3(1.0);
	if ( paper == 1)
	{
		vec2 s = sin(pos.xy * 0.1 / sqrt(Res.y / amount));
	    p_text -= 0.5 * vec3(0.25, 0.1, 0.1) * (exp(-s.x * s.x * 80.0) + exp(-s.y * s.y * 80.0));
		p_text = mix(vec3(1.0), p_text, p_amount);
	}

	// add vignette
	float vign = 1.0;
	if ( vignette )
	{
		float r = length(pos - Res * 0.5) / Res.x;
		vign = 1.0 - r*r*r;
	}

	float matte = 1.0 - clamp(c_out * c_out, 0.0, 1.0);
	if ( style == 0 )
	{
		c_out = mix(1.0, c_out, out_blend);
		c_fill = mix(org, c_fill, fill_blend);
		f_col = vec4(vec3(c_out * c_fill * p_text * vign), matte);
	}
	if ( style == 1 )
	{
		f_col.rgb = mix(org, vec3(c_out), out_blend2);
		f_col = vec4(vec3(f_col.rgb * p_text * vign), matte);
	}
	if ( style == 2 )
	{
		f_col.rgb = mix(org, vec3(c_fill), fill_blend2);
		f_col = vec4(vec3(f_col.rgb * p_text * vign), matte);
	}

	f_col = getBlendedValue(blendModes, vec4(org, 1.0), vec4(f_col));

	fragColor = f_col;
}
