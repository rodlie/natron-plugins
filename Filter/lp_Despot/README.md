# lp_Despot

Eliminates black and white spots in channels. Can harm edge-detail.

INPUTS
img = Connect the image (or alpha) you want to despot
mask = A connected alpha will mask the operation, leaving the original alpha of the img-input

HOW TO USE IT
Just connect any source you want to despot in any way. Usually this only used on alpha channels, therefore it will only work on that one by default; a positive value will despot white pixels, a negative value is targeted for black pixels.
Still, you can also activate the RGB channels in case you want to utilize it for some retouching or beauty work.
Because of the nature of this tool, it can easily harm edge-detail, so use it with caution and don't over use :)

HOW DOES IT WORK
Essentially the tool erodes and afterwards dilates a channel by the same value (and vice versa, depending if you despot for white or black). This will maintain the same shape overall, but get rid of fine detail; spots as well as edges, so be careful.
