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
// Code original : crok_regrain Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_regrain Matchbox for Autodesk Flame


float time = iTime *.05;

uniform float overall = 1.0;				 // Amount : ,min=0.0, max=100.0
uniform vec3 amount = vec3(1.0,1.0,1.0);	 // Gain : 
uniform int stock = 0 ;						 // Stock : ,min=0, max=12
uniform float offset = 0;

vec3 noise(vec3 p3)
{
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
  p3 += dot(p3, p3.yxz+19.19);
  return fract((p3.xxy + p3.yxx)*p3.zyx);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
	vec2 position = fragCoord.xy;
	vec3 pos = vec3(position, time*.3) + time * 500. + 50.0;

	if ( stock == 11 )
		pos = vec3(position, time*0.0+ offset) + offset;
	else if ( stock == 12 )
		pos = vec3(position, time*0.0+offset) + offset;

	vec3 grain = noise(pos);
	vec3 grau = vec3 (0.5);
	vec3 c = vec3(0.0);


// Kodak 5245
	if ( stock == 0)
	{
		float p_red = 4.16;
		float p_green = 5.31;
		float p_blue = 12.00;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5248
	else if ( stock == 1)
	{
		float p_red = 2.91;
		float p_green = 4.09;
		float p_blue = 7.50;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5287
	else if ( stock == 2)
	{
		float p_red = 1.98;
		float p_green = 2.05;
		float p_blue = 3.64;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5293
	else if ( stock == 3)
	{
		float p_red = 4.08;
		float p_green = 4.63;
		float p_blue = 5.78;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5296
	else if ( stock == 4)
	{
		float p_red = 3.41;
		float p_green = 4.48;
		float p_blue = 16.43;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5298
	else if ( stock == 5)
	{
		float p_red = 1.50;
		float p_green = 1.59;
		float p_blue = 1.96;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5217
	else if ( stock == 6)
	{
		float p_red = 3.61;
		float p_green = 4.05;
		float p_blue = 8.09;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak 5218
	else if ( stock == 7)
	{
		float p_red = 2.73;
		float p_green = 2.51;
		float p_blue = 11.60;

		grain.r = mix(grau.r, grain.r, p_red * amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, p_green * amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, p_blue * amount.b * .05 * overall);
	}

// Kodak BW
	else if ( stock == 8)
	{
		grain = mix(grau, grain, overall * .1);
		grain = vec3(grain.r);
	}


// Custom grain stock
	else if (stock == 9 )
	{
		grain.r = mix(grau.r, grain.r, amount.r * .05 * overall);
		grain.g = mix(grau.g, grain.g, amount.g * .05 * overall);
		grain.b = mix(grau.b, grain.b, amount.b * .05 * overall);
	}

// Alan Skin BW
	else if ( stock == 10 )
	{
		grain = mix(grau, grain, overall* 1.5);
		grain = vec3(grain.r);
	}

// BW Static grain
	else if ( stock == 11)
	{
		grain = mix(grau, grain, overall * .1);
		grain = vec3(grain.r);
	}

	// Custom Static grain stock
		else if (stock == 12 )
		{
			grain.r = mix(grau.r, grain.r, amount.r * .05 * overall);
			grain.g = mix(grau.g, grain.g, amount.g * .05 * overall);
			grain.b = mix(grau.b, grain.b, amount.b * .05 * overall);
		}

	fragColor = vec4(grain, 1.0);
}
