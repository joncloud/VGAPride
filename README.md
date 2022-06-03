# VGAPride
 An MS-DOS application for showing Pride Flags

Usage: ```VGAPRIDE <FLAGNAME>```

Type ```VGAPRIDE LIST | MORE``` to see a list of included flags

# Building

This project uses Borland Turbo C++ 3.0.

The `build.cmd` batch script automates the build process. It relies on the `%CD%\.borland\drivec` directory existing with the compiler already installed, e.g., the `TC` directory and all of its binaries are present.

In addition it requires several additional dependencies:

* [curl](https://curl.se/windows/) - Modern versions of windows include this already
* [DOSBox-X](https://dosbox-x.com/)
* [7z](https://www.7-zip.org/download.html)
* [upx](https://upx.github.io/)

## Building Manually

1. First, you need to create the EGAVGA.OBJ file. Use the BGIOBJ.EXE file in TC\BGI to compile it with ```BGIOBJ EGAVGA```
2. Copy the resulting OBJ file into the main project directory
3. switch to that directory (I used C:\VGAPRIDE)
4. Open the project with "tc vgapride.prj"
5. Select Compile->Build All from the menus to build the EXE.
6. Run UPX (I used 3.96) to compress the EXE

# License

The code is licensed under the terms of the GPL, version 3.
