# Crok_heathaze_GL

Creates a heat haze effect.

### INPUTS
    Source : source clip
    Mask : masken input
    Displace map : external Displacement matte
    Strength map : external Strength matte

### SETUP
    Amount: strength of the distortion
    Smoothness: blur the incomming distortion matte (works on internal and external matte)

    Amount: strengt of applied hmotion blur
    Samples: motion blur samples

    Speed: speed of noise
    Detail: detail of the noise structure
    Direction: noise animation direction

    Use External Matte: use an external matte instead of the internal matte for the displacement
   
    Oversampling: number of pixel samples
    Softness: spacing between pixel samples

### STEP-BY-STEP
    Connect the Source and Mask inputs.
    Connect the Strength map input.
    Connect the Displace map input.

### DEMO CLIP
	https://vimeo.com/115514251   
