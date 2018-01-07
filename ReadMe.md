# EMsoft SDK Superbuild #

## IMPORTANT NOTE ##

If you find bugs and fix them **PLEASE** consider submitting a "Pull Request" from your fork to the official repository. This will allow the entire EMsoft community to benefit from your bug fixes.

## Introduction ##

This cmake project will build an EMsoft SDK by downloading all the necessary 3rd party 
libraries as prebuilt binaries or as source code and compiling those libraries. 

## Prerequisites ##

+ CMake 3.9.x installed on system
+ Compiler Suite installed on system
+ Fortran compiler installed on system
+ Git installed on the system


## Supported Platforms ##

| Operating System | C/C++ Compiler | Fortran Compiler |
|------------------|----------------|------------------|
| macOS (10.12) | Xcode Native tools (8.3.x) | GFortran 6.3.0 and above |
| Windows (10) | Visual Studio 2015 (CE/Pro) | Intel Fortran v17 |
| Linux (Ubuntu 16.x, CentOS 7.x) | GCC 4.8 and Above, Clang 3.8 and greater | GFortran 5.2 and above |

## Git Locations ##

Git verison 2.x is pretty much required.

| Operating System |  Notes  |
|------------------|--------------|
| macOS (10.12) | CLI comes with Xcode, (SourceTree)[http://www.sourcetreeapp.com] for a nice GUI application |
| Windows (10) | (SourceTree)[http://www.sourcetreeapp.com]. Download and install the app  |
| Linux (Ubuntu 16.x, CentOS 7.x) | Use your package manager to install git.|

## Libraries that are Compiled ##

| Library | Version | Notes |
|---------|---------|-------|
| HDF5 | 1.8.19 | Compiled from Source |
| CLFortran | 0.0.1 | Compiled from Source on GitHub |
| FFTW | 3.3.4 | Precompiled (Windows) or Compiled (macOS/Linux) |
| Json-Fortran | 4.2.1 | Compiled from source on GitHub |
| Eigen | 3.2.9 | Compiled from Source |
| Qt 5 | 5.9.3 | Precompiled Binaries from www.qt.io |

## Instructions ##


1. Install your compiler tools
2. Install CMake on your system
3. Install a Fortran compiler on your system
4. Install Git on your system
1. Clone this repository onto your hard disk.
2. open a terminal and invoke the following commands

        cd EMsoftSuperbuild
        mkdir Debug
        cd Debug
        cmake -DEMsoft_SDK=/Some/Path/To/EMsoft_SDK -DCMAKE_BUILD_TYPE=Debug ../
        make -j
        cd ../
        mkdir Release
        cd Release
        cmake -DEMsoft_SDK=/Some/Path/To/EMsoft_SDK -DCMAKE_BUILD_TYPE=Release ../
        make -j

3. The initial run of CMake is going to take a **REALLY** long time because it will be downloading the full Qt 5.9.3 installer which is about 3~4 GB in size. On macOS systems it then must verify the .dmg, mount it and run the installer (which verifies the .app). Go get coffee. Compiling (the 'make -j' part) should not take that long, only about 5 minutes or so.

**Note**: There is a known issue where the Qt installer will *NOT* execute during the Linux install. This is currently being looked at.

The developer can use CMakeGui if they would like instead of the command lines. The only required variable are the path to where you want the EMsoft_SDK folder and the build type (Debug or Release)


Once the SDK builds correctly, no errors are reported on the command line, then the developer can proceed to clone and build EMsoft itself.
