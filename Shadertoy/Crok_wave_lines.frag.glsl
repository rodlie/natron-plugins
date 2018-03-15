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
// Code original : crok_wave_lines Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_wave_lines Matchbox for Autodesk Flame

// based on http://glsl.heroku.com/e#13475.0



uniform float Lines = 29.0; // Lines : (lines), min=1.0, max=500.0
uniform float Brightness = 2.0; // Brightness : (brightness), min=0.0, max=100.0
uniform float Speed = 5.0; // Speed : (speed), min=-1000.0, max=1000.0
uniform float Offset = 37.0; // Offset : (offset), min=-1000.0, max=1000.0
uniform float Glow = 1; // Glow : (glow), min=0.0, max=10.0

uniform vec3 Colour1 = vec3(1.4, 0.8, 0.4); // Colour 1 : (colour1)
uniform vec3 Colour2 = vec3(0.5, 0.9, 1.3); // Colour 2 : (colour2)
uniform vec3 Colour3 = vec3(0.9, 1.4, 0.4); // Colour 3 : (colour3)
uniform vec3 Colour4 = vec3(1.8, 0.4, 0.3); // Colour 4 : (colour4)

float time = iTime * 0.01 * Speed + Offset;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float x, y, xpos, ypos;
	float t = time * 10.0;
    vec3 c = vec3(0.0);
    
    xpos = (fragCoord.x / iResolution.x);
    ypos = (fragCoord.y / iResolution.y);
    
    x = xpos;
    for (float i = 0.0; i < Lines; i += 1.0) {
        for(float j = 0.0; j < 2.0; j += 1.0){
            y = ypos
            + (0.30 * sin(x * 2.000 +( i * 1.5 + j) * 0.2 + t * 0.050)
               + 0.300 * cos(x * 6.350 + (i  + j) * 0.2 + t * 0.050 * j)
               + 0.024 * sin(x * 12.35 + ( i + j * 4.0 ) * 0.8 + t * 0.034 * (8.0 *  j))
               + 0.5);
            
            c += vec3(1.0 - pow(clamp(abs(1.0 - y) * 1. / Glow * 10., 0.0,1.0), 0.25));
        }
    }
    
    c *= mix(
             mix(Colour1, Colour2, xpos)
             , mix(Colour3, Colour4, xpos)
             ,(sin(t * 0.02) + 1.0) * 0.45
             ) * Brightness * .1;
    
    fragColor = vec4(c, 1.0);
}
