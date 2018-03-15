/*
	Hexagon Pattern Creator
	Written by: Craig Russo
	Email: craig@310studios.com
	Website: www.crusso.com
	
	Date Created: 5/10/2014
	version: .02

	Based on : https://gist.github.com/rgngl/5565102

	Copyright (C) 2014 Craig P. Russo

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	
*/




uniform float scale = 20; // Scale : (scale), min=5, max=500
uniform float lineThick = 0.15; // Line thickness : (line thickness), min=0.02, max=0.8
uniform float posx = 0.0; // X : (x position), min=-10000, max=10000
uniform float posy = 0.0; // Y : (y position), min=-10000, max=10000
uniform float rotate = 0.0; // Rotate : (rotate), min=-10000, max=10000
uniform float shapew = 1.1547; // Shape width : (shape width), min=0.0, max=10.80
uniform float shapeh = 1.49999; // Shape height : (shape height), min=0.0, max=10.80

uniform vec3 linecolor = vec3(1,1,1);
uniform vec3 backcolor = vec3(0,0,0);

uniform bool hardedge = false;
uniform bool invertmatte = false;

// 1 on edges, 0 in middle
float hex(vec2 p) {
  //p.x *= 0.57735*2.0;
  p.x *= shapew;
  p.x -= posx;
	p.y += (mod(floor(p.x), 2.0)*0.5);
	p.y -= posy;

	//p = abs((mod(p, 1.0) - 0.5));
	p = abs((mod(p, 1.0) - 0.5));
	//return abs(max(p.x*1.5 + p.y, p.y*2.0) - 1.0);
	return abs(max(p.x*shapeh + p.y, p.y*2.0) - 1.0);
}


// Rotation Matix This doesn't work yet  I got this from here: http://www.neilmendoza.com/glsl-rotation-about-an-arbitrary-axis/
//-----------------------------------------------------------



mat4 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

// -------------------------------------------------------------------





void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

//normalize canvas coordinates
vec2 st;
st.x = fragCoord.x / iResolution.x;
st.y = fragCoord.y / iResolution.y;

//gl_TexCoord[ 0 ] = gl_MultiTexCoord0*rotationMatrix(st/2,rotate);

vec2 pos = fragCoord.xy;

vec2 p = pos/scale; 
vec4 color = vec4(smoothstep(0.0, lineThick, hex(p)));
		
	

	fragColor = color;

	
	//This inverts the colors
	fragColor.rgb = vec3(1.0, 1.0, 1.0) - fragColor.rgb;

	//Invert Alpha
	if(invertmatte == false){
	fragColor.a = 1.0 - fragColor.a;
	}

	
	if(hardedge){

		//This Colors Lines
		fragColor.rgb = fragColor.rgb * linecolor;

		//This Colors Fills
		if(fragColor.rgb == vec3(0)){
			fragColor.rgb = vec3(backcolor);
		}else{
			fragColor.rgb = vec3(linecolor);
		}
	
	}else{

		//This Colors Lines
		fragColor.rgb = fragColor.rgb * linecolor;
		//This Colors fills
		fragColor.rgb = fragColor.rgb + backcolor;


	}

	
	
}



 

