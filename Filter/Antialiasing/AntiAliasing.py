# -*- coding: utf-8 -*-
# DO NOT EDIT THIS FILE
# This file was automatically generated by Natron PyPlug exporter version 10.

# Hand-written code should be added in a separate file named AntiAliasingExt.py
# See http://natron.readthedocs.org/en/master/groups.html#adding-hand-written-code-callbacks-etc
# Note that Viewers are never exported

import NatronEngine
import sys

# Try to import the extensions file where callbacks and hand-written code should be located.
try:
    from AntiAliasingExt import *
except ImportError:
    pass

def getPluginID():
    return "AntiAliasing"

def getLabel():
    return "AntiAliasing"

def getVersion():
    return 1

def getIconPath():
    return "AntiAliasing.png"

def getGrouping():
    return "Filter"

def getPluginDescription():
    return "Smooth the edges of pixaleted images by applying an Fast Approximate Anti-Aliasing filtering. \n\nAlternatively this Pyplug can also apply another way of filtering by scaling ,bluring and downscaling the image.\nBooth methods can be combined , but the second one is much slower.\n\nFXAA implementation is based on this code : \nhttps://github.com/mattdesl/glsl-fxaa\nThe MIT License (MIT) Copyright (c) 2014 Matt DesLauriers \n"

def createInstance(app,group):
    # Create all nodes in the group

    # Create the parameters of the group node the same way we did for all internal nodes
    lastNode = group

    # Create the user parameters
    lastNode.Controls = lastNode.createPageParam("Controls", "Controls")
    param = lastNode.createBooleanParam("RGB", "Process RGB")
    param.setDefaultValue(True)
    param.restoreDefaultValue()

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("Apply the Antialiasing to the R G B channels")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.RGB = param
    del param

    param = lastNode.createBooleanParam("A", "Process Alpha")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("Apply the AntiAliasing to the Alpha channel")
    param.setAddNewLine(False)
    param.setAnimationEnabled(True)
    param.setValue(True)
    lastNode.A = param
    del param

    param = lastNode.createBooleanParam("blurfilter", "Blur Filter")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("Apply a second AntiAliasing filter by scaling the image , bluring and downscaling to the original scale , might help to give an extra smoothing at the cost of much more calculations")
    param.setAddNewLine(False)
    param.setAnimationEnabled(True)
    lastNode.blurfilter = param
    del param

    param = lastNode.createSeparatorParam("sep", "")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.sep = param
    del param

    param = lastNode.createIntParam("scale", "Sampling for Blur Filter")
    param.setMinimum(0, 0)
    param.setMaximum(100, 0)
    param.setDisplayMinimum(1, 0)
    param.setDisplayMaximum(5, 0)
    param.setDefaultValue(2, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("Sampling factor for the Blur Filter parameter.\nSampling = 4 : \n\tscale 4 time the image\n\tapply a Blur filter of 4\n\tdownscale")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.scale = param
    del param

    param = lastNode.createBooleanParam("Merge1enableMask_Mask", "Mask")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setAnimationEnabled(False)
    lastNode.Merge1enableMask_Mask = param
    del param

    param = lastNode.createChoiceParam("Merge1maskChannel_Mask", "")
    param.setDefaultValue(4)
    param.restoreDefaultValue()

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(False)
    param.setAnimationEnabled(False)
    lastNode.Merge1maskChannel_Mask = param
    del param

    param = lastNode.createBooleanParam("Merge1maskInvert", "Invert Mask")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(False)
    param.setAnimationEnabled(False)
    lastNode.Merge1maskInvert = param
    del param

    param = lastNode.createDoubleParam("Merge1mix", "Mix")
    param.setMinimum(0, 0)
    param.setMaximum(1, 0)
    param.setDisplayMinimum(0, 0)
    param.setDisplayMaximum(1, 0)
    param.setDefaultValue(1, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Merge1mix = param
    del param

    lastNode.FXAA_Extra = lastNode.createPageParam("FXAA_Extra", "FXAA_Extra")
    param = lastNode.createDoubleParam("FXAA_RGBparamValueFloat0", "FXAA Span Max")
    param.setDisplayMinimum(0, 0)
    param.setDisplayMaximum(100, 0)
    param.setDefaultValue(8, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.FXAA_Extra.addParam(param)

    # Set param properties
    param.setHelp("Size of Aliased Span in pixels")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.FXAA_RGBparamValueFloat0 = param
    del param

    param = lastNode.createDoubleParam("FXAA_RGBparamValueFloat1", "MUL")
    param.setDefaultValue(8, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.FXAA_Extra.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.FXAA_RGBparamValueFloat1 = param
    del param

    param = lastNode.createDoubleParam("FXAA_RGBparamValueFloat2", "MIN")
    param.setDefaultValue(128, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.FXAA_Extra.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.FXAA_RGBparamValueFloat2 = param
    del param

    # Refresh the GUI with the newly created parameters
    lastNode.setPagesOrder(['Controls', 'FXAA_Extra', 'Node'])
    lastNode.refreshUserParamsGUI()
    del lastNode

    # Start of node "FXAA_RGB"
    lastNode = app.createNode("net.sf.openfx.Shadertoy", 1, group)
    lastNode.setScriptName("FXAA_RGB")
    lastNode.setLabel("FXAA_RGB")
    lastNode.setPosition(691, -217)
    lastNode.setSize(80, 43)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupFXAA_RGB = lastNode

    param = lastNode.getParam("paramValueFloat0")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramValueFloat1")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramValueFloat2")
    if param is not None:
        param.setValue(128, 0)
        del param

    param = lastNode.getParam("imageShaderSource")
    if param is not None:
        param.setValue("/**\nBasic FXAA implementation based on the code on geeks3d.com with the\nmodification that the texture2DLod stuff was removed since it\'s\nunsupported by WebGL.\n--\nFrom:\nhttps://github.com/mitsuhiko/webgl-meincraft\nCopyright (c) 2011 by Armin Ronacher.\nSome rights reserved.\nRedistribution and use in source and binary forms, with or without\nmodification, are permitted provided that the following conditions are\nmet:\n    * Redistributions of source code must retain the above copyright\n      notice, this list of conditions and the following disclaimer.\n    * Redistributions in binary form must reproduce the above\n      copyright notice, this list of conditions and the following\n      disclaimer in the documentation and/or other materials provided\n      with the distribution.\n    * The names of the contributors may not be used to endorse or\n      promote products derived from this software without specific\n      prior written permission.\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT\nOWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,\nSPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT\nLIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,\nDATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY\nTHEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT\n(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE\nOF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n*/\n\n\nuniform float FXAA_SPAN_MAX\t= 8.0;\nuniform float MUL = 8.0;\nuniform float MIN = 128.0;\n\nvec4 fxaa(sampler2D tex, vec2 fragCoord, vec2 resolution)\n  {\n    float FXAA_REDUCE_MUL = 1.0/MUL ;\n    float FXAA_REDUCE_MIN = 1.0/MIN ;\n    vec4 color ;\n    vec2 inverseVP = 1.0 / resolution.xy;\n    vec2 v_rgbNW = (fragCoord + vec2(-1.0, -1.0)) * inverseVP;\n    vec2 v_rgbNE = (fragCoord + vec2(1.0, -1.0)) * inverseVP;\n    vec2 v_rgbSW = (fragCoord + vec2(-1.0, 1.0)) * inverseVP;\n    vec2 v_rgbSE = (fragCoord + vec2(1.0, 1.0)) * inverseVP;\n    vec2 v_rgbM = vec2(fragCoord * inverseVP);\n\n    vec3 rgbNW = texture2D(tex, v_rgbNW).xyz;\n    vec3 rgbNE = texture2D(tex, v_rgbNE).xyz;\n    vec3 rgbSW = texture2D(tex, v_rgbSW).xyz;\n    vec3 rgbSE = texture2D(tex, v_rgbSE).xyz;\n\n    vec4 texColor = texture2D(tex, v_rgbM);\n    vec3 rgbM  = texColor.xyz;\n    vec3 luma = vec3(0.299, 0.587, 0.114);\n    float lumaNW = dot(rgbNW, luma);\n    float lumaNE = dot(rgbNE, luma);\n    float lumaSW = dot(rgbSW, luma);\n    float lumaSE = dot(rgbSE, luma);\n    float lumaM  = dot(rgbM,  luma);\n    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));\n    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));\n\n    mediump vec2 dir;\n    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));\n    dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));\n\n    float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *\n                          (0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);\n\n    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);\n    dir = min(vec2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),\n              max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),\n              dir * rcpDirMin)) * inverseVP;\n\n    vec3 rgbA = 0.5 * (\n        texture2D(tex, fragCoord * inverseVP + dir * (1.0 / 3.0 - 0.5)).xyz +\n        texture2D(tex, fragCoord * inverseVP + dir * (2.0 / 3.0 - 0.5)).xyz);\n    vec3 rgbB = rgbA * 0.5 + 0.25 * (\n        texture2D(tex, fragCoord * inverseVP + dir * -0.5).xyz +\n        texture2D(tex, fragCoord * inverseVP + dir * 0.5).xyz);\n\n    float lumaB = dot(rgbB, luma);\n    if ((lumaB < lumaMin) || (lumaB > lumaMax))\n        color = vec4(rgbA, texColor.a);\n    else\n        color = vec4(rgbB, texColor.a);\n\n\n    return color ;\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n  fragColor =  fxaa(iChannel0, fragCoord, iResolution.xy) ;\n}\n")
        del param

    param = lastNode.getParam("mipmap0")
    if param is not None:
        param.set("Nearest")
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
        param.set("PC_Video 640x480")
        del param

    param = lastNode.getParam("mouseParams")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("paramCount")
    if param is not None:
        param.setValue(3, 0)
        del param

    param = lastNode.getParam("paramType0")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName0")
    if param is not None:
        param.setValue("FXAA_SPAN_MAX")
        del param

    param = lastNode.getParam("paramLabel0")
    if param is not None:
        param.setValue("FXAA_SPAN_MAX")
        del param

    param = lastNode.getParam("paramDefaultFloat0")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramType1")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName1")
    if param is not None:
        param.setValue("MUL")
        del param

    param = lastNode.getParam("paramLabel1")
    if param is not None:
        param.setValue("MUL")
        del param

    param = lastNode.getParam("paramDefaultFloat1")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramType2")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName2")
    if param is not None:
        param.setValue("MIN")
        del param

    param = lastNode.getParam("paramLabel2")
    if param is not None:
        param.setValue("MIN")
        del param

    param = lastNode.getParam("paramDefaultFloat2")
    if param is not None:
        param.setValue(128, 0)
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(False)
        del param

    del lastNode
    # End of node "FXAA_RGB"

    # Start of node "Input"
    lastNode = app.createNode("fr.inria.built-in.Input", 1, group)
    lastNode.setScriptName("Input")
    lastNode.setLabel("Input")
    lastNode.setPosition(520, -217)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupInput = lastNode

    del lastNode
    # End of node "Input"

    # Start of node "Output1"
    lastNode = app.createNode("fr.inria.built-in.Output", 1, group)
    lastNode.setLabel("Output1")
    lastNode.setPosition(520, 854)
    lastNode.setSize(104, 30)
    lastNode.setColor(0.7, 0.7, 0.7)
    groupOutput1 = lastNode

    del lastNode
    # End of node "Output1"

    # Start of node "FXAA_Alpha"
    lastNode = app.createNode("net.sf.openfx.Shadertoy", 1, group)
    lastNode.setScriptName("FXAA_Alpha")
    lastNode.setLabel("FXAA_Alpha")
    lastNode.setPosition(888, -31)
    lastNode.setSize(80, 43)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupFXAA_Alpha = lastNode

    param = lastNode.getParam("paramValueFloat0")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramValueFloat1")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramValueFloat2")
    if param is not None:
        param.setValue(128, 0)
        del param

    param = lastNode.getParam("imageShaderSource")
    if param is not None:
        param.setValue("/**\nBasic FXAA implementation based on the code on geeks3d.com with the\nmodification that the texture2DLod stuff was removed since it\'s\nunsupported by WebGL.\n--\nFrom:\nhttps://github.com/mitsuhiko/webgl-meincraft\nCopyright (c) 2011 by Armin Ronacher.\nSome rights reserved.\nRedistribution and use in source and binary forms, with or without\nmodification, are permitted provided that the following conditions are\nmet:\n    * Redistributions of source code must retain the above copyright\n      notice, this list of conditions and the following disclaimer.\n    * Redistributions in binary form must reproduce the above\n      copyright notice, this list of conditions and the following\n      disclaimer in the documentation and/or other materials provided\n      with the distribution.\n    * The names of the contributors may not be used to endorse or\n      promote products derived from this software without specific\n      prior written permission.\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS\n\"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT\nLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR\nA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT\nOWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,\nSPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT\nLIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,\nDATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY\nTHEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT\n(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE\nOF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\n*/\n\n\nuniform float FXAA_SPAN_MAX\t= 8.0;\nuniform float MUL = 8.0;\nuniform float MIN = 128.0;\n\nvec4 fxaa(sampler2D tex, vec2 fragCoord, vec2 resolution)\n  {\n    float FXAA_REDUCE_MUL = 1.0/MUL ;\n    float FXAA_REDUCE_MIN = 1.0/MIN ;\n    vec4 color ;\n    vec2 inverseVP = 1.0 / resolution.xy;\n    vec2 v_rgbNW = (fragCoord + vec2(-1.0, -1.0)) * inverseVP;\n    vec2 v_rgbNE = (fragCoord + vec2(1.0, -1.0)) * inverseVP;\n    vec2 v_rgbSW = (fragCoord + vec2(-1.0, 1.0)) * inverseVP;\n    vec2 v_rgbSE = (fragCoord + vec2(1.0, 1.0)) * inverseVP;\n    vec2 v_rgbM = vec2(fragCoord * inverseVP);\n\n    vec3 rgbNW = texture2D(tex, v_rgbNW).xyz;\n    vec3 rgbNE = texture2D(tex, v_rgbNE).xyz;\n    vec3 rgbSW = texture2D(tex, v_rgbSW).xyz;\n    vec3 rgbSE = texture2D(tex, v_rgbSE).xyz;\n\n    vec4 texColor = texture2D(tex, v_rgbM);\n    vec3 rgbM  = texColor.xyz;\n    vec3 luma = vec3(0.299, 0.587, 0.114);\n    float lumaNW = dot(rgbNW, luma);\n    float lumaNE = dot(rgbNE, luma);\n    float lumaSW = dot(rgbSW, luma);\n    float lumaSE = dot(rgbSE, luma);\n    float lumaM  = dot(rgbM,  luma);\n    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));\n    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));\n\n    mediump vec2 dir;\n    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));\n    dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));\n\n    float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *\n                          (0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);\n\n    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);\n    dir = min(vec2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),\n              max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),\n              dir * rcpDirMin)) * inverseVP;\n\n    vec3 rgbA = 0.5 * (\n        texture2D(tex, fragCoord * inverseVP + dir * (1.0 / 3.0 - 0.5)).xyz +\n        texture2D(tex, fragCoord * inverseVP + dir * (2.0 / 3.0 - 0.5)).xyz);\n    vec3 rgbB = rgbA * 0.5 + 0.25 * (\n        texture2D(tex, fragCoord * inverseVP + dir * -0.5).xyz +\n        texture2D(tex, fragCoord * inverseVP + dir * 0.5).xyz);\n\n    float lumaB = dot(rgbB, luma);\n    if ((lumaB < lumaMin) || (lumaB > lumaMax))\n        color = vec4(rgbA, texColor.a);\n    else\n        color = vec4(rgbB, texColor.a);\n\n\n    return color ;\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n  fragColor =  fxaa(iChannel0, fragCoord, iResolution.xy) ;\n}\n")
        del param

    param = lastNode.getParam("mipmap0")
    if param is not None:
        param.set("Nearest")
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
        param.set("PC_Video 640x480")
        del param

    param = lastNode.getParam("mouseParams")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("paramCount")
    if param is not None:
        param.setValue(3, 0)
        del param

    param = lastNode.getParam("paramType0")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName0")
    if param is not None:
        param.setValue("FXAA_SPAN_MAX")
        del param

    param = lastNode.getParam("paramLabel0")
    if param is not None:
        param.setValue("FXAA_SPAN_MAX")
        del param

    param = lastNode.getParam("paramDefaultFloat0")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramType1")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName1")
    if param is not None:
        param.setValue("MUL")
        del param

    param = lastNode.getParam("paramLabel1")
    if param is not None:
        param.setValue("MUL")
        del param

    param = lastNode.getParam("paramDefaultFloat1")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramType2")
    if param is not None:
        param.set("float")
        del param

    param = lastNode.getParam("paramName2")
    if param is not None:
        param.setValue("MIN")
        del param

    param = lastNode.getParam("paramLabel2")
    if param is not None:
        param.setValue("MIN")
        del param

    param = lastNode.getParam("paramDefaultFloat2")
    if param is not None:
        param.setValue(128, 0)
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(False)
        del param

    del lastNode
    # End of node "FXAA_Alpha"

    # Start of node "Dot1"
    lastNode = app.createNode("fr.inria.built-in.Dot", 1, group)
    lastNode.setScriptName("Dot1")
    lastNode.setLabel("Dot1")
    lastNode.setPosition(724, -92)
    lastNode.setSize(15, 15)
    lastNode.setColor(0.7, 0.7, 0.7)
    groupDot1 = lastNode

    del lastNode
    # End of node "Dot1"

    # Start of node "Shuffle1"
    lastNode = app.createNode("net.sf.openfx.ShufflePlugin", 2, group)
    lastNode.setScriptName("Shuffle1")
    lastNode.setLabel("A 2 RGB")
    lastNode.setPosition(878, 62)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.6, 0.24, 0.39)
    groupShuffle1 = lastNode

    param = lastNode.getParam("outputChannelsChoice")
    if param is not None:
        param.setValue("Color.RGBA")
        del param

    param = lastNode.getParam("outputRChoice")
    if param is not None:
        param.setValue("A.r")
        del param

    param = lastNode.getParam("outputGChoice")
    if param is not None:
        param.setValue("A.g")
        del param

    param = lastNode.getParam("outputBChoice")
    if param is not None:
        param.setValue("A.b")
        del param

    param = lastNode.getParam("outputAChoice")
    if param is not None:
        param.setValue("B.r")
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(False)
        del param

    del lastNode
    # End of node "Shuffle1"

    # Start of node "A_2_RGB"
    lastNode = app.createNode("net.sf.openfx.ShufflePlugin", 2, group)
    lastNode.setScriptName("A_2_RGB")
    lastNode.setLabel("A 2 RGB")
    lastNode.setPosition(876, -106)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.6, 0.24, 0.39)
    groupA_2_RGB = lastNode

    param = lastNode.getParam("outputChannelsChoice")
    if param is not None:
        param.setValue("Color.RGBA")
        del param

    param = lastNode.getParam("outputRChoice")
    if param is not None:
        param.setValue("A.a")
        del param

    param = lastNode.getParam("outputGChoice")
    if param is not None:
        param.setValue("A.a")
        del param

    param = lastNode.getParam("outputBChoice")
    if param is not None:
        param.setValue("A.a")
        del param

    param = lastNode.getParam("outputAChoice")
    if param is not None:
        param.setValue("A.a")
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(False)
        del param

    del lastNode
    # End of node "A_2_RGB"

    # Start of node "Dot2"
    lastNode = app.createNode("fr.inria.built-in.Dot", 1, group)
    lastNode.setScriptName("Dot2")
    lastNode.setLabel("Dot2")
    lastNode.setPosition(724, 76)
    lastNode.setSize(15, 15)
    lastNode.setColor(0.7, 0.7, 0.7)
    groupDot2 = lastNode

    del lastNode
    # End of node "Dot2"

    # Start of node "Transform1"
    lastNode = app.createNode("net.sf.openfx.TransformPlugin", 1, group)
    lastNode.setScriptName("Transform1")
    lastNode.setLabel("Transform1")
    lastNode.setPosition(878, 357)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.7, 0.3, 0.1)
    groupTransform1 = lastNode

    param = lastNode.getParam("scale")
    if param is not None:
        param.setValue(2, 0)
        param.setValue(2, 1)
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(True)
        del param

    del lastNode
    # End of node "Transform1"

    # Start of node "Transform2"
    lastNode = app.createNode("net.sf.openfx.TransformPlugin", 1, group)
    lastNode.setScriptName("Transform2")
    lastNode.setLabel("Transform2")
    lastNode.setPosition(878, 516)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.7, 0.3, 0.1)
    groupTransform2 = lastNode

    param = lastNode.getParam("scale")
    if param is not None:
        param.setValue(0.5, 0)
        param.setValue(0.5, 1)
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(True)
        del param

    del lastNode
    # End of node "Transform2"

    # Start of node "Merge1"
    lastNode = app.createNode("net.sf.openfx.MergePlugin", 1, group)
    lastNode.setScriptName("Merge1")
    lastNode.setLabel("Merge1")
    lastNode.setPosition(520, 608)
    lastNode.setSize(104, 56)
    lastNode.setColor(0.3, 0.37, 0.776)
    groupMerge1 = lastNode

    param = lastNode.getParam("NatronOfxParamStringSublabelName")
    if param is not None:
        param.setValue("copy")
        del param

    param = lastNode.getParam("operation")
    if param is not None:
        param.set("copy")
        del param

    param = lastNode.getParam("userTextArea")
    if param is not None:
        param.setValue("<Natron>(copy)</Natron>")
        del param

    del lastNode
    # End of node "Merge1"

    # Start of node "Mask"
    lastNode = app.createNode("fr.inria.built-in.Input", 1, group)
    lastNode.setScriptName("Mask")
    lastNode.setLabel("Mask")
    lastNode.setPosition(1130, 620)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupMask = lastNode

    param = lastNode.getParam("optional")
    if param is not None:
        param.setValue(True)
        del param

    param = lastNode.getParam("isMask")
    if param is not None:
        param.setValue(True)
        del param

    del lastNode
    # End of node "Mask"

    # Start of node "Blur2"
    lastNode = app.createNode("net.sf.cimg.CImgBlur", 4, group)
    lastNode.setScriptName("Blur2")
    lastNode.setLabel("Blur2")
    lastNode.setPosition(878, 429)
    lastNode.setSize(104, 43)
    lastNode.setColor(0.8, 0.5, 0.3)
    groupBlur2 = lastNode

    param = lastNode.getParam("size")
    if param is not None:
        param.setValue(2, 0)
        param.setValue(2, 1)
        del param

    param = lastNode.getParam("expandRoD")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("disableNode")
    if param is not None:
        param.setValue(True)
        del param

    del lastNode
    # End of node "Blur2"

    # Now that all nodes are created we can connect them together, restore expressions
    groupFXAA_RGB.connectInput(0, groupInput)
    groupOutput1.connectInput(0, groupMerge1)
    groupFXAA_Alpha.connectInput(0, groupA_2_RGB)
    groupDot1.connectInput(0, groupFXAA_RGB)
    groupShuffle1.connectInput(0, groupFXAA_Alpha)
    groupShuffle1.connectInput(1, groupDot2)
    groupA_2_RGB.connectInput(1, groupDot1)
    groupDot2.connectInput(0, groupDot1)
    groupTransform1.connectInput(0, groupShuffle1)
    groupTransform2.connectInput(0, groupBlur2)
    groupMerge1.connectInput(0, groupInput)
    groupMerge1.connectInput(1, groupTransform2)
    groupMerge1.connectInput(2, groupMask)
    groupBlur2.connectInput(0, groupTransform1)

    param = groupFXAA_RGB.getParam("paramValueFloat0")
    group.getParam("FXAA_RGBparamValueFloat0").setAsAlias(param)
    del param
    param = groupFXAA_RGB.getParam("paramValueFloat1")
    group.getParam("FXAA_RGBparamValueFloat1").setAsAlias(param)
    del param
    param = groupFXAA_RGB.getParam("paramValueFloat2")
    group.getParam("FXAA_RGBparamValueFloat2").setAsAlias(param)
    del param
    param = groupFXAA_RGB.getParam("disableNode")
    param.setExpression("1-thisGroup.RGB.get()", False, 0)
    del param
    param = groupFXAA_Alpha.getParam("paramValueFloat0")
    param.slaveTo(groupFXAA_RGB.getParam("paramValueFloat0"), 0, 0)
    del param
    param = groupFXAA_Alpha.getParam("paramValueFloat1")
    param.slaveTo(groupFXAA_RGB.getParam("paramValueFloat1"), 0, 0)
    del param
    param = groupFXAA_Alpha.getParam("paramValueFloat2")
    param.slaveTo(groupFXAA_RGB.getParam("paramValueFloat2"), 0, 0)
    del param
    param = groupFXAA_Alpha.getParam("disableNode")
    param.setExpression("1-thisGroup.A.get()", False, 0)
    del param
    param = groupShuffle1.getParam("disableNode")
    param.setExpression("1-thisGroup.A.get()", False, 0)
    del param
    param = groupA_2_RGB.getParam("disableNode")
    param.setExpression("1-thisGroup.A.get()", False, 0)
    del param
    param = groupTransform1.getParam("scale")
    param.setExpression("thisGroup.scale.get()", False, 0)
    param.setExpression("thisGroup.scale.get()", False, 1)
    del param
    param = groupTransform1.getParam("disableNode")
    param.setExpression("1-thisGroup.blurfilter.get()", False, 0)
    del param
    param = groupTransform2.getParam("scale")
    param.setExpression("1.0/thisGroup.scale.get()", False, 0)
    param.setExpression("1.0/thisGroup.scale.get()", False, 1)
    del param
    param = groupTransform2.getParam("disableNode")
    param.setExpression("1-thisGroup.blurfilter.get()", False, 0)
    del param
    param = groupMerge1.getParam("maskInvert")
    group.getParam("Merge1maskInvert").setAsAlias(param)
    del param
    param = groupMerge1.getParam("mix")
    group.getParam("Merge1mix").setAsAlias(param)
    del param
    param = groupMerge1.getParam("enableMask_Mask")
    group.getParam("Merge1enableMask_Mask").setAsAlias(param)
    del param
    param = groupMerge1.getParam("maskChannel_Mask")
    group.getParam("Merge1maskChannel_Mask").setAsAlias(param)
    del param
    param = groupBlur2.getParam("size")
    param.setExpression("thisGroup.scale.get()", False, 0)
    param.setExpression("thisGroup.scale.get()", False, 1)
    del param
    param = groupBlur2.getParam("disableNode")
    param.setExpression("1-thisGroup.blurfilter.get()", False, 0)
    del param

    try:
        extModule = sys.modules["AntiAliasingExt"]
    except KeyError:
        extModule = None
    if extModule is not None and hasattr(extModule ,"createInstanceExt") and hasattr(extModule.createInstanceExt,"__call__"):
        extModule.createInstanceExt(app,group)
