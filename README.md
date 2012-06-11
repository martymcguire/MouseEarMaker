MouseEarMaker
=============

3D printing is a lot of fun - unless your long, skinny objects curl away from
the build platform and your prints fail!

["Mouse ears"](http://www.makerbot.com/blog/2011/02/25/mouse-ears-defeat-corner-curling-monster/) are a great way to combat this curling - a small circle of plastic keeps your sharp corners or long, thin parts from pulling away from the build platform.

MouseEarMaker is a [Processing](http://www.processing.org/) sketch that make it easy to
add "mouse ears" to your STL files.

MouseEarMaker was created by Marty McGuire during the weekend of June 8-10 2012 at the [2012 Baltimore Hackathon](http://baltimorehackathon.com/).

Requirements
============

MouseEarMaker was built and tested on Mac OS X using the following software:

* [Processing v1.5.1](http://processing.org/download/)
* [toxiclibs 0020 for Processing](http://hg.postspectacular.com/toxiclibs/downloads/) (unzip into your Processing `libraries/` directory.
* [OpenSCAD 2011.12](http://www.openscad.org/) - installed via pre-compiled OS X binaries in `/Applications/OpenSCAD.app`.

Usage
=====

### Start up:

1. Open the MouseEarMaker sketch in Processing and run it.
2. Select your STL file from the Open File dialog.
3. You'll see a 2D view of the bottom of your model - everywhere that it touches the build platform.

### Placing Mouse Ears

![Placing some mouse ears](https://raw.github.com/martymcguire/MouseEarMaker/master/screenshots/screenshot1.png)

1. Click to place a mouse ear. Drag to make the mouse ear bigger or smaller.
2. Made a mistake? `⌘-z` will undo the last mouse ear.
3. Finished? Press `⌘-s` to open the Save dialog.
4. Choose a name for your new STL file.
5. MouseEarMaker will generate a new OpenSCAD (`.scad`) file and run OpenSCAD to produce your mouse ear'd STL!
6. Open the new STL in your favorite 3D printing software to slice and print!

Troubleshooting
===============

### It doesn't run...

Make sure the toxiclibs are installed in your Processing installations `libraries` folder.

### If your initial STL doesn't load...

MouseEarMaker uses toxiclibs for reading STLs. It currently only supports **binary format STLs**.  ASCII format STL files are not supported.

### If your new STL file doesn't appear...

OpenSCAD doesn't like every STL file. To see if OpenSCAD is choking on your file, try loading it up on a test program like the following:

```
import_stl("/path/to/your.stl");
```

Render by pressing `F6` and make sure that OpenSCAD doesn't give you any errors.  If OpenSCAD complains, try cleaning up the model with Meshlab, NetFabb Basic, etc.

### Other Problem?

* Check the console log for errors!

TODOs
=====

* Find a way to create the final geometry in Processing
  * Maybe do some nice BSP stuff for the union like [CSG.js](https://github.com/evanw/csg.js)
* Write an ASCII STL parser for toxiclibs :)

License
=======

The MIT License (MIT)
Copyright (c) 2012 Marty McGuire

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
