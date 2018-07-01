# -*- coding: utf-8 -*-
# DO NOT EDIT THIS FILE
# This file was automatically generated by Natron PyPlug exporter version 10.

# Hand-written code should be added in a separate file named Crok_fast_grain_GLExt.py
# See http://natron.readthedocs.org/en/master/devel/groups.html#adding-hand-written-code-callbacks-etc
# Note that Viewers are never exported

import NatronEngine
import sys

# Try to import the extensions file where callbacks and hand-written code should be located.
try:
    from Crok_fast_grain_GLExt import *
except ImportError:
    pass

def getPluginID():
    return "natron.community.plugins.Crok_fast_grain_GL"

def getLabel():
    return "Crok_fast_grain_GL"

def getVersion():
    return 1.0

def getIconPath():
    return "Crok_fast_grain_GL.png"

def getGrouping():
    return "Community/GLSL/Draw"

def getPluginDescription():
    return "Simulates a film like grain."
    
def createInstance(app,group):
    # Create all nodes in the group

    # Create the parameters of the group node the same way we did for all internal nodes
    lastNode = group
    lastNode.setColor(0.1176, 0.5882, 0.1176)

    # Create the user parameters
    lastNode.Controls = lastNode.createPageParam("Controls", "Controls")
    param = lastNode.createStringParam("sep01", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep01 = param
    del param

    param = lastNode.createStringParam("sep02", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep02 = param
    del param

    param = lastNode.createSeparatorParam("GRAIN", "Grain")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.GRAIN = param
    del param

    param = lastNode.createStringParam("sep03", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep03 = param
    del param

    param = lastNode.createStringParam("sep04", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep04 = param
    del param

    param = lastNode.createDoubleParam("Shadertoy1_2paramValueFloat0", "Grain size : ")
    param.setMinimum(0, 0)
    param.setDisplayMinimum(0, 0)
    param.setDisplayMaximum(10, 0)
    param.setDefaultValue(1.4, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shadertoy1_2paramValueFloat0 = param
    del param

    param = lastNode.createStringParam("sep05", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep05 = param
    del param

    param = lastNode.createDoubleParam("Shadertoy1_2paramValueFloat1", "Grain amount : ")
    param.setMinimum(0, 0)
    param.setDisplayMinimum(0, 0)
    param.setDisplayMaximum(10, 0)
    param.setDefaultValue(2, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shadertoy1_2paramValueFloat1 = param
    del param

    param = lastNode.createStringParam("sep06", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep06 = param
    del param

    param = lastNode.createStringParam("sep07", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep07 = param
    del param

    param = lastNode.createSeparatorParam("COLOR", "Color")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.COLOR = param
    del param

    param = lastNode.createStringParam("sep08", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep08 = param
    del param

    param = lastNode.createStringParam("sep09", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep09 = param
    del param

    param = lastNode.createBooleanParam("Shadertoy1_2paramValueBool2", "Colored noise : ")
    param.setDefaultValue(True)
    param.restoreDefaultValue()

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shadertoy1_2paramValueBool2 = param
    del param

    param = lastNode.createStringParam("sep10", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep10 = param
    del param

    param = lastNode.createDoubleParam("Shadertoy1_2paramValueFloat3", "Color amount : ")
    param.setMinimum(0, 0)
    param.setDisplayMinimum(0, 0)
    param.setDisplayMaximum(10, 0)
    param.setDefaultValue(0.6, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shadertoy1_2paramValueFloat3 = param
    del param

    param = lastNode.createStringParam("sep11", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep11 = param
    del param

    param = lastNode.createDoubleParam("Shadertoy1_2paramValueFloat4", "Luminance amount : ")
    param.setMinimum(0, 0)
    param.setDisplayMinimum(0, 0)
    param.setDisplayMaximum(10, 0)
    param.setDefaultValue(1, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shadertoy1_2paramValueFloat4 = param
    del param

    param = lastNode.createStringParam("sep12", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep12 = param
    del param

    param = lastNode.createStringParam("sep13", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep13 = param
    del param

    lastNode.Credits = lastNode.createPageParam("Credits", "Credits")
    param = lastNode.createStringParam("sep101", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep101 = param
    del param

    param = lastNode.createStringParam("sep102", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep102 = param
    del param

    param = lastNode.createSeparatorParam("NAME", "Crok_fast_grain_GL v1.0")

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.NAME = param
    del param

    param = lastNode.createStringParam("sep103", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep103 = param
    del param

    param = lastNode.createStringParam("sep104", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep104 = param
    del param

    param = lastNode.createSeparatorParam("LINE01", "")

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.LINE01 = param
    del param

    param = lastNode.createStringParam("sep105", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep105 = param
    del param

    param = lastNode.createStringParam("sep106", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep106 = param
    del param

    param = lastNode.createSeparatorParam("FR", "ShaderToy 0.8.8")

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.FR = param
    del param

    param = lastNode.createStringParam("sep107", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep107 = param
    del param

    param = lastNode.createStringParam("sep108", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep108 = param
    del param

    param = lastNode.createSeparatorParam("CONVERSION", " (Fabrice Fernandez - 2018)")

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.CONVERSION = param
    del param

    param = lastNode.createStringParam("sep109", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep109 = param
    del param

    param = lastNode.createStringParam("sep110", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Credits.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep110 = param
    del param

    # Refresh the GUI with the newly created parameters
    lastNode.setPagesOrder(['Controls', 'Credits', 'Node', 'Settings'])
    lastNode.refreshUserParamsGUI()
    del lastNode

    # Start of node "Output2"
    lastNode = app.createNode("fr.inria.built-in.Output", 1, group)
    lastNode.setLabel("Output2")
    lastNode.setPosition(4139, 3997)
    lastNode.setSize(80, 43)
    lastNode.setColor(0.7, 0.7, 0.7)
    groupOutput2 = lastNode

    del lastNode
    # End of node "Output2"

    # Start of node "Source"
    lastNode = app.createNode("fr.inria.built-in.Input", 1, group)
    lastNode.setScriptName("Source")
    lastNode.setLabel("Source")
    lastNode.setPosition(4139, 3697)
    lastNode.setSize(80, 43)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupSource = lastNode

    del lastNode
    # End of node "Source"

    # Start of node "Shadertoy1_2"
    lastNode = app.createNode("net.sf.openfx.Shadertoy", 1, group)
    lastNode.setScriptName("Shadertoy1_2")
    lastNode.setLabel("Shadertoy1_2")
    lastNode.setPosition(4139, 3840)
    lastNode.setSize(80, 48)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupShadertoy1_2 = lastNode

    param = lastNode.getParam("paramValueFloat0")
    if param is not None:
        param.setValue(1.4, 0)
        del param

    param = lastNode.getParam("paramValueFloat1")
    if param is not None:
        param.setValue(2, 0)
        del param

    param = lastNode.getParam("paramValueBool2")
    if param is not None:
        param.setValue(True)
        del param

    param = lastNode.getParam("paramValueFloat3")
    if param is not None:
        param.setValue(0.6, 0)
        del param

    param = lastNode.getParam("paramValueFloat4")
    if param is not None:
        param.setValue(1, 0)
        del param

    param = lastNode.getParam("imageShaderSource")
    if param is not None:
        param.setValue("//\n//\n//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM\n//                        MM.                          .MM\n//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                     MM.  .MMMM        MMMMMMM    MMM.  .MM\n//                    MM.  .MMM           MMMMMM     MMM.  .MM\n//                   MM.  .MmM              MMMM      MMM.  .MM\n//                  MM.  .MMM                 MM       MMM.  .MM\n//                 MM.  .MMM                   M        MMM.  .MM\n//                MM.  .MMM                              MMM.  .MM\n//                 MM.  .MMM                            MMM.  .MM\n//                  MM.  .MMM       M                  MMM.  .MM\n//                   MM.  .MMM      MM                MMM.  .MM\n//                    MM.  .MMM     MMM              MMM.  .MM\n//                     MM.  .MMM    MMMM            MMM.  .MM\n//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                        MM.                          .MM\n//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM\n//\n//\n//\n//\n// Adaptation pour Natron par F. Fernandez\n// Code original : crok_fast_grain Matchbox pour Autodesk Flame\n\n// Adapted to Natron by F.Fernandez\n// Original code : crok_fast_grain Matchbox for Autodesk Flame\n\n\n// iChannel0: Source, filter=nearest, wrap=clamp\n// BBox: iChannel0\n\n/*\nFilm Grain post-process shader v1.1\t\nMartins Upitis (martinsh) devlog-martinsh.blogspot.com\n2013\n\n--------------------------\nThis work is licensed under a Creative Commons Attribution 3.0 Unported License.\nSo you are free to share, modify and adapt it for your needs, and even use it for commercial use.\nI would also love to hear about a project you are using it.\n\nHave fun,\nMartins\n--------------------------\n\nPerlin noise shader by toneburst:\nhttp://machinesdontcare.wordpress.com/2009/06/25/3d-perlin-noise-sphere-vertex-shader-sourcecode/\n*/\n\n\nuniform float grain_size = 1.4; // Grain size : \nuniform float grainamount = 2.0; // Grain amount : \nuniform bool colored = true; // Colored noise : \nuniform float coloramount = 0.6; // Color amount : \nuniform float lumamount = 1.0; // Luminance amount : \nuniform float scratch_opacity = 1.0; // Scratch opacity : \nuniform float dust_opacity = 1.0; // Dust opacity : \nuniform float flicker_opacity = 1.0; // Flicker opacity : \n\n\nfloat timer = iTime*.05;\n\nconst float permTexUnit = 1.0/256.0;\t\t// Perm texture texel-size\nconst float permTexUnitHalf = 0.5/256.0;\t// Half perm texture texel-size\n\nfloat width = iResolution.x;\nfloat height = iResolution.y;\n\nfloat grainsize = grain_size * 1.5;\n    \n//a random texture generator, but you can also use a pre-computed perturbation texture\nvec4 rnm(in vec2 tc) \n{\n    float noise =  sin(dot(tc + vec2(timer,timer),vec2(12.9898,78.233))) * 43758.5453;\n\n\tfloat noiseR =  fract(noise)*2.0-1.0;\n\tfloat noiseG =  fract(noise*1.2154)*2.0-1.0; \n\tfloat noiseB =  fract(noise*1.3453)*2.0-1.0;\n\tfloat noiseA =  fract(noise*1.3647)*2.0-1.0;\n\t\n\treturn vec4(noiseR,noiseG,noiseB,noiseA);\n}\n\n\nfloat rand(vec2 co)\n{\n    float a = 12.9898;\n    float b = 78.233;\n    float c = 43758.5453;\n    float dt= dot(co.xy ,vec2(a,b));\n    float sn= mod(dt,3.14);\n    return fract(sin(sn) * c);\n}\n\n//good for large clumps of smooth looking noise, but too repetitive\n//for small grains\nfloat fastNoise(vec2 n) {\n\tconst vec2 d = vec2(0.0, 1.0);\n\tvec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));\n\treturn mix(mix(rand(b), rand(b + d.yx ), f.x), mix(rand(b + d.xy ), rand(b + d.yy ), f.x), f.y);\n}\n\nfloat fade(in float t) {\n\treturn t*t*t*(t*(t*6.0-15.0)+10.0);\n}\n\nfloat pnoise3D(in vec3 p)\n{\n\tvec3 pi = permTexUnit*floor(p)+permTexUnitHalf; // Integer part, scaled so +1 moves permTexUnit texel\n\t// and offset 1/2 texel to sample texel centers\n\tvec3 pf = fract(p);     // Fractional part for interpolation\n\n\t// Noise contributions from (x=0, y=0), z=0 and z=1\n\tfloat perm00 = rnm(pi.xy).a ;\n\tvec3  grad000 = rnm(vec2(perm00, pi.z)).rgb * 4.0 - 1.0;\n\tfloat n000 = dot(grad000, pf);\n\tvec3  grad001 = rnm(vec2(perm00, pi.z + permTexUnit)).rgb * 4.0 - 1.0;\n\tfloat n001 = dot(grad001, pf - vec3(0.0, 0.0, 1.0));\n\n\t// Noise contributions from (x=0, y=1), z=0 and z=1\n\tfloat perm01 = rnm(pi.xy + vec2(0.0, permTexUnit)).a ;\n\tvec3  grad010 = rnm(vec2(perm01, pi.z)).rgb * 4.0 - 1.0;\n\tfloat n010 = dot(grad010, pf - vec3(0.0, 1.0, 0.0));\n\tvec3  grad011 = rnm(vec2(perm01, pi.z + permTexUnit)).rgb * 4.0 - 1.0;\n\tfloat n011 = dot(grad011, pf - vec3(0.0, 1.0, 1.0));\n\n\t// Noise contributions from (x=1, y=0), z=0 and z=1\n\tfloat perm10 = rnm(pi.xy + vec2(permTexUnit, 0.0)).a ;\n\tvec3  grad100 = rnm(vec2(perm10, pi.z)).rgb * 4.0 - 1.0;\n\tfloat n100 = dot(grad100, pf - vec3(1.0, 0.0, 0.0));\n\tvec3  grad101 = rnm(vec2(perm10, pi.z + permTexUnit)).rgb * 4.0 - 1.0;\n\tfloat n101 = dot(grad101, pf - vec3(1.0, 0.0, 1.0));\n\n\t// Noise contributions from (x=1, y=1), z=0 and z=1\n\tfloat perm11 = rnm(pi.xy + vec2(permTexUnit, permTexUnit)).a ;\n\tvec3  grad110 = rnm(vec2(perm11, pi.z)).rgb * 4.0 - 1.0;\n\tfloat n110 = dot(grad110, pf - vec3(1.0, 1.0, 0.0));\n\tvec3  grad111 = rnm(vec2(perm11, pi.z + permTexUnit)).rgb * 4.0 - 1.0;\n\tfloat n111 = dot(grad111, pf - vec3(1.0, 1.0, 1.0));\n\n\t// Blend contributions along x\n\tvec4 n_x = mix(vec4(n000, n001, n010, n011), vec4(n100, n101, n110, n111), fade(pf.x));\n\n\t// Blend contributions along y\n\tvec2 n_xy = mix(n_x.xy, n_x.zw, fade(pf.y));\n\n\t// Blend contributions along z\n\tfloat n_xyz = mix(n_xy.x, n_xy.y, fade(pf.z));\n\n\t// We\'re done, return the final noise value.\n\treturn n_xyz;\n}\n\n//2d coordinate orientation thing\nvec2 coordRot(in vec2 tc, in float angle)\n{\n\tfloat aspect = width/height;\n\tfloat rotX = ((tc.x*2.0-1.0)*aspect*cos(angle)) - ((tc.y*2.0-1.0)*sin(angle));\n\tfloat rotY = ((tc.y*2.0-1.0)*cos(angle)) + ((tc.x*2.0-1.0)*aspect*sin(angle));\n\trotX = ((rotX/aspect)*0.5+0.5);\n\trotY = rotY*0.5+0.5;\n\treturn vec2(rotX,rotY);\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )  \n{\n\tvec2 texCoord = fragCoord.xy / iResolution.xy;\n\t\n\tvec3 rotOffset = vec3(1.425,3.892,5.835); //rotation offset values\t\n\tvec2 rotCoordsR = coordRot(texCoord, timer + rotOffset.x);\n\tvec3 noise = vec3(pnoise3D(vec3(rotCoordsR*vec2(width/grainsize,height/grainsize),0.0)));\n  \n\tif (colored)\n\t{\n\t\tvec2 rotCoordsG = coordRot(texCoord, timer + rotOffset.y);\n\t\tvec2 rotCoordsB = coordRot(texCoord, timer + rotOffset.z);\n\t\tnoise.g = mix(noise.r,pnoise3D(vec3(rotCoordsG*vec2(width/grainsize,height/grainsize),1.0)),coloramount);\n\t\tnoise.b = mix(noise.r,pnoise3D(vec3(rotCoordsB*vec2(width/grainsize,height/grainsize),2.0)),coloramount);\n\t}\n\n\tvec3 col = texture2D(iChannel0, texCoord).rgb;\n\n\t//noisiness response curve based on scene luminance\n\tvec3 lumcoeff = vec3(0.299,0.587,0.114);\n\tfloat luminance = mix(0.0,dot(col, lumcoeff),lumamount * .5);\n\tfloat lum = smoothstep(0.2,0.0,luminance);\n\tlum += luminance;\n\t\n\tnoise = mix(noise,vec3(0.0),pow(lum,4.0));\n\tcol = col+noise* 0.025 * grainamount;\n   \n\tfragColor =  vec4(col,1.0);\n}")
        del param

    param = lastNode.getParam("mipmap0")
    if param is not None:
        param.set("nearest")
        del param

    param = lastNode.getParam("wrap0")
    if param is not None:
        param.set("clamp")
        del param

    param = lastNode.getParam("inputLabel0")
    if param is not None:
        param.setValue("Source")
        del param

    param = lastNode.getParam("inputEnable1")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("inputEnable2")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("inputEnable3")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("bbox")
    if param is not None:
        param.set("iChannel0")
        del param

    param = lastNode.getParam("NatronParamFormatChoice")
    if param is not None:
        param.set("PC_Video")
        del param

    param = lastNode.getParam("mouseParams")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("paramCount")
    if param is not None:
        param.setValue(5, 0)
        del param

    param = lastNode.getParam("paramType0")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName0")
    if param is not None:
        param.setValue("grain_size")
        del param

    param = lastNode.getParam("paramLabel0")
    if param is not None:
        param.setValue("Grain size :")
        del param

    param = lastNode.getParam("paramDefaultFloat0")
    if param is not None:
        param.setValue(1.4, 0)
        del param

    param = lastNode.getParam("paramType1")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName1")
    if param is not None:
        param.setValue("grainamount")
        del param

    param = lastNode.getParam("paramLabel1")
    if param is not None:
        param.setValue("Grain amount :")
        del param

    param = lastNode.getParam("paramDefaultFloat1")
    if param is not None:
        param.setValue(2, 0)
        del param

    param = lastNode.getParam("paramType2")
    if param is not None:
        param.set("bool")
        del param

    param = lastNode.getParam("paramName2")
    if param is not None:
        param.setValue("colored")
        del param

    param = lastNode.getParam("paramLabel2")
    if param is not None:
        param.setValue("Colored noise :")
        del param

    param = lastNode.getParam("paramDefaultBool2")
    if param is not None:
        param.setValue(True)
        del param

    param = lastNode.getParam("paramType3")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName3")
    if param is not None:
        param.setValue("coloramount")
        del param

    param = lastNode.getParam("paramLabel3")
    if param is not None:
        param.setValue("Color amount :")
        del param

    param = lastNode.getParam("paramDefaultFloat3")
    if param is not None:
        param.setValue(0.6, 0)
        del param

    param = lastNode.getParam("paramType4")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName4")
    if param is not None:
        param.setValue("lumamount")
        del param

    param = lastNode.getParam("paramLabel4")
    if param is not None:
        param.setValue("Luminance amount :")
        del param

    param = lastNode.getParam("paramDefaultFloat4")
    if param is not None:
        param.setValue(1, 0)
        del param

    del lastNode
    # End of node "Shadertoy1_2"

    # Now that all nodes are created we can connect them together, restore expressions
    groupOutput2.connectInput(0, groupShadertoy1_2)
    groupShadertoy1_2.connectInput(0, groupSource)

    param = groupShadertoy1_2.getParam("paramValueFloat0")
    group.getParam("Shadertoy1_2paramValueFloat0").setAsAlias(param)
    del param
    param = groupShadertoy1_2.getParam("paramValueFloat1")
    group.getParam("Shadertoy1_2paramValueFloat1").setAsAlias(param)
    del param
    param = groupShadertoy1_2.getParam("paramValueBool2")
    group.getParam("Shadertoy1_2paramValueBool2").setAsAlias(param)
    del param
    param = groupShadertoy1_2.getParam("paramValueFloat3")
    group.getParam("Shadertoy1_2paramValueFloat3").setAsAlias(param)
    del param
    param = groupShadertoy1_2.getParam("paramValueFloat4")
    group.getParam("Shadertoy1_2paramValueFloat4").setAsAlias(param)
    del param

    try:
        extModule = sys.modules["Crok_fast_grain_GLExt"]
    except KeyError:
        extModule = None
    if extModule is not None and hasattr(extModule ,"createInstanceExt") and hasattr(extModule.createInstanceExt,"__call__"):
        extModule.createInstanceExt(app,group)
