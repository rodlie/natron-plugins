# lp_Despot

Eliminates black and white spots in channels.


INPUTS

img = Connect the image you want to despot; despot will only happen in the alpha channel 

mask = A connected alpha will mask the operation, leaving the original alpha of the img-input

HOW TO USE IT

Just connect any source you want to despot int the alpha channel. There are individual controls for despotting either black or white pixels; as both operations can't happen at the same time, you can choose the order of operation yourself :) Because of the nature of this tool, it can easily harm edge-detail, so use it with caution and don't over use :) to come by this limitation, you can try to enable the edge protect-function: this will enable a basic edge matte based on the despot result which is then used to keymix with the original alpha and its detail. You can adjust the thickness and softness of the edge matte with the given sliders.

HOW DOES IT WORK

Essentially the tool erodes and afterwards dilates a channel by the same value (and vice versa, depending if you despot for white or black). This will maintain the same shape overall, but get rid of fine detail. The edge matte works by using an eroded version of the matte as a stencil for a dilated one, blurring it afterwards; a simple keymix with the original does the rest.


![Screenshot](despot_bsp.png)
