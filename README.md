# Volume Layers for Godot

[![Video - overview](https://img.youtube.com/vi/1IvKWIieZPM/0.jpg)](https://www.youtube.com/watch?v=1IvKWIieZPM)
[![Video - using the cutting planes](https://img.youtube.com/vi/FzYEshB9TFQ/0.jpg)](https://www.youtube.com/watch?v=FzYEshB9TFQ)

This is an addon for Godot that lets you view volumetric data, such as MRI scans.

This addon uses zipped files of 2D images as source data, so any 3D volumetric files such as.nii will need to be converted to this first.  Online programs such as https://www.onlineconverter.com/nifti-to-png can be used to convert your data.

![Shader in editor viewport](docs/editor_screenshot.png)

## Installation

Copy the /addons/volume_layered_shader into your project in a directory of the same name.

Make sure the addon is enabled in the Project Settigns/Plugins window.

## Usage

Create a new instance of the addon by clicking the + button in the Scene window and selecting VolumeLayeredShader.

You can set the image volume used by clicking in the Texture field and selecting New ZippedImageArchiveCpuTexture3D.  This will create a new 3D texture object with a field called Zip File.  You can now browse to your zip file containing your texture data.

![Inspector shader](docs/volume_layer_inspector_panel.png)

* Texture - A Texture3D that contains the volumetric data to view.
* Num Layers - The number of slices to make parallel to the camera.  The more slices, the higher the resolution.
* Gamma - Adjusts the sharpness of the texture data.  Smaller values bring out soft areas while larger values bring out hard areas.
* Opacity - Multiplies the opacity of the final pixel.
* Color Scalar - Multiplies the color of the gradient.  Used to boost the strength of the gradient.
* Gradient - Colors the pixels of the volume.  Softer values will be colored with values on the left of the gradient and harder values will be colored with values from the right side of the gradient.  It is recommended you make the left side of the gradient transparent so low density pixels are clear.
* Exclusion Planes - Any node added to this array will act as a plane that cuts away part of the model to make it easier to see the interior.  These nodes can be placed anywhere in your scene.  Marker3D is the recommended object type, but any object that extends Node3D can act as a clipping plane.

## Acknowledgments

Iguana MRI data taken from the niivue-images archive:

https://github.com/neurolabusc/niivue-images/tree/main


## Support

If you found this software useful, please consider buying me a coffee on Kofi.  Every contribution helps me to make more software:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Y8Y43J6OB)

