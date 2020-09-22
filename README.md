# setMultimonitorBackground
Sets the background in a multimonitor set up under Cinammon with either one image spanned across or one image per monitor

It receives only one parameter which can be
- A single image file name : The script resizes and shaves the image to fit the screeens
- A directory with potential files: the script selects randomly one file per monitor.

Either
setMultimonitorBackground <imagefile>
  or
setMultimonitorBackground <directory>
  
If the parameter is a directory, the script will choose randomly one file per monitor.

Note: Files are scaled and shaved to fit the display area without loosing aspect radio.

Requires:
  ImageMagick
  xrandr
