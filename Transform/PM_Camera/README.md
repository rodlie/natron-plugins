# Poor's Man 3D Camera

## Set a 3D camera to be used with PM_Card3D

The main use is to import .chan files. But you can set the camera position and rotation using the sliders in the Transform panel.

### .chan import
.chan is the Nuke format to import/export camera and animation between software.
This Plugin as been tested and developped to be used with Blender's .chan exporter. And not tested yet with other applications.
Blender .chan exporter is shipped with blender but not activated by default.

At that time, only the XYZ rotation order is supported (this is blender .chan exporter default)

Also , the importer is set to Y up. If you use blender , you can just export the camera as a .chan file leaving the parameters by default and you should be good.

If your camera as a different sensor size than the default (32),that can be the case for instance if you do camera tracking , you should change the sensor size value in the Pyplug, because this information is not contained in the .chan file.

## Technical infos :

The FOV is the vertical Field Of View.

The sensor size is the horizontal sensor size.

This Pyplug create the camera coordinates(matrix) and send it to a Card3D node using colors. So if you connect the node to a viewer you should see the colors that contains camera informations.

more information on the Card3D page

![Screenshot](Resources/3DCard_01.jpg)

plugin original implementation by Sozap, with many help from this site : https://www.scratchapixel.com/
