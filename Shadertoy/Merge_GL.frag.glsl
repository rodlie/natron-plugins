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
// Adaptation pour Natron par F. Fernandez
// Code original : crok_logicop Matchbox pour Autodesk Flame
//
// Adapted to Natron by F.Fernandez
// Original code : crok_logicop Matchbox for Autodesk Flame
//
//****************************************************************************/
// 
// Filename: logicOPS_3vis.glsl
// Author: Eric Pouliot
//
// Copyright (c) 2013 3vis, Inc.
//
//*****************************************************************************/
//
//	License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//	
//	25 of the layer blending modes from Photoshop.
//	
//	The ones I couldn't figure out are from Nvidia's advanced blend equations extension spec -
//	http://www.opengl.org/registry/specs/NV/blend_equation_advanced.txt
//	
//	~bj.2013
//
//*****************************************************************************/

// iChannel0: B, filter = nearest
// iChannel1: A, filter = nearest
// iChannel1: Modulate, filter = nearest
// BBox: iChannel0



uniform int blendingMode = 17; // Operation : (blending mode), min=0., max=25.
uniform float opacity = 1; // Mix : (mix), min=0., max=1.

uniform bool Ar = true; // R
uniform bool Ag = true; // G
uniform bool Ab = true; // B
uniform bool Aa = true; // A

uniform bool Br = true; // R
uniform bool Bg = true; // G
uniform bool Bb = true; // B
uniform bool Ba = true; // A


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



//****************** modes de fusion ********************//

vec4 colorBurn( vec4 s, vec4 d )
{
	return 1.0 - (1.0 - d) / s;
}

vec4 colorDodge( vec4 s, vec4 d )
{
	return d / (1.0 - s);
}

vec4 darken( vec4 s, vec4 d )
{
	vec4 c;
	c = min(s,d);
	return c;
}

vec4 difference( vec4 s, vec4 d )
{
	return abs(d - s);
}

vec4 darkerColor( vec4 s, vec4 d )
{
	return (s.x + s.y + s.z < d.x + d.y + d.z) ? s : d;
}

vec4 divide( vec4 s, vec4 d )
{
	return s / d;
}

vec4 exclusion( vec4 s, vec4 d )
{
	return s + d - 2.0 * s * d;
}

vec4 hardLight( vec4 s, vec4 d )
{
	vec4 c;
	c.x = hardLight(s.x,d.x);
	c.y = hardLight(s.y,d.y);
	c.z = hardLight(s.z,d.z);
	return c;
}

vec4 hardMix( vec4 s, vec4 d )
{
	return floor(s + d);
}

vec4 lighten( vec4 s, vec4 d )
{
	return max(s,d);
}

vec4 lighterColor( vec4 s, vec4 d )
{
	return (s.x + s.y + s.z > d.x + d.y + d.z) ? s : d;
}

vec4 linearBurn( vec4 s, vec4 d )
{
	return s + d - 1.0;
}

vec4 linearDodge( vec4 s, vec4 d )
{
	return s + d;
}


vec4 linearLight( vec4 s, vec4 d )
{
	return 2.0 * s + d - 1.0;
}

vec4 screen( vec4 s, vec4 d )
{
	return s + d - s * d;
}

vec4 screenMode( vec4 s, vec4 d )
{
	vec4 c;
	c = 1.0-((1.0-s)*(1.0-d));
	return c;
}

vec4 matte( vec4 s, vec4 d)
{
	vec4 c = vec4(0,0,0,0);
	c = (s*s.a) + (d*(1-s.a));
	c.a = s.a;
	return c;
}

vec4 multiply( vec4 s, vec4 d )
{
	return s*d;
}

vec4 overlay( vec4 s, vec4 d )
{
	vec4 c;
	c.x = overlay(s.x,d.x);
	c.y = overlay(s.y,d.y);
	c.z = overlay(s.z,d.z);
	return c;
}

vec4 pinLight( vec4 s, vec4 d )
{
	vec4 c;
	c.x = pinLight(s.x,d.x);
	c.y = pinLight(s.y,d.y);
	c.z = pinLight(s.z,d.z);
	return c;
}

vec4 plus( vec4 s, vec4 d )
{
	return s + d;
}

vec4 softLight( vec4 s, vec4 d )
{
	vec4 c;
	c.x = softLight(s.x,d.x);
	c.y = softLight(s.y,d.y);
	c.z = softLight(s.z,d.z);
	return c;
}

vec4 spotlightBlend( vec4 s, vec4 d )
{
	return d*s+d;
}

vec4 substract( vec4 s, vec4 d )
{
	return s - d;
}

vec4 vividLight( vec4 s, vec4 d )
{
	vec4 c;
	c.x = vividLight(s.x,d.x);
	c.y = vividLight(s.y,d.y);
	c.z = vividLight(s.z,d.z);
	return c;
}

vec4 luminosity( vec4 s, vec4 d )
{
	float dLum = dot(d, vec4(0.3, 0.59, 0.11,0));
	float sLum = dot(s, vec4(0.3, 0.59, 0.11,0));
	float lum = sLum - dLum;
	vec4 c = d + lum;
	float minC = min(min(c.x, c.y), c.z);
	float maxC = max(max(c.x, c.y), c.z);
	if(minC < 0.0) return sLum + ((c - sLum) * sLum) / (sLum - minC);
	else if(maxC > 1.0) return sLum + ((c - sLum) * (1.0 - sLum)) / (maxC - sLum);
	else return c;
}

vec4 over( vec4 s, vec4 d )
{
	vec4 c;
	c = s + ( d*(1-s.a) );
	return c;
}





void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 uv = fragCoord.xy / iResolution.xy;

	// source texture (upper layer)
	vec4 s = texture2D(iChannel1, uv);
	
	// destination texture (lower layer)
	vec4 d = texture2D(iChannel0, uv);

	// mask texture (mask entry)
	vec4 mask = texture2D(iChannel2, uv);

	vec4 c = vec4(0.0);


	// ########### selection des couches ########### //

	if(Ar == false)
		s.r = 0;

	if(Ag == false)
		s.g = 0;

	if(Ab == false)
		s.b = 0;

	if(Aa == false)
		s.a = 0;

	if(Br == false)
		d.r = 0;

	if(Bg == false)
		d.g = 0;

	if(Bb == false)
		d.b = 0;

	if(Ba == false)
		d.a = 0;

	// ########### selection des modes de fusion ########### //

	if( blendingMode == 0)
	   	c =  c + colorBurn(s,d);

	else if( blendingMode == 1)
	   	c =  c + colorDodge(s,d);

	else if( blendingMode == 2)
	   	c =  c + darken(s,d);

	else if(blendingMode == 3)
		c =  c + darkerColor(s,d);		

	else if(blendingMode == 4)
		c =  c + difference(s,d);

	else if(blendingMode == 5)
		c =  c + divide(s,d);

	else if(blendingMode == 6)
		c =  c + exclusion(s,d);

	else if(blendingMode == 7)
		c =  c + hardLight(s,d);

	else if(blendingMode == 8)
		c =  c + hardMix(s,d);

	else if(blendingMode == 9)
		c =  c + lighten(s,d);		

	else if(blendingMode == 10)
		c =  c + lighterColor(s,d);

	else if(blendingMode == 11)
		c =  c + linearBurn(s,d);

	else if(blendingMode == 12)
		c =  c + linearDodge(s,d);

	else if(blendingMode == 13)
		c =  c + linearLight(s,d);		

	else if(blendingMode == 14)
		c =  c + luminosity(s,d);

	else if(blendingMode == 15)
		c =  c + matte(s,d);

	else if(blendingMode == 16)
		c =  c + multiply(s,d);

	else if(blendingMode == 17)
		c =  c + over(s,d);

	else if(blendingMode == 18)
		c =  c + overlay(s,d);

	else if(blendingMode == 19)
		c =  c + pinLight(s,d);

	else if(blendingMode == 20)
		c =  c + plus(s,d);

	else if(blendingMode == 21)
		c =  c + screenMode(s,d);		

	else if(blendingMode == 22)
		c =  c + softLight(s,d);

	else if(blendingMode == 23)
		c =  c + spotlightBlend(s,d);

	else if(blendingMode == 24)
		c =  c + substract(s,d);

	else if(blendingMode == 25)
		c =  c + vividLight(s,d);

	// grabbing the result
	vec4 result = vec4(c.rgb, s.a);





	// multiplying the result by the opacity
	fragColor = mix(d, result, opacity);
}	