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
// Code original : crok_block_noise Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_block_noise Matchbox for Autodesk Flame


uniform float Speed = 1; // Speed : (speed), min=-100, max=100
uniform float Offset = 0; // Offset : (offset), min=-100, max=100
uniform float scale = 12; // Detail : (detail), min=-100, max=100
uniform float scale_x = 2; // Scale X : (scale x), min=0, max=100
uniform float scale_y = 10; // Scale Y : (scale y), min=0, max=100
uniform float seed = 1; // Seed : (seed), min=-100, max=100
uniform float gain = 1; // Gain : (gain), min=0, max=100
uniform float aspect_x = 1; // Aspect X : (aspect x), min=-500, max=500
uniform float aspect_y = 1; // Aspect Y : (aspect y), min=-500, max=500
uniform vec3 tint = vec3(1,1,1); // Colour : (colour)



float time = iTime * .04234 * Speed + Offset + 200.0;


float rand(vec2 n)
{
  return fract(sin(dot(n.xy, vec2(0.000435134551 * scale_x, .0043451929 * scale_y)))* time);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

	vec2 position = ( fragCoord.xy / iResolution.xy );
	float color = rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale) / scale)
		+rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*2.0) / scale*2.0 )
		+rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*4.0) / scale*4.0 )
		+rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*8.0) / scale*8.0 )
		+rand(seed*floor((position.xy*vec2(1.0 * aspect_x,0.5 * aspect_y) + 0.5) * scale*16.0) / scale*16.0 );
	color = color / 5.0 * gain;

	fragColor = vec4( vec3( color*tint.r, color*tint.g, color*tint.b), 1.0 );

}