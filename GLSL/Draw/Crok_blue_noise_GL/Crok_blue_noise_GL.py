# -*- coding: utf-8 -*-
# DO NOT EDIT THIS FILE
# This file was automatically generated by Natron PyPlug exporter version 10.

# Hand-written code should be added in a separate file named Crok_blue_noise_GLExt.py
# See http://natron.readthedocs.org/en/master/devel/groups.html#adding-hand-written-code-callbacks-etc
# Note that Viewers are never exported

import NatronEngine
import sys

# Try to import the extensions file where callbacks and hand-written code should be located.
try:
    from Crok_blue_noise_GLExt import *
except ImportError:
    pass

def getPluginID():
    return "Crok_blue_noise_GL"

def getLabel():
    return "Crok_blue_noise_GL"

def getVersion():
    return 1

def getIconPath():
    return "Crok_blue_noise_GL.png"

def getGrouping():
    return "Community/GLSL/Draw"

def getPluginDescription():
    return "Generates a blue noise texture from a still plate."

def createInstance(app,group):
    # Create all nodes in the group

    # Create the parameters of the group node the same way we did for all internal nodes
    lastNode = group
    lastNode.setColor(0.3647, 0.549, 0.2353)

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

    param = lastNode.createBooleanParam("Shader_pass2paramValueBool1", "Animated Noise : ")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("enable animated blue noise")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shader_pass2paramValueBool1 = param
    del param

    param = lastNode.createDoubleParam("Shader_pass2paramValueFloat0", "Speed : ")
    param.setMinimum(0.1, 0)
    param.setMaximum(100, 0)
    param.setDisplayMinimum(0.1, 0)
    param.setDisplayMaximum(100, 0)
    param.setDefaultValue(1, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("speed of animated noise")
    param.setAddNewLine(False)
    param.setAnimationEnabled(True)
    lastNode.Shader_pass2paramValueFloat0 = param
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

    param = lastNode.createSeparatorParam("QUALITY", "Quality")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.QUALITY = param
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

    param = lastNode.createBooleanParam("Shader_pass2paramValueBool3", "Dither in Linear : ")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("enable dithering in linear colour space")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shader_pass2paramValueBool3 = param
    del param

    param = lastNode.createIntParam("Shader_pass2paramValueInt2", "Bit Depth : ")
    param.setMinimum(1, 0)
    param.setMaximum(8, 0)
    param.setDisplayMinimum(1, 0)
    param.setDisplayMaximum(8, 0)
    param.setDefaultValue(3, 0)
    param.restoreDefaultValue(0)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("amount of bit depth reduction")
    param.setAddNewLine(False)
    param.setAnimationEnabled(True)
    lastNode.Shader_pass2paramValueInt2 = param
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

    param = lastNode.createSeparatorParam("OUTPUT", "Output")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setPersistent(False)
    param.setEvaluateOnChange(False)
    lastNode.OUTPUT = param
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

    param = lastNode.createBooleanParam("Shader_pass2paramValueBool4", "Noise Only : ")

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("outputs just the blue noise")
    param.setAddNewLine(True)
    param.setAnimationEnabled(True)
    lastNode.Shader_pass2paramValueBool4 = param
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

    param = lastNode.createStringParam("sep14", "")
    param.setType(NatronEngine.StringParam.TypeEnum.eStringTypeLabel)

    # Add the param to the page
    lastNode.Controls.addParam(param)

    # Set param properties
    param.setHelp("")
    param.setAddNewLine(True)
    param.setEvaluateOnChange(False)
    param.setAnimationEnabled(False)
    lastNode.sep14 = param
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

    param = lastNode.createSeparatorParam("NAME", "Crok_blue_noise_GL v1.0")

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

    # Start of node "Output1"
    lastNode = app.createNode("fr.inria.built-in.Output", 1, group)
    lastNode.setLabel("Output2")
    lastNode.setPosition(4343, 3931)
    lastNode.setSize(80, 44)
    lastNode.setColor(0.7, 0.7, 0.7)
    groupOutput1 = lastNode

    del lastNode
    # End of node "Output1"

    # Start of node "Shader_pass1"
    lastNode = app.createNode("net.sf.openfx.Shadertoy", 1, group)
    lastNode.setScriptName("Shader_pass1")
    lastNode.setLabel("Shader_pass1")
    lastNode.setPosition(4343, 3600)
    lastNode.setSize(80, 34)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupShader_pass1 = lastNode

    param = lastNode.getParam("imageShaderSource")
    if param is not None:
        param.setValue("//\n//\n//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM\n//                        MM.                          .MM\n//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                     MM.  .MMMM        MMMMMMM    MMM.  .MM\n//                    MM.  .MMM           MMMMMM     MMM.  .MM\n//                   MM.  .MmM              MMMM      MMM.  .MM\n//                  MM.  .MMM                 MM       MMM.  .MM\n//                 MM.  .MMM                   M        MMM.  .MM\n//                MM.  .MMM                              MMM.  .MM\n//                 MM.  .MMM                            MMM.  .MM\n//                  MM.  .MMM       M                  MMM.  .MM\n//                   MM.  .MMM      MM                MMM.  .MM\n//                    MM.  .MMM     MMM              MMM.  .MM\n//                     MM.  .MMM    MMMM            MMM.  .MM\n//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                        MM.                          .MM\n//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM\n//\n//\n//\n//\n// Adaptation pour Natron par F. Fernandez\n// Code original : crok_blue_noise Matchbox pour Autodesk Flame\n\n// Adapted to Natron by F.Fernandez\n// Original code : crok_blue_noise Matchbox for Autodesk Flame\n\n\n// iChannel0: Texture,filter=linear,wrap=repeat\n// BBox: iChannel0\n\n\n//*****************************************************************************/\n//\n// Filename: GridFetchingComp.1.glsl\n//\n// Copyright (c) 2015 Autodesk, Inc.\n// All rights reserved.\n//\n// This computer source code and related instructions and comments are the\n// unpublished confidential and proprietary information of Autodesk, Inc.\n// and are protected under applicable copyright and trade secret law.\n// They may not be disclosed to, copied or used by any third party without\n// the prior written consent of Autodesk, Inc.\n//*****************************************************************************/\n\n#define HALF_PIXEL 0.5\n\n\nuniform int textureSelector;\n\n\n// These 2 lines define the texture grid resolution and tile resolution\nvec2  tileSize = vec2(1024.0, 1024.0);\nconst vec2     gridSize = vec2(1024.0, 1024.0);\n\n//------------------------------------------------------------------------------\n// Function that get the position in the grid of the bottom left pixel of a tile.\n//\n// - gridSize : size of the grid in pixels\n//\n// - tileSize : size of the tiles in pixels\n//\n// - tileNum : index of the tile to be fetched (0 is the bottom-left)\n//             example of tile index layout  : 6 - 7 - 8\n//                                             3 - 4 - 5\n//                                             0 - 1 - 2\n//------------------------------------------------------------------------------\nvec2 getTilePosition( vec2 gridSize,\n                      vec2 tileSize,\n                      int tileNum )\n{\n   // compute the actual number of tiles per grid row and column\n   ivec2 nbTiles = ivec2(gridSize)/ivec2(tileSize);\n\n   // compute the tile position in the grid from its index\n   vec2 tile = vec2(mod(float(tileNum), float(nbTiles.x)),float(tileNum/nbTiles.x));\n\n   return tile*tileSize;\n}\n\n//------------------------------------------------------------------------------\n// Function that fetch a pixel of a tile within the grid texture\n//\n// - gridSize : size of the grid in pixels\n//\n// - tileSize : size of the tiles in pixels\n//\n// - tilePosition : the position in pixel of the bottom-left corner of the tile\n//                  (as returned by getTilePosition)\n//\n// - positionInTile : the position in pixel of the tile pixel to be fetched\n//                    (0,0) is the bottom-left corner of the tile\n//                    (tileSize.x,tileSize.y) is the upper-rigth corner of the tile\n//\n//------------------------------------------------------------------------------\nvec4 fetchInTile( vec2 gridSize,\n                  vec2 tileSize,\n                  vec2 tilePosition,\n                  vec2 positionInTile )\n{\n\n   // compute the normalized coords of tile pixel to be\n   // fetched within the grid\n   vec2 positionInGrid = (tilePosition+positionInTile)/gridSize;\n\n   return texture2D( iChannel0, positionInGrid );\n}\n\n\n//------------------------------------------------------------------------------\n// MAIN\n//------------------------------------------------------------------------------\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n   // fetch the transform position\n   vec4 tileResult = fetchInTile(gridSize, tileSize,\n      getTilePosition(gridSize,tileSize,textureSelector), fragCoord.xy);\n\n   fragColor = tileResult;\n}\n")
        del param

    param = lastNode.getParam("mipmap0")
    if param is not None:
        param.set("linear")
        del param

    param = lastNode.getParam("inputLabel0")
    if param is not None:
        param.setValue("Texture")
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
        param.setValue(1, 0)
        del param

    param = lastNode.getParam("paramType0")
    if param is not None:
        param.set("int")
        del param

    param = lastNode.getParam("paramName0")
    if param is not None:
        param.setValue("textureSelector")
        del param

    param = lastNode.getParam("paramLabel0")
    if param is not None:
        param.setValue("textureSelector")
        del param

    del lastNode
    # End of node "Shader_pass1"

    # Start of node "Shader_pass2"
    lastNode = app.createNode("net.sf.openfx.Shadertoy", 1, group)
    lastNode.setScriptName("Shader_pass2")
    lastNode.setLabel("Shader_pass2")
    lastNode.setPosition(4343, 3726)
    lastNode.setSize(80, 34)
    lastNode.setColor(0.3, 0.5, 0.2)
    groupShader_pass2 = lastNode

    param = lastNode.getParam("paramValueFloat0")
    if param is not None:
        param.setValue(1, 0)
        del param

    param = lastNode.getParam("paramValueBool1")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("paramValueInt2")
    if param is not None:
        param.setValue(3, 0)
        del param

    param = lastNode.getParam("paramValueBool3")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("paramValueBool4")
    if param is not None:
        param.setValue(False)
        del param

    param = lastNode.getParam("imageShaderSource")
    if param is not None:
        param.setValue("//\n//\n//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM\n//                        MM.                          .MM\n//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                     MM.  .MMMM        MMMMMMM    MMM.  .MM\n//                    MM.  .MMM           MMMMMM     MMM.  .MM\n//                   MM.  .MmM              MMMM      MMM.  .MM\n//                  MM.  .MMM                 MM       MMM.  .MM\n//                 MM.  .MMM                   M        MMM.  .MM\n//                MM.  .MMM                              MMM.  .MM\n//                 MM.  .MMM                            MMM.  .MM\n//                  MM.  .MMM       M                  MMM.  .MM\n//                   MM.  .MMM      MM                MMM.  .MM\n//                    MM.  .MMM     MMM              MMM.  .MM\n//                     MM.  .MMM    MMMM            MMM.  .MM\n//                      MM.  .MMMMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                       MM.  .MMMMMMMMMMMMMMMMMMMMMM.  .MM\n//                        MM.                          .MM\n//                          MMMMMMMMMMMMMMMMMMMMMMMMMMMM\n//\n//\n//\n//\n// Adaptation pour Natron par F. Fernandez\n// Code original : crok_blue_noise Matchbox pour Autodesk Flame\n\n// Adapted to Natron by F.Fernandez\n// Original code : crok_blue_noise Matchbox for Autodesk Flame\n\n\n// iChannel0: Source, filter=nearest, wrap=repeat\n// iChannel1: pass1_result,filter=linear,wrap=clamp\n// BBox: iChannel0\n\n\n// based on www.shadertoy.com/view/4sKBWR by demofox\n/*\nThis shadertoy was adapted from paniq\'s at https://www.shadertoy.com/view/MsGfDz\nHe is on twitter at: https://twitter.com/paniq\nPaniq is truly a king among men.\n\nHe totally didn\'t demand i put that here when i credited him, I promise (;\n\nItems of note!\n\n* The blue noise texture sampling should be set to \"nearest\" (not mip map!) and repeat\n\n* you should calculate the uv to use based on the pixel coordinate and the size of the blue noise texture.\n * aka you should tile the blue noise texture across the screen.\n * blue noise actually tiles really well unlike white noise.\n\n* A blue noise texture is \"low discrepancy over space\" which means there are fewer visible patterns than white noise\n * it also gives more even coverage vs white noise. no clumps or voids.\n\n* In an attempt to make it also blue noise over time, you can add the golden ratio and frac it.\n * that makes it lower discrepancy over time, but makes it less good over space.\n * thanks to r4unit for that tip! https://twitter.com/R4_Unit\n\n* Animating the noise in this demo makes the noise basically disappear imo, it\'s really nice!\n\nFor more information:\n\nWhat the heck is blue nois:\nhttps://blog.demofox.org/2018/01/30/what-the-heck-is-blue-noise/\n\nLow discrepancy sequences:\nhttps://blog.demofox.org/2017/05/29/when-random-numbers-are-too-random-low-discrepancy-sequences/\n\nYou can get your own blue noise textures here:\nhttp://momentsingraphics.de/?p=127\n*/\n\nvec2 res = vec2(iResolution.x, iResolution.y);\nuniform float time = 1.0; // Speed : (speed), min=0.1, max=100\n\nfloat MyTime = iTime *.05 * time;\nconst float c_goldenRatioConjugate = 0.61803398875;\n\nuniform bool ANIMATE_NOISE = false; // Animated Noise : (speed of animated noise)\nuniform int TARGET_BITS = 3; // Bit Depth : (amount of bit depth reduction), min=1, max=8\nuniform bool DITHER_IN_LINEAR_SPACE = false; // Dither in Linear : (dither in linear)\nuniform bool show_only_noise; // Noise Only : (outputs just the blue noise)\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    vec2 uv = fragCoord.xy/res.xy;\n    vec3 fg = texture2D( iChannel0, uv ).rgb;\n    vec3 col = vec3(0.0);\n    // get blue noise \"random\" number\n    vec2 blueNoiseUV = fragCoord.xy / vec2(1024.0);\n    vec3 blueNoise = texture2D(iChannel1, blueNoiseUV).rgb;\n    if ( ANIMATE_NOISE )\n      blueNoise = fract(blueNoise + float(MyTime) * c_goldenRatioConjugate);\n\n    // dither to the specified number of bits, using sRGB conversions if desired\n    if( DITHER_IN_LINEAR_SPACE )\n    \tfg = pow(fg, vec3(2.2));\n\n    float scale = exp2(float(TARGET_BITS)) - 1.0;\n    col = floor(fg*scale + blueNoise)/scale;\n\n    if( DITHER_IN_LINEAR_SPACE )\n    \tcol = pow(col, 1.0/vec3(2.2));\n\n    if ( show_only_noise )\n      col = blueNoise;\n\n    fragColor = vec4(col,1.0);\n}\n")
        del param

    param = lastNode.getParam("mipmap0")
    if param is not None:
        param.set("nearest")
        del param

    param = lastNode.getParam("inputLabel0")
    if param is not None:
        param.setValue("Source")
        del param

    param = lastNode.getParam("mipmap1")
    if param is not None:
        param.set("linear")
        del param

    param = lastNode.getParam("wrap1")
    if param is not None:
        param.set("clamp")
        del param

    param = lastNode.getParam("inputLabel1")
    if param is not None:
        param.setValue("pass1_result")
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
        param.setValue("time")
        del param

    param = lastNode.getParam("paramLabel0")
    if param is not None:
        param.setValue("Speed :")
        del param

    param = lastNode.getParam("paramHint0")
    if param is not None:
        param.setValue("speed")
        del param

    param = lastNode.getParam("paramDefaultFloat0")
    if param is not None:
        param.setValue(1, 0)
        del param

    param = lastNode.getParam("paramMinFloat0")
    if param is not None:
        param.setValue(0.09999999999999999, 0)
        del param

    param = lastNode.getParam("paramMaxFloat0")
    if param is not None:
        param.setValue(99.99999999999999, 0)
        del param

    param = lastNode.getParam("paramType1")
    if param is not None:
        param.set("bool")
        del param

    param = lastNode.getParam("paramName1")
    if param is not None:
        param.setValue("ANIMATE_NOISE")
        del param

    param = lastNode.getParam("paramLabel1")
    if param is not None:
        param.setValue("Animated Noise :")
        del param

    param = lastNode.getParam("paramHint1")
    if param is not None:
        param.setValue("animated noise")
        del param

    param = lastNode.getParam("paramType2")
    if param is not None:
        param.set("int")
        del param

    param = lastNode.getParam("paramName2")
    if param is not None:
        param.setValue("TARGET_BITS")
        del param

    param = lastNode.getParam("paramLabel2")
    if param is not None:
        param.setValue("Bit Depth :")
        del param

    param = lastNode.getParam("paramHint2")
    if param is not None:
        param.setValue("bit depth")
        del param

    param = lastNode.getParam("paramDefaultInt2")
    if param is not None:
        param.setValue(3, 0)
        del param

    param = lastNode.getParam("paramMinInt2")
    if param is not None:
        param.setValue(1, 0)
        del param

    param = lastNode.getParam("paramMaxInt2")
    if param is not None:
        param.setValue(8, 0)
        del param

    param = lastNode.getParam("paramType3")
    if param is not None:
        param.set("bool")
        del param

    param = lastNode.getParam("paramName3")
    if param is not None:
        param.setValue("DITHER_IN_LINEAR_SPACE")
        del param

    param = lastNode.getParam("paramLabel3")
    if param is not None:
        param.setValue("Dither in Linear :")
        del param

    param = lastNode.getParam("paramHint3")
    if param is not None:
        param.setValue("dither in linear")
        del param

    param = lastNode.getParam("paramType4")
    if param is not None:
        param.set("bool")
        del param

    param = lastNode.getParam("paramName4")
    if param is not None:
        param.setValue("show_only_noise")
        del param

    param = lastNode.getParam("paramLabel4")
    if param is not None:
        param.setValue("Noise Only :")
        del param

    param = lastNode.getParam("paramHint4")
    if param is not None:
        param.setValue("show noise only")
        del param

    del lastNode
    # End of node "Shader_pass2"

    # Start of node "Texture"
    lastNode = app.createNode("fr.inria.built-in.Input", 1, group)
    lastNode.setScriptName("Texture")
    lastNode.setLabel("Texture")
    lastNode.setPosition(4343, 3426)
    lastNode.setSize(80, 34)
    lastNode.setColor(0.702, 0.702, 0.702)
    groupTexture = lastNode

    del lastNode
    # End of node "Texture"

    # Start of node "Source"
    lastNode = app.createNode("fr.inria.built-in.Input", 1, group)
    lastNode.setScriptName("Source")
    lastNode.setLabel("Source")
    lastNode.setPosition(4502, 3431)
    lastNode.setSize(80, 34)
    lastNode.setColor(0.702, 0.702, 0.702)
    groupSource = lastNode

    del lastNode
    # End of node "Source"

    # Start of node "Dot1"
    lastNode = app.createNode("fr.inria.built-in.Dot", 1, group)
    lastNode.setScriptName("Dot1")
    lastNode.setLabel("Dot1")
    lastNode.setPosition(4535, 3736)
    lastNode.setSize(15, 15)
    lastNode.setColor(0.7, 0.7, 0.7)
    groupDot1 = lastNode

    del lastNode
    # End of node "Dot1"

    # Now that all nodes are created we can connect them together, restore expressions
    groupOutput1.connectInput(0, groupShader_pass2)
    groupShader_pass1.connectInput(0, groupTexture)
    groupShader_pass2.connectInput(0, groupDot1)
    groupShader_pass2.connectInput(1, groupShader_pass1)
    groupDot1.connectInput(0, groupSource)

    param = groupShader_pass2.getParam("paramValueFloat0")
    group.getParam("Shader_pass2paramValueFloat0").setAsAlias(param)
    del param
    param = groupShader_pass2.getParam("paramValueBool1")
    group.getParam("Shader_pass2paramValueBool1").setAsAlias(param)
    del param
    param = groupShader_pass2.getParam("paramValueInt2")
    group.getParam("Shader_pass2paramValueInt2").setAsAlias(param)
    del param
    param = groupShader_pass2.getParam("paramValueBool3")
    group.getParam("Shader_pass2paramValueBool3").setAsAlias(param)
    del param
    param = groupShader_pass2.getParam("paramValueBool4")
    group.getParam("Shader_pass2paramValueBool4").setAsAlias(param)
    del param

    try:
        extModule = sys.modules["Crok_blue_noise_GLExt"]
    except KeyError:
        extModule = None
    if extModule is not None and hasattr(extModule ,"createInstanceExt") and hasattr(extModule.createInstanceExt,"__call__"):
        extModule.createInstanceExt(app,group)
