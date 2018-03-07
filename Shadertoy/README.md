# Shadertoy GLSL presets :

### Copy those files into the Shadertoy presets folder. Add the lines from the Shadertoy.txt file into your own Shadertoy.txt.

## Available presets :

- <img src='icons/AFX_DeSpill.frag.png' width='40'> **[AFX_DeSpill]** : Based on the Despill algo if green is greater than the average of the red and blue channels, then bring green down to that color... also works with blue and redscreen, this algo is excellent for maintaining skintones...

- <img src='icons/AFX_Grade.frag.png' width='40'> **[AFX_Grade]** : This is based off the Nuke grade node, so people who are used to the math of this node will be right at home, this node can create negative values, but that's the point, so you will want to clamp if outputing for broadcast...

- <img src='icons/AFX_ReverseGrade.frag.png' width='40'> **[AFX_ReverseGrade]** : This node is the reverse grade function found inside the Nuke Grade node. Set your black and white points from your source material (look at front view), then look at the target footage (either via the back or just a context view) and pull the blacks and whites off that plate, then look at result view and tada! they should be a pretty close match...