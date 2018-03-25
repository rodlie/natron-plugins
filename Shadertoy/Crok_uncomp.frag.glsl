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
// Code original : crok_uncomp Matchbox pour Autodesk Flame

// Adapted to Natron by F.Fernandez
// Original code : crok_uncomp Matchbox for Autodesk Flame

// iChannel0: FG, filter = nearest
// iChannel1: BG, filter = nearest
// iChannel2: Alpha, filter = nearest
// BBox: iChannel0


// uncompositing
// with huge help from Erwan Leroy



uniform float gamma = 2.4; // Gamma : , min=0.0, max=10.0
uniform float gain = 1.0; // Matte gain : , min=0.0, max=1.0
uniform int i_colorspace = 1; // Colorspace : ,min=0, max=2
uniform int modus = 0; // Modus : ,min=0, max=1



vec4 rem_gamma( vec4 c )
{
    return pow( c, vec4(gamma));
}

vec4 srgb2lin(vec4 col)
{
    if (col.r >= 0.0) {
         col.r = pow((col.r +.055)/ 1.055, 2.4);
    }
    if (col.g >= 0.0) {
         col.g = pow((col.g +.055)/ 1.055, 2.4);
    }
    if (col.b >= 0.0) {
         col.b = pow((col.b +.055)/ 1.055, 2.4);
    }
    return col;
}

vec4 do_colorspace(vec4 iChannel0)
{
	if (i_colorspace == 0) {
		//linear
		iChannel0 = iChannel0;
		}
	else if (i_colorspace == 1) {
		iChannel0 = srgb2lin(iChannel0);
    }
    else if (i_colorspace == 2) {
      iChannel0 = rem_gamma(iChannel0);
    }
    return iChannel0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / vec2( iResolution.x, iResolution.y );

    vec4 f = texture2D( iChannel0, uv );
    vec4 b = texture2D( iChannel1, uv);
		vec4 m = texture2D( iChannel2, uv);
		vec4 c = vec4(0.0);

		if ( modus == 0 )
		{
			// adjust colourspace
			f = do_colorspace(f);
      b = do_colorspace(b);
      if (i_colorspace != 1)
        m = do_colorspace(m);

			// Undo a blend operation:
			c = f-b*(1.0-m);
		}
		else
		{
			// remove logo from BG
			//iChannel1ground = Result / (1 – AlphaOfA) - Foreground
			c = (b - f) / (1.0 - m * gain);
		}
		fragColor = vec4(c.rgb, m.r);
}
